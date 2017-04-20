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
    
    enum AuthenticatedError: Error {
        case accountType
    }
    
    enum AuthStatus {
        case none
        case noUsers
        case authenticated(ACAccount)
        
        func noUser() -> Bool {
            switch self {
            case .noUsers:
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
        
    }
    
    static let sharedInstance: AuthenticateTwitter = AuthenticateTwitter()
    
    private let bag = DisposeBag()
    
    private let innerAccountList: Variable<[ACAccount]> = Variable([])
    var accountList: Driver<[ACAccount]> {
        return innerAccountList.asDriver()
    }
    
    var account: Observable<Void> {
        return self.fetchAccount()
    }
    
    private let innerCurrentStatus = Variable<AuthStatus>(.none)
    var currentStatus: Driver<AuthStatus> {
        return innerCurrentStatus.asDriver()
    }
    var currentAccount: Driver<ACAccount> {
        return innerCurrentStatus.asDriver()
            .filter { $0.isAuthenticated() }
            .map { $0.fetchAccount()! }
    }
    
    private let innerAuthError = Variable<Error?>(nil)
    var authError: Driver<Error?> {
        return innerAuthError.asDriver()
    }
    
    let trigger = PublishSubject<Void>()
    
    init() {
        trigger.bind { () in
            self.authenticatedTwitter()
        }.addDisposableTo(bag)
    }
    
    private func authenticatedTwitter() {
        
        let accountStore = ACAccountStore()
        let type = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)!
        
        accountStore.requestAccessToAccounts(with: type, options: nil) { isSuccess, error in
            
            if let error = error {
                self.innerAuthError.value = error
                return
            }
            
            guard let accountList = accountStore.accounts(with: type) as? [ACAccount], accountList.count > 0 else {
                self.innerCurrentStatus.value = .noUsers
                return
            }
            
            self.innerAccountList.value = accountList
            let status = AuthStatus.authenticated(accountList.first!)
            if accountList.count == 1 {
                self.innerCurrentStatus.value = status
            }
            
        }
        
    }
    
    private func fetchAccount() -> Observable<Void> {
        
        return Observable.create { observer -> Disposable in
            
            let accountStore = ACAccountStore()
            let type = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)!
            
            accountStore.requestAccessToAccounts(with: type, options: nil) { isSuccess, error in
                
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let accountList = accountStore.accounts(with: type) as? [ACAccount], accountList.count > 0 else {
                    self.innerCurrentStatus.value = .noUsers
                    observer.onCompleted()
                    return
                }
                
                self.innerAccountList.value = accountList
                let status = AuthStatus.authenticated(accountList.first!)
                if accountList.count == 1 {
                    self.innerCurrentStatus.value = status
                }
                observer.onNext()
                observer.onCompleted()
                
            }
            
            return Disposables.create()
            
        }
        
    }
    
}
