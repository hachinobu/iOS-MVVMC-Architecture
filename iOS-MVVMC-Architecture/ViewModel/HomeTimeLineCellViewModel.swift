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
    
    var id: Int64
    var userId: Int
    
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
    
    init(id: Int64, userId: Int, userName: String?, screenName: String?, body: String?, profileURL: URL?) {
        self.id = id
        self.userId = userId
        userNameObserver.value = userName
        screenNameObserver.value = screenName
        bodyObserver.value = body
        profileURLObserver.value = profileURL
    }
    
}
