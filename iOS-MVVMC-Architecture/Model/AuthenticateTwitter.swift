//
//  AuthenticateTwitter.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import Accounts
import RxSwift
import RxCocoa
import Action

class AuthenticateTwitter {
    
    enum AuthStatus {
        case none
        case denied
        case noAccounts
        case authenticated(ACAccount)
        
        func noAccount() -> Bool {
            switch self {
            case .noAccounts:
                return true
            default:
                return false
            }
        }
        
        func isAuthenticated() -> Bool {
            switch self {
            case .authenticated(_):
                return true
            default:
                return false
            }
        }
        
        func fetchAccount() -> ACAccount? {
            switch self {
            case .authenticated(let account):
                return account
            default:
                return nil
            }
        }
        
        func fetchAuthMessage() -> String {
            switch self {
            case .denied:
                return "Twitterアカウント取得の権限がありません。\n[設定]-[プライバシー]からTwitterを許可してください"
            case .noAccounts:
                return "Twitterアカウントが登録されていません。\n[設定]-[Twitter]からアカウントを登録してください"
            default:
                return ""
            }
        }
        
    }
    
    static let sharedInstance: AuthenticateTwitter = AuthenticateTwitter()
    
    private let bag = DisposeBag()
    
    private let innerCurrentStatus = Variable<AuthStatus>(.none)
    lazy var currentStatus: Observable<AuthStatus> = {
        return self.innerCurrentStatus.asObservable()
    }()
    
    lazy var currentAccount: Driver<ACAccount> = {
        return self.currentStatus
            .filter { $0.isAuthenticated() }
            .map { $0.fetchAccount()! }
            .asDriver(onErrorDriveWith: Driver.empty())
    }()
    
    private let innerAuthError = Variable<Error?>(nil)
    lazy var authError: Driver<Error?> = {
        return self.innerAuthError.asDriver()
    }()
    
    lazy var authTrigger: PublishSubject<Void> = {
        return self.authAction.inputs
    }()
    
    let authAction: Action<Void, AuthStatus>
    
    init() {
        
        authAction = Action { _ in
            
            return Observable.create { observer -> Disposable in
                
                let accountStore = ACAccountStore()
                let type = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)!
                
                accountStore.requestAccessToAccounts(with: type, options: nil) { isSuccess, error in
                    
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    
                    guard isSuccess else {
                        observer.onNext(.denied)
                        observer.onCompleted()
                        return
                    }
                    
                    guard let accountList = accountStore.accounts(with: type) as? [ACAccount],
                        accountList.count > 0 else {
                            observer.onNext(.noAccounts)
                            observer.onCompleted()
                            return
                    }
                    
                    let status = AuthStatus.authenticated(accountList.first!)
                    observer.onNext(status)
                    observer.onCompleted()
                    
                }
                
                return Disposables.create()
                
            }
            
        }
        
        authAction.elements.bind(to: innerCurrentStatus).addDisposableTo(bag)
        authAction.errors.map { e -> Error? in
            return e
        }.bind(to: innerAuthError).addDisposableTo(bag)
        
    }
    
}
