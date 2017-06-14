//
//  UserListViewModelProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/14.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserListViewModelProtocol {
    
    var users: Driver<[UserListCellViewModelProtocol]> { get }
    var error: Driver<Error> { get }
    var loadingIndicatorAnimation: Driver<Bool> { get }
    
    func bindRefresh(refresh: Driver<Void>)
    func bindReachedBottom(reachedBottom: Driver<Void>)
    
}
