//
//  TrendReTweetTimeLineViewFactory.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/18.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol TrendReTweetTimeLineViewFactory {
    func generateTrendReTweetTimeLineView() -> HomeTimeLineViewProtocol & Presentable
}
