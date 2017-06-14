//
//  UserListCellViewModel.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/14.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class UserListCellViewModel: UserListCellViewModelProtocol {

    var userId: Int
    
    var userNameObserver = Variable<String?>(nil)
    lazy var userName: Observable<String?> = self.userNameObserver.asObservable()
    
    var screenNameObserver = Variable<String?>(nil)
    lazy var screenName: Observable<String?> = self.screenNameObserver.asObservable()
    
    var descriptionObserver = Variable<String?>(nil)
    lazy var description: Observable<String?> = self.descriptionObserver.asObservable()
    
    var profileURLObserver = Variable<URL?>(nil)
    lazy var profileURL: Observable<URL?> = self.profileURLObserver.asObservable()
    
    init(userId: Int, userName: String?, screenName: String?,
         description: String?, profileURL: URL?) {
        self.userId = userId
        self.screenNameObserver.value = screenName
        self.descriptionObserver.value = description
        self.profileURLObserver.value = profileURL
    }
    
}
