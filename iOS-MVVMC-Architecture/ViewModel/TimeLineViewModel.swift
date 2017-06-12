//
//  TimeLineViewModel.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/15.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Accounts

protocol TimeLineViewModel: class, AuthViewModelProtocol {
    
    var tweets: Driver<[TimeLineCellViewModel]> { get }
    var error: Driver<Error> { get }
    var loadingIndicatorAnimation: Driver<Bool> { get }
    
    func bindRefresh(refresh: Driver<Void>)
    func bindReachedBottom(reachedBottom: Driver<Void>)
    
}
