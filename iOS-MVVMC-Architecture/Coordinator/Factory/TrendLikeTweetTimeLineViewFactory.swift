//
//  TrendLikeTweetTimeLineViewFactory.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol TrendLikeTweetTimeLineViewFactory {
    func generateTrendLikeTweetTimeLineView() -> HomeTimeLineViewProtocol & Presentable
}
