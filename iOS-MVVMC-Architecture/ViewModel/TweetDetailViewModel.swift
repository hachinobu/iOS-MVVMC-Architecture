//
//  TweetDetailViewModel.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/05/21.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Accounts
import Action

final class TweetDetailViewModel: TweetDetailViewModelProtocol {
    
    private let bag = DisposeBag()
    
    lazy var authStatus: Driver<AuthenticateTwitter.AuthStatus> = {
        return self.authTwitter.currentStatus
    }()
    
    lazy var authError: Driver<Error?> = {
        return self.authTwitter.authError
    }()
    
    lazy var tweets: Driver<[TweetDetailCellViewModel]> = {
        return self.fetchAction.elements.asDriver(onErrorJustReturn: [])
    }()
    
    lazy var error: Driver<Error> = {
        self.fetchAction.errors.asDriver(onErrorDriveWith: .empty())
            .flatMap { error -> Driver<Error> in
                switch error {
                case .underlyingError(let error):
                    return Driver.just(error)
                case .notEnabled:
                    return Driver.empty()
                }
        }
    }()
    
    lazy var authAccount: Driver<ACAccount> = {
        return self.authTwitter.currentAccount
    }()
    
    private let fetchAction: Action<Int, [TweetDetailCellViewModel]>
    private let authTwitter = AuthenticateTwitter.sharedInstance
    
    init(tweetId: String, viewWillAppear: Driver<Void>) {
        
        let account = authTwitter.currentAccount.asObservable()
        fetchAction = Action { page in
            account
                .map { TweetDetailRequest(account: $0, parameters: ["id": tweetId]) }
                .flatMap { TwitterApiClient.execute(request: $0) }
                .map { try TweetDetailCellViewModelTranslator().translate($0) }
                .map { [$0] }
                .shareReplayLatestWhileConnected()
        }
        
        viewWillAppear.asObservable()
            .take(1)
            .map { 1 }
            .bind(to: fetchAction.inputs)
            .addDisposableTo(bag)
        
    }
    
}
