//
//  UserTimeLineViewModelProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/07.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxCocoa

protocol UserTimeLineViewModelProtocol: TimeLineViewModel {
    var userProfileViewModel: Driver<UserProfileViewModel> { get }
}
