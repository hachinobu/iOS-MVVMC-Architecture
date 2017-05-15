//
//  AppCoordinator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/05/09.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class AppCoordinator: BaseCoordinator {

    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        runMainTabbarFlow()
    }
    
    private func runMainTabbarFlow() {
        let (presentable, coordinator) = coordinatorFactory.generateTabbarCoordinator()
        addDependency(coordinator: coordinator)
        router.setRoot(presentable: presentable, hideBar: true)
        coordinator.start()
    }
    
}
