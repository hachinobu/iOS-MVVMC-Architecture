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
    lazy var userName: Observable<String?> = self.userNameObserver.asObservable()
    
    private let screenNameObserver = Variable<String?>(nil)
    lazy var screenName: Observable<String?> = self.screenNameObserver.asObservable()
    
    private let bodyObserver = Variable<String?>(nil)
    lazy var body: Observable<String?> = self.bodyObserver.asObservable()
    
    private let profileURLObserver: Variable<URL?> = Variable(nil)
    lazy var profileURL: Observable<URL?> = self.profileURLObserver.asObservable()
    
    private let retweetCountObserver: Variable<String?> = Variable(nil)
    lazy var retweetCount: Observable<String?> = self.retweetCountObserver.asObservable()
    
    private let likeCountObserver: Variable<String?> = Variable(nil)
    lazy var likeCount: Observable<String?> = self.likeCountObserver.asObservable()
    
    init(id: Int64, userId: Int, userName: String?,
         screenName: String?, body: String?, profileURL: URL?,
         retweetCount: String?, likeCount: String?) {
        self.id = id
        self.userId = userId
        userNameObserver.value = userName
        screenNameObserver.value = screenName
        bodyObserver.value = body
        profileURLObserver.value = profileURL
        retweetCountObserver.value = retweetCount
        likeCountObserver.value = likeCount
    }
    
}
