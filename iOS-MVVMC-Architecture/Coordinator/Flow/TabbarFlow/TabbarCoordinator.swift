//
//  TabbarCoordinator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class TabbarCoordinator: BaseCoordinator {
    
    private let bag = DisposeBag()
    
    private let tabbarView: TabbarViewProtocol
    private let coordinatorFactory: CoordinatorFactory
    
    init(tabbarView: TabbarViewProtocol, coordinatorFactory: CoordinatorFactory) {
        self.tabbarView = tabbarView
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        
        tabbarView.loadTabbarObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runHomeTimeLineFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        tabbarView.selectHomeTimeLineTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runHomeTimeLineFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        tabbarView.selectTrendLikeTweetListTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runTrendLikeListFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
    }
    
    private func runHomeTimeLineFlow(navigationController: UINavigationController) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = self.coordinatorFactory.generateHomeTimeLineCoordinator(navigationController: navigationController)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
    private func runTrendLikeListFlow(navigationController: UINavigationController) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateTrendLikeTweetTimeLineCoordinator(navigationController: navigationController)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
}
