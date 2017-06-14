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

final class HomeTimeLineViewModel: TimeLineViewModel {
    
    private let bag = DisposeBag()
    
    lazy var tweets: Driver<[TimeLineCellViewModel]> = {
        
        return self.fetchAction.elements
            .withLatestFrom(self.fetchAction.inputs) { $0 }
            .scan([Tweet]()) { currentElements, nextFetchInfo -> [Tweet] in
                
                let results = nextFetchInfo.0
                let id: Int64? = nextFetchInfo.1
                
                if currentElements.isEmpty || id == nil {
                    return results
                }
                
                if let id = id, let firstId = results.first?.id, id > firstId {
                    return currentElements + results
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
    
    lazy var loadingIndicatorAnimation: Driver<Bool> = {
        return self.fetchAction.executing.shareReplayLatestWhileConnected().asDriver(onErrorJustReturn: false)
    }()
        
    private let fetchAction: Action<Int64?, [Tweet]>
    
    init<Request: TwitterRequestProtocol>(viewWillAppear: Driver<Void>, RequestType: Request.Type) where Request.Response == [Tweet] {
        
        let account = AuthenticateTwitter.sharedInstance.currentAccount
            .asObservable().shareReplayLatestWhileConnected()
        fetchAction = Action { sinceId in
            let parameters = sinceId != nil ? ["max_id": sinceId!.description] : [:]
            return account
                .map { RequestType.init(account: $0, parameters: parameters) }
                .flatMap { TwitterApiClient.execute(request: $0) }
                .shareReplayLatestWhileConnected()
        }
        
        viewWillAppear.asObservable()
            .take(1)
            .map { nil }
            .subscribe(onNext: { [weak self] id in
                self?.fetchAction.execute(id)
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
