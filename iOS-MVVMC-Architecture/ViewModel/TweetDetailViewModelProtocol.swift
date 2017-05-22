//
//  TweetDetailViewModelProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/05/21.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Accounts

protocol TweetDetailViewModelProtocol: class {
    
    var authStatus: Driver<AuthenticateTwitter.AuthStatus> { get }
    var authError: Driver<Error?> { get }
    var tweets: Driver<[TweetDetailCellViewModel]> { get }
    var error: Driver<Error> { get }
    var authAccount: Driver<ACAccount> { get }
    
}

