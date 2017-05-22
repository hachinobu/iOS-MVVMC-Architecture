//
//  HomeTimeLineCoordinator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class HomeTimeLineCoordinator: BaseCoordinator {
    
    private let bag = DisposeBag()
    
    private let viewFactory: HomeTimeLineViewFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(viewFactory: HomeTimeLineViewFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.viewFactory = viewFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        presentHomeTimeLine()
    }
    
    private func presentHomeTimeLine() {
        
        let homeTimeLineView = viewFactory.generateHomeTimeLineView()
//        homeTimeLineView.viewModel.bindReachedBottom(reachedBottom: homeTimeLineView.reachedBottom.asDriver())
        homeTimeLineView.selectedItem.subscribe(onNext: { [weak self] id in
            self?.showDetail(tweetId: id)
        }).addDisposableTo(bag)
        
        homeTimeLineView.reachedBottom.subscribe(onNext: { _ in
            print("reachedBottom")
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: homeTimeLineView, hideBar: false)
        
    }
    
    private func showDetail(tweetId: String) {
        let tweetDetailView = viewFactory.generateTweetDetailView(tweetId: tweetId)
        tweetDetailView.selectedUser.subscribe(onNext: { id in
            print(id)
        }).addDisposableTo(bag)
        
        router.push(presentable: tweetDetailView, animated: true, completion: nil)
    }
    
}
