//
//  TabbarController.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//
import UIKit
import RxSwift

final class TabbarController: UITabBarController, UITabBarControllerDelegate, TabbarViewProtocol {

    enum SelectTabNumber: Int {
        case homeTimeLine = 0
        case trendLike
        case trendReTweet
        case accountDetail
    }
    
    private var selectHomeTimeLineTabObserver = PublishSubject<UINavigationController>()
    lazy var selectHomeTimeLineTabObservable: Observable<UINavigationController> =
        self.selectHomeTimeLineTabObserver.asObservable()
    
    private var selectTrendLikeTweetListTabObserver = PublishSubject<UINavigationController>()
    lazy var selectTrendLikeTweetListTabObservable: Observable<UINavigationController> =
        self.selectTrendLikeTweetListTabObserver.asObservable()
    
    private var selectTrendReTweetTimeLineTabObserver = PublishSubject<UINavigationController>()
    lazy var selectTrendReTweetTimeLineTabObservable: Observable<UINavigationController> =
        self.selectTrendReTweetTimeLineTabObserver.asObservable()
    
    private var selectAccountDetailTabObserver = PublishSubject<UINavigationController>()
    var selectAccountDetailTabObservable: Observable<UINavigationController> {
        return selectHomeTimeLineTabObserver.asObservable()
    }
    
    private var loadTabbarObserver = PublishSubject<UINavigationController>()
    var loadTabbarObservable: Observable<UINavigationController> {
        return loadTabbarObserver.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        if let navigationController = customizableViewControllers?.first as? UINavigationController {
            loadTabbarObserver.onNext(navigationController)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navigationController = viewControllers?[selectedIndex] as? UINavigationController,
            let tabRoot = SelectTabNumber(rawValue: selectedIndex) else {
            return
        }
        
        switch tabRoot {
        case .homeTimeLine:
            selectHomeTimeLineTabObserver.onNext(navigationController)
        case .trendLike:
            selectTrendLikeTweetListTabObserver.onNext(navigationController)
        case .trendReTweet:
            selectTrendReTweetTimeLineTabObserver.onNext(navigationController)
        case .accountDetail:
            selectAccountDetailTabObserver.onNext(navigationController)
        }
        
    }

}
