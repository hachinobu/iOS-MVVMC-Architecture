//
//  UserListViewModel.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/14.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Action

class UserListViewModel: UserListViewModelProtocol {

    private let bag = DisposeBag()
    
    lazy var users: Driver<[UserListCellViewModelProtocol]> = {
        
        return self.fetchAction.elements
            .withLatestFrom(self.fetchAction.inputs) { $0 }
            .scan([User]()) { (currentElements, fetchInfo) -> [User] in
                
                let results = fetchInfo.0.users
                let fetchCursor = fetchInfo.1 ?? ""
                if currentElements.isEmpty {
                    return results
                }
                
                if fetchInfo.0.nextCursor != "-1" &&
                    fetchInfo.0.nextCursor != fetchCursor {
                    return currentElements + results
                }
                
                return currentElements
            }
            .map { try $0.map(UserListCellViewModelTranslator()) }
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
    
    lazy var loadingIndicatorAnimation: Driver<Bool> = {
        return self.fetchAction.executing.shareReplayLatestWhileConnected().asDriver(onErrorJustReturn: false)
    }()
    
    private let fetchAction: Action<String?, UserCursor>
    
    init<Request: TwitterRequestProtocol>(viewWillAppear: Driver<Void>, RequestType: Request.Type) where Request.Response == UserCursor {
        
        let account = AuthenticateTwitter.sharedInstance.currentAccount
            .asObservable().shareReplayLatestWhileConnected()
        
        fetchAction = Action { nextCursor in
            let parameters = nextCursor != nil ? ["cursor": nextCursor!] : [:]
            return account
                .map { RequestType.init(account: $0, parameters: parameters) }
                .flatMap { TwitterApiClient.execute(request: $0) }
                .shareReplayLatestWhileConnected()
        }
        
        viewWillAppear.asObservable()
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.fetchAction.execute(nil)
            }).addDisposableTo(bag)
                
    }
    
    func bindRefresh(refresh: Driver<Void>) {
        
        refresh.asObservable()
            .withLatestFrom(loadingIndicatorAnimation.asObservable())
            .filter { !$0 }
            .map { _ in return nil }
            .bind(to: fetchAction.inputs)
            .addDisposableTo(bag)
        
    }
    
    func bindReachedBottom(reachedBottom: Driver<Void>) {
        
        reachedBottom.asObservable()
            .withLatestFrom(loadingIndicatorAnimation.asObservable())
            .filter { !$0 }
            .withLatestFrom(fetchAction.elements)
            .map { $0.nextCursor }
            .bind(to: fetchAction.inputs)
            .addDisposableTo(bag)
                
    }
    
}
