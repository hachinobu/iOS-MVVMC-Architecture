//
//  CoordinatorFactoryImpl.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class CoordinatorFactoryImpl: CoordinatorFactory {
    
    func generateTabbarCoordinator() -> (presentable: Presentable?, coordinator: Coordinator) {
        let tabbarController = UIStoryboard.instantiateViewController(withType: TabbarController.self)
        let tabbarCoordinator = TabbarCoordinator(tabbarView: tabbarController, coordinatorFactory: CoordinatorFactoryImpl())
        return (tabbarController, tabbarCoordinator)
    }
    
    func generateHomeTimeLineCoordinator(navigationController: UINavigationController?) -> Coordinator {
        let nav = navigationController ?? UINavigationController()
        return HomeTimeLineCoordinator(viewFactory: ViewFactoryImpl(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: nav))
    }
    
}
