//
//  TweetDetailViewProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/22.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

protocol TweetDetailViewProtocol {
    var selectedUser: Observable<String> { get }
}
