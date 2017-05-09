//
//  AppCoordinator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/05/09.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    fileprivate let ACCOUNT_LIST_KEY = "AccountList"
    fileprivate let HOME_TIMELINE = "HomeTimeLine"
    
    var window: UIWindow
    var coordinators: [String: Coordinator] = [:]
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
    }
    
}
