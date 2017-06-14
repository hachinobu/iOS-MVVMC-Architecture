//
//  ViewFactoryImpl.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class ViewFactoryImpl: HomeTimeLineViewFactory {
    
    func generateHomeTimeLineView() -> HomeTimeLineViewProtocol & Presentable {
        let homeTimeLineView = UIStoryboard.instantiateInitialViewController(withType: HomeTimeLineViewController.self)
        let viewModel = HomeTimeLineViewModel(viewWillAppear: homeTimeLineView.rx.viewWillAppear.asDriver(), RequestType: HomeTimelineRequest.self)
        homeTimeLineView.viewModel = viewModel
        return homeTimeLineView
    }
    
    func generateTweetDetailView(tweetId: String) -> TweetDetailViewProtocol & Presentable {
        let tweetDetailView = UIStoryboard.instantiateInitialViewController(withType: TweetDetailViewController.self)
        let viewModel = TweetDetailViewModel(tweetId: tweetId, viewWillAppear: tweetDetailView.rx.viewWillAppear.asDriver())
        tweetDetailView.viewModel = viewModel
        return tweetDetailView
    }
    
    func generateUserTimeLineView(userId: String) -> Presentable & UserTimeLineViewProtocol {
        let userTimeLineView = UIStoryboard.instantiateInitialViewController(withType: UserTimeLineViewController.self)
        let viewModel = UserTimeLineViewModel(userId: userId, viewWillAppear: userTimeLineView.rx.viewWillAppear.asDriver())
        userTimeLineView.viewModel = viewModel
        return userTimeLineView
    }
    
}
