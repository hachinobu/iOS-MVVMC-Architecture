//
//  HomeTimeLineCellViewModel.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/16.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class HomeTimeLineCellViewModel: TimeLineCellViewModel {
    
    private let idObserver = Variable<String?>(nil)
    lazy var id: Observable<String?> = {
        return self.idObserver.asObservable()
    }()
    
    private let userIdObserver = Variable<String?>(nil)
    lazy var userId: Observable<String?> = {
        return self.userIdObserver.asObservable()
    }()
    
    private let userNameObserver = Variable<String?>(nil)
    lazy var userName: Observable<String?> = {
        return self.userNameObserver.asObservable()
    }()
    
    private let screenNameObserver = Variable<String?>(nil)
    lazy var screenName: Observable<String?> = {
        return self.screenNameObserver.asObservable()
    }()
    
    private let bodyObserver = Variable<String?>(nil)
    lazy var body: Observable<String?> = {
        return self.bodyObserver.asObservable()
    }()
    
    private let profileURLObserver: Variable<URL?> = Variable(nil)
    lazy var profileURL: Observable<URL?> = {
        return self.profileURLObserver.asObservable()
    }()
    
    init(id: String?, userId: String?, userName: String?, screenName: String?, body: String?, profileURL: URL?) {
        idObserver.value = id
        userIdObserver.value = userId
        userNameObserver.value = userName
        screenNameObserver.value = screenName
        bodyObserver.value = body
        profileURLObserver.value = profileURL
    }
    
}
