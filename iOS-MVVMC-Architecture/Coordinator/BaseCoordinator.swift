//
//  BaseCoordinator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

class BaseCoordinator: Coordinator, DependencyCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    
    func addDependency(coordinator: Coordinator) {
        if childCoordinators.contains(where: { $0 === coordinator }) {
            return
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(coordinator: Coordinator?) {
        guard let coordinator = coordinator else {
            return
        }
        guard let index = childCoordinators.index(where: { $0 === coordinator}) else {
            return
        }
        childCoordinators.remove(at: index)
    }
    
}
