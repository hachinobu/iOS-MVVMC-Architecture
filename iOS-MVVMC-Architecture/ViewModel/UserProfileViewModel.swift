//
//  UserProfileViewModel.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/06/06.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

final class UserProfileViewModel: UserProfileViewModelProtocol {
    
    private let userIdObserver = Variable<String?>(nil)
    lazy var userId: Observable<String?> = self.userIdObserver.asObservable()
    
    private let userNameObserver = Variable<String?>(nil)
    lazy var userName: Observable<String?> = self.userNameObserver.asObservable()
    
    private let screenNameObserver = Variable<String?>(nil)
    lazy var screenName: Observable<String?> = self.screenNameObserver.asObservable()
    
    private let descriptionObserver = Variable<String?>(nil)
    lazy var description: Observable<String?> = self.descriptionObserver.asObservable()
    
    private let locationObserver = Variable<String?>(nil)
    lazy var location: Observable<String?> = self.locationObserver.asObservable()
    
    private let followingCountObserver = Variable<String?>(nil)
    lazy var followingCount: Observable<String?> = self.followingCountObserver.asObservable()
    
    private let followerCountObserver = Variable<String?>(nil)
    lazy var followerCount: Observable<String?> = self.followerCountObserver.asObservable()
    
    private let backgroundImageURLObserver = Variable<URL?>(nil)
    lazy var backgroundImageURL: Observable<URL?> = self.backgroundImageURLObserver.asObservable()
    
    private let profileURLObserver = Variable<URL?>(nil)
    lazy var profileURL: Observable<URL?> = self.profileURLObserver.asObservable()
    
    init(userId: String?, userName: String?, screenName: String?,
         description: String?, location: String?,
         followingCount: String?, followerCount: String?,
         backgroundImageURL: URL?, profileURL: URL?) {
        userIdObserver.value = userId
        userNameObserver.value = userName
        screenNameObserver.value = screenName
        descriptionObserver.value = description
        locationObserver.value = location
        followingCountObserver.value = followingCount
        followerCountObserver.value = followerCount
        backgroundImageURLObserver.value = backgroundImageURL
        profileURLObserver.value = profileURL
    }
    
    
}
