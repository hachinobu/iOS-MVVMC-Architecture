//
//  UserTimeLineViewModel.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/06/01.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import Accounts

final class UserTimeLineViewModel: TimeLineViewModel {
    
    private let bag = DisposeBag()
    
    lazy var authStatus: Driver<AuthenticateTwitter.AuthStatus> = {
        return self.authTwitter.currentStatus
    }()
    
    lazy var authError: Driver<Error?> = {
        return self.authTwitter.authError
    }()
    
    private let list: Variable<[Tweet]?> = Variable(nil)
    lazy var tweets: Driver<[TimeLineCellViewModel]> = {
        
        return self.list.asObservable()
            .withLatestFrom(self.fetchAction.inputs) { $0 }
            .scan([Tweet]()) { currentElements, nextFetchInfo -> [Tweet] in
                
                let results = nextFetchInfo.0
                let id: Int64? = nextFetchInfo.1
                
                if currentElements.isEmpty || id == nil {
                    return results!
                }
                
                if let id = id, let firstId = results?.first?.id, id > firstId {
                    return currentElements + results!
                }
                
                return currentElements
                
            }
            .map { try $0.map(HomeTimeLineViewModelTranslator()) }
            .asDriver(onErrorJustReturn: [])
        
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
    
    lazy var loadingIndicatorAnimation: Driver<Bool> = {
        return self.fetchAction.executing.shareReplayLatestWhileConnected().asDriver(onErrorJustReturn: false)
    }()
    
    private let fetchAction: Action<Int64?, [Tweet]>
    private let authTwitter = AuthenticateTwitter.sharedInstance
    
    private let fetchUserAction: Action<Void, User>
    
    private let user: Variable<User?> = Variable(nil)
    
    init(userId: String, viewWillAppear: Driver<Void>) {
        
        let account = authTwitter.currentAccount.asObservable()
        fetchAction = Action { sinceId in
            var parameters = ["user_id": userId]
            if let sinceId = sinceId {
                parameters["max_id"] = sinceId.description
            }
            return account
                .map { UserTimeLineRequest(account: $0, parameters: parameters) }
                .flatMap { TwitterApiClient.execute(request: $0) }
                .shareReplayLatestWhileConnected()
        }
        
        fetchUserAction = Action { _ in
            return account.map { UserDetailRequest(account: $0, parameters:  ["user_id": userId]) }
                .flatMap { TwitterApiClient.execute(request: $0) }
                .shareReplayLatestWhileConnected()
        }
        
//        viewWillAppear.asObservable()
//            .take(1)
//            .map { nil }
//            .subscribe(onNext: { [weak self] id in
//                self?.fetchAction.execute(id)
//            }).addDisposableTo(bag)
        
        let connect = Observable.zip(fetchAction.elements, fetchUserAction.elements)
            .shareReplayLatestWhileConnected()
        connect.map { $0.0 }.bind(to: list).addDisposableTo(bag)
        connect.map { $0.1 }.bind(to: user).addDisposableTo(bag)
        
        viewWillAppear.asObservable().take(1).subscribe(onNext: { _ in
            self.fetchAction.execute(nil)
            self.fetchUserAction.execute(())
        }).addDisposableTo(bag)
        
    }
    
    func bindRefresh(refresh: Driver<Void>) {
        
        refresh.asObservable()
            .withLatestFrom(loadingIndicatorAnimation.asObservable()) { (_, isRefresh) -> Bool in
                return isRefresh
            }.filter { !$0 }
            .map { _ in return nil }
            .bind(to: fetchAction.inputs)
            .addDisposableTo(bag)
        
    }
    
    func bindReachedBottom(reachedBottom: Driver<Void>) {
        
        reachedBottom.asObservable()
            .withLatestFrom(loadingIndicatorAnimation.asObservable()) { $0.1 }
            .filter { !$0 }
            .withLatestFrom(fetchAction.elements) { $0.1.last }
            .filter { $0 != nil }
            .map { tweet -> Int64 in
                let id = tweet!.id - 1
                return id
            }
            .bind(to: fetchAction.inputs)
            .addDisposableTo(bag)
        
    }
    
}
