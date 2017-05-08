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
    
    private let innerAccountList: Variable<[ACAccount]> = Variable([])
    lazy var accountList: Driver<[ACAccount]> = {
        return self.innerAccountList.asDriver()
    }()
    
    lazy var account: Observable<AuthStatus> = {
        return self.fetchAccount()
    }()
    
    private let innerCurrentStatus = Variable<AuthStatus>(.none)
    lazy var currentStatus: Driver<AuthStatus> = {
        return self.innerCurrentStatus.asDriver()
    }()
    lazy var currentAccount: Driver<ACAccount> = {
        return self.innerCurrentStatus.asDriver()
            .filter { $0.isAuthenticated() }
            .map { $0.fetchAccount()! }
    }()
    
    private let innerAuthError = Variable<Error?>(nil)
    lazy var authError: Driver<Error?> = {
        return self.innerAuthError.asDriver()
    }()
    
    let trigger = PublishSubject<Void>()
    
    init() {
        trigger.bind { _ in
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
            
            guard isSuccess else {
                self.innerCurrentStatus.value = .denied
                return
            }
            
            guard let accountList = accountStore.accounts(with: type) as? [ACAccount], accountList.count > 0 else {
                self.innerCurrentStatus.value = .noAccounts
                return
            }
            
            self.innerAccountList.value = accountList
            let status = AuthStatus.authenticated(accountList.first!)
            if accountList.count == 1 {
                self.innerCurrentStatus.value = status
            }
            
        }
        
    }
    
    private func fetchAccount() -> Observable<AuthStatus> {
        
        return Observable.create { observer -> Disposable in
            
            let accountStore = ACAccountStore()
            let type = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)!
            
            accountStore.requestAccessToAccounts(with: type, options: nil) { isSuccess, error in
                
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let accountList = accountStore.accounts(with: type) as? [ACAccount], accountList.count > 0 else {
                    self.innerCurrentStatus.value = .noAccounts
                    observer.onCompleted()
                    return
                }
                
                self.innerAccountList.value = accountList
                let status = AuthStatus.authenticated(accountList.first!)
                if accountList.count == 1 {
                    self.innerCurrentStatus.value = status
                }
                observer.onNext(status)
                observer.onCompleted()
                
            }
            
            return Disposables.create()
            
        }
        
    }
    
}
