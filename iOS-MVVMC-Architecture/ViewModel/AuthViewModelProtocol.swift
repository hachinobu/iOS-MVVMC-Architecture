//
//  AuthViewModelProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/06/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxCocoa
import Accounts

protocol AuthViewModelProtocol {
    var authStatus: Driver<AuthenticateTwitter.AuthStatus> { get }
    var authError: Driver<Error?> { get }
    var authAccount: Driver<ACAccount> { get }
}

extension AuthViewModelProtocol {
    
    var authStatus: Driver<AuthenticateTwitter.AuthStatus> {
        return AuthenticateTwitter.sharedInstance.currentStatus
            .shareReplayLatestWhileConnected()
            .asDriver(onErrorDriveWith: .empty())
    }
    
    var authError: Driver<Error?> {
        return AuthenticateTwitter.sharedInstance.authError
    }
    
    var authAccount: Driver<ACAccount> {
        return AuthenticateTwitter.sharedInstance.currentAccount
    }
    
}
