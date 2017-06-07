//
//  HomeTimeLineViewProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/07.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol HomeTimeLineViewProtocol: TimeLineViewProtocol {
    var viewModel: TimeLineViewModel! { get }
}
