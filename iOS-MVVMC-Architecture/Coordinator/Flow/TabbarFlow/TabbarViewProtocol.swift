//
//  TabbarViewProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

protocol TabbarViewProtocol: class {
    var selectHomeTimeLineTabObservable: Observable<UINavigationController> { get }
    var selectTrendLikeTweetListTabObservable: Observable<UINavigationController> { get }
    var selectAccountDetailTabObservable: Observable<UINavigationController> { get }
    var loadTabbarObservable: Observable<UINavigationController> { get }
}
