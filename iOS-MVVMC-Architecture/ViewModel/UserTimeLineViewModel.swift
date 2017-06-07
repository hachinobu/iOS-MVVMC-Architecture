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

final class UserTimeLineViewModel: UserTimeLineViewModelProtocol {
    
    private let bag = DisposeBag()
    
    lazy var authStatus: Driver<AuthenticateTwitter.AuthStatus> = {
        return self.authTwitter.currentStatus
            .shareReplayLatestWhileConnected()
            .asDriver(onErrorDriveWith: .empty())
    }()
    
    lazy var authError: Driver<Error?> = {
        return self.authTwitter.authError
    }()
    
    private let list: Variable<[Tweet]?> = Variable(nil)
    lazy var tweets: Driver<[TimeLineCellViewModel]> = {
        return self.list.asObservable()
            .filter { $0 != nil }
            .map { $0! }
            .map { try $0.map(HomeTimeLineViewModelTranslator()) }
            .asDriver(onErrorJustReturn: [])
    }()
    
    lazy var error: Driver<Error> = {
        self.fetchTimeLineAction.errors.asDriver(onErrorDriveWith: .empty())
            .flatMap { error -> Driver<Error> in
                switch error {
                case .underlyingError(let error):
                    return Driver.just(error)
                case .notEnabled:
                    return Driver.empty()
                }
        }
    }()
    
    private let user: Variable<User?> = Variable(nil)
    lazy var userProfileViewModel: Driver<UserProfileViewModel> = {
        return self.user.asObservable()
            .filter { $0 != nil }
            .map { $0! }
            .map { try UserProfileViewModelTranslator().translate($0) }
            .asDriver(onErrorDriveWith: Driver.empty())
    }()
    
    lazy var authAccount: Driver<ACAccount> = {
        return self.authTwitter.currentAccount
    }()
    
    lazy var loadingIndicatorAnimation: Driver<Bool> = {
        return self.fetchTimeLineAction.executing.shareReplayLatestWhileConnected().asDriver(onErrorJustReturn: false)
    }()
    
    private let fetchTimeLineAction: Action<Int64?, [Tweet]>
    private let authTwitter = AuthenticateTwitter.sharedInstance
    
    private let fetchUserAction: Action<Void, User>
    
    init(userId: String, viewWillAppear: Driver<Void>) {
        
        let account = authTwitter.currentAccount.asObservable()
        fetchTimeLineAction = Action { sinceId in
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
        
        let connect = Observable.zip(fetchTimeLineAction.elements, fetchUserAction.elements)
            .withLatestFrom(fetchTimeLineAction.inputs) { $0 }
            .filter { $0.1 == nil }
            .shareReplayLatestWhileConnected()
        connect.map { $0.0.0 }.bind(to: list).addDisposableTo(bag)
        connect.map { $0.0.1 }.bind(to: user).addDisposableTo(bag)
        
        viewWillAppear.asObservable().take(1).subscribe(onNext: { [weak self] _ in
            self?.fetchTimeLineAction.execute(nil)
            self?.fetchUserAction.execute(())
        }).addDisposableTo(bag)
        
        fetchTimeLineAction.elements.withLatestFrom(fetchTimeLineAction.inputs) { $0 }
            .filter { $0.1 != nil }
            .withLatestFrom(list.asObservable()) { (infos, currents) -> [Tweet]? in
            if let lastId = currents?.last?.id, let firstId = infos.0.first?.id, lastId > firstId {
                return currents! + infos.0
            }
            return infos.0
        }.bind(to: list).addDisposableTo(bag)
        
    }
    
    func bindRefresh(refresh: Driver<Void>) {
        
        refresh.asObservable()
            .withLatestFrom(loadingIndicatorAnimation.asObservable())
            .filter { !$0 }
            .subscribe(onNext: { [weak self] _ in
                self?.fetchTimeLineAction.execute(nil)
                self?.fetchUserAction.execute(())
            }).addDisposableTo(bag)
        
    }
    
    func bindReachedBottom(reachedBottom: Driver<Void>) {
        
        reachedBottom.asObservable()
            .withLatestFrom(loadingIndicatorAnimation.asObservable()) { $0.1 }
            .filter { !$0 }
            .withLatestFrom(fetchTimeLineAction.elements) { $0.1.last }
            .filter { $0 != nil }
            .map { tweet -> Int64 in
                let id = tweet!.id - 1
                return id
            }
            .bind(to: fetchTimeLineAction.inputs)
            .addDisposableTo(bag)
        
    }
    
}
