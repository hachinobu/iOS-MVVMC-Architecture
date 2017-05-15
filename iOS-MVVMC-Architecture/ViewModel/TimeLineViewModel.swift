//
//  TimeLineViewModel.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/15.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Accounts

protocol TimeLineViewModel: class {
    
    var authStatus: Driver<AuthenticateTwitter.AuthStatus> { get }
    var authError: Driver<Error?> { get }
    var tweets: Driver<[Tweet]> { get }
    var error: Driver<Error> { get }
    var authAccount: Driver<ACAccount> { get }
    
}