//
//  TweetDetailViewModelProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/05/21.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Accounts

protocol TweetDetailViewModelProtocol: class, AuthViewModelProtocol {
    
    var tweets: Driver<[TweetDetailCellViewModel]> { get }
    var error: Driver<Error> { get }
    
}

