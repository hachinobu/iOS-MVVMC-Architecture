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
    
    lazy var authStatus: Driver<AuthenticateTwitter.AuthStatus> = {
        return self.authTwitter.currentStatus
    }()
    
    lazy var authError: Driver<Error?> = {
        return self.authTwitter.authError
    }()
    
    lazy var tweets: Driver<[TimeLineCellViewModel]> = {
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
    
    private let fetchAction: Action<String?, [TimeLineCellViewModel]>
    private let authTwitter = AuthenticateTwitter.sharedInstance
    
//    init<Request: TwitterRequestProtocol, TranslatorType: Translator>(request: Request, translator: TranslatorType) where Request.Response == [Element], TranslatorType.Input == Element, TranslatorType.Output == TimeLineCellViewModel {
//        
//        let account = authTwitter.currentAccount.asObservable()
//        fetchAction = Action { page in
//            
//            var request = request
//            request.parameters["page"] = page
//            return TwitterApiClient.execute(request: request)
//                .map { try $0.map(translator) }
//                .shareReplayLatestWhileConnected()
//            
//            account
//                .map { HomeTimelineRequest(account: $0, parameters: [:]) }
//                .flatMap { TwitterApiClient.execute(request: $0) }
//                .map { try $0.map(HomeTimeLineViewModelTranslator()) }
//                .shareReplayLatestWhileConnected()
//        }
//        
////        viewWillAppear.asObservable()
////            .take(1)
////            .map { 1 }
////            .bind(to: fetchAction.inputs)
////            .addDisposableTo(bag)
//
//    }
    
    init(viewWillAppear: Driver<Void>) {
        
        let account = authTwitter.currentAccount.asObservable()
        fetchAction = Action { sinceId in
            let parameters = sinceId != nil ? ["since_id": sinceId!] : [:]
            return account
                .map { HomeTimelineRequest(account: $0, parameters: parameters) }
                .flatMap { TwitterApiClient.execute(request: $0) }
                .map { try $0.map(HomeTimeLineViewModelTranslator()) }
                .shareReplayLatestWhileConnected()
                .scan([]) {
                    print("scan")
                    return $0 + $1
            }
        }
        
        viewWillAppear.asObservable()
            .take(1)
            .map { "1" }
            .subscribe(onNext: { [weak self] id in
                self?.fetchAction.execute(id)
            }).addDisposableTo(bag)
        
    }
    
    func bindReachedBottom(reachedBottom: Driver<Void>) {
        reachedBottom.asObservable()
            .withLatestFrom(fetchAction.elements) { (_, elements) -> TimeLineCellViewModel? in
                return elements.last
            }.filter { $0 != nil }
            .flatMap { (viewModel) -> Observable<String?> in
                return viewModel!.id
            }.bind(to: fetchAction.inputs).addDisposableTo(bag)
    }
    
}
