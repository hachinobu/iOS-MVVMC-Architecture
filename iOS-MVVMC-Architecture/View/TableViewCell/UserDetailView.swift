//
//  UserDetailView.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/06/05.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

protocol UserDetailViewModelProtocol: class {
    var userName: Observable<String?> { get }
    var screenName: Observable<String?> { get }
    var description: Observable<String?> { get }
    var location: Observable<String?> { get }
    var followingCount: Observable<String?> { get }
    var followerCount: Observable<String?> { get }
    var backgroundImageURL: Observable<URL?> { get }
    var profileURL: Observable<URL?> { get }
}

final class UserDetailView: UIView {

}
