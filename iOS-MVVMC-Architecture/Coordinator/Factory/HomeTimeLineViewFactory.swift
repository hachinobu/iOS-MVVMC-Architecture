//
//  HomeTimeLineViewFactory.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol HomeTimeLineViewFactory {
    func generateHomeTimeLineView() -> HomeTimeLineViewProtocol & Presentable
    func generateTweetDetailView(tweetId: String) -> TweetDetailViewProtocol & Presentable
    func generateUserTimeLineView(userId: String) -> UserTimeLineViewProtocol & Presentable
}
