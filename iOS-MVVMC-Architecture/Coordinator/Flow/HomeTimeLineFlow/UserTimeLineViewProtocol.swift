//
//  UserTimeLineViewProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/07.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

protocol UserTimeLineViewProtocol: TimeLineViewProtocol {
    var viewModel: UserTimeLineViewModelProtocol! { get }
    var showFollowingList: Observable<String> { get }
    var showFollowerList: Observable<String> { get }
}
