//
//  CoordinatorFactory.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol CoordinatorFactory {
    func generateTabbarCoordinator() -> (presentable: Presentable?, coordinator: Coordinator)
    func generateHomeTimeLineCoordinator(navigationController: UINavigationController?) -> Coordinator
}
