//
//  TrendTweetTimeLineViewProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

protocol TrendTweetTimeLineViewProtocol: TimeLineViewProtocol {
    var viewModel: TimeLineViewModel! { get }
    var selectedUser: Observable<String> { get }
}
