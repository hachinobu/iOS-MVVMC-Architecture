//
//  HomeTimeLineViewModel.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/26.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Accounts
import Action

class HomeTimeLineViewModel {
    
    private let bag = DisposeBag()
    
    var tweets: Driver<[Tweet]> {
        return fetchAction.elements.asDriver(onErrorJustReturn: [])
    }
    
    var error: Driver<Error> {
        
        return fetchAction.errors.asDriver(onErrorDriveWith: .empty())
            .flatMap { error -> Driver<Error> in
                switch error {
                case .underlyingError(let error):
                    return Driver.just(error)
                case .notEnabled:
                    return Driver.empty()
                }
        }
        
    }
    
    var authStatus: Driver<AuthenticateTwitter.AuthStatus> {
        return authTwitter.currentStatus
    }
    
    var authError: Driver<Error?> {
        return authTwitter.authError
    }
    
    var authAccount: Driver<ACAccount> {
        return authTwitter.currentAccount
    }
    
    private let fetchAction: Action<Int, [Tweet]>
    
    private(set) var fetchActionTrigger = PublishSubject<Int>()
    
    private let authTwitter = AuthenticateTwitter.sharedInstance
    
    init() {
        
        let account = authTwitter.currentAccount.asObservable()
        self.fetchAction = Action { page in
            account
                .map { HomeTimelineRequest(account: $0, parameters: [:]) }
                .flatMap { TwitterApiClient.execute(request: $0) }
                .shareReplayLatestWhileConnected()
        }
        
        fetchActionTrigger.bind(to: fetchAction.inputs).addDisposableTo(bag)
        
    }
    
    
}
