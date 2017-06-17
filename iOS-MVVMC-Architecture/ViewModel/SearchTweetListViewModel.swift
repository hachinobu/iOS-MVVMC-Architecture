//
//  SearchTweetListViewModel.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Action

class SearchTweetListViewModel: TimeLineViewModel {

    private let bag = DisposeBag()
    
    lazy var tweets: Driver<[TimeLineCellViewModel]> = {
        
        return self.fetchAction.elements.withLatestFrom(self.fetchAction.inputs) { $0 }
            .scan([Tweet]()) { (currentElements, fetchInfo) -> [Tweet] in
                
                let results = fetchInfo.0.tweets
                if currentElements.isEmpty || fetchInfo.1 == nil {
                    return results
                }
                return currentElements + results
                
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
    
    private let fetchAction: Action<String?, SearchResult>
    
    init<Request: TwitterRequestProtocol>(viewWillAppear: Driver<Void>, RequestType: Request.Type, searchQuery: String) where Request.Response == SearchResult {
        
        let account = AuthenticateTwitter.sharedInstance.currentAccount
            .asObservable().shareReplayLatestWhileConnected()
        
        fetchAction = Action { nextCursor in
            var parameters = ["q": searchQuery]
            if let nextCursor = nextCursor {
                parameters["max_id"] = nextCursor
            }
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
            .map { result -> Int64 in
                let id = result.tweets.last!.id - 1
                return id
            }
            .map { $0.description }
            .bind(to: fetchAction.inputs)
            .addDisposableTo(bag)
        
    }
    
}
