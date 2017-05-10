//
//  Router.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/10.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol Router: Presentable {
    
    func present(presentable: Presentable?, animated: Bool)
    func push(presentable: Presentable?, animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func setRoot(presentable: Presentable?, hideBar: Bool)
    func popToRoot(animated: Bool)
    
}
