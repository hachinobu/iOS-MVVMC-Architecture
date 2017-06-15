//
//  UserListViewProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/15.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

protocol UserListViewProtocol {
    var viewModel: UserListViewModelProtocol! { get }
    var selectedUser: Observable<String> { get }
}
