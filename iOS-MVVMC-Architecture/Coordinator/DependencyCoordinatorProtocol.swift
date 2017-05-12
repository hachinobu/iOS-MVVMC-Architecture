//
//  DependencyCoordinatorProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol DependencyCoordinatorProtocol: class {
    var childCoordinators: [Coordinator] { get set }
    
    func addDependency(coordinator: Coordinator)
    func removeDependency(coordinator: Coordinator?)
}
