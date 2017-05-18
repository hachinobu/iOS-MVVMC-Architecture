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
    
    init(userName: String?, screenName: String?, body: String?, profileURL: URL?) {
        userNameObserver.value = userName
        screenNameObserver.value = screenName
        bodyObserver.value = body
        profileURLObserver.value = profileURL
    }
    
}
