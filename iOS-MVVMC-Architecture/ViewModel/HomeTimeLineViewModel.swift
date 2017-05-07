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
    
    let authStatus: Driver<AuthenticateTwitter.AuthStatus>
    let authError: Driver<Error?>
    
    let tweets: Driver<[Tweet]>
    let error: Driver<Error>
    
    
    
    var authAccount: Driver<ACAccount> {
        return authTwitter.currentAccount
    }
    
    private let fetchAction: Action<Int, [Tweet]>
    
    private(set) var fetchActionTrigger = PublishSubject<Int>()
    
    private let authTwitter = AuthenticateTwitter.sharedInstance
    
    init(viewDidLoad: Driver<Void>) {
        
        let account = authTwitter.currentAccount.asObservable()
        fetchAction = Action { page in
            account
                .map { HomeTimelineRequest(account: $0, parameters: [:]) }
                .flatMap { TwitterApiClient.execute(request: $0) }
                .shareReplayLatestWhileConnected()
        }
        
        authStatus = authTwitter.currentStatus
        authError = authTwitter.authError
        
        tweets = fetchAction.elements.asDriver(onErrorJustReturn: [])
        
        error = fetchAction.errors.asDriver(onErrorDriveWith: .empty())
            .flatMap { error -> Driver<Error> in
                switch error {
                case .underlyingError(let error):
                    return Driver.just(error)
                case .notEnabled:
                    return Driver.empty()
                }
        }
        
        viewDidLoad.asObservable()
            .map { 1 }
            .bind(to: fetchAction.inputs)
            .addDisposableTo(bag)
        
    }
    
    
}
