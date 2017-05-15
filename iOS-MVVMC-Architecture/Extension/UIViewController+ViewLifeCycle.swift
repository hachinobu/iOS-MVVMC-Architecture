//
//  UIViewController+ViewLifeCycle.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/15.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxCocoa

protocol ViewLifeCycle {
    var viewDidLoad: ControlEvent<Void> { get }
    var viewWillAppear: ControlEvent<Void> { get }
    var viewDidAppear: ControlEvent<Void> { get }
}

extension ViewLifeCycle where Self: UIViewController {
    
    var viewDidLoad: ControlEvent<Void> {
        return rx.viewDidLoad
    }
    
    var viewWillAppear: ControlEvent<Void> {
        return rx.viewWillAppear
    }
    
    var viewDidAppear: ControlEvent<Void> {
        return rx.viewDidAppear
    }
    
}
