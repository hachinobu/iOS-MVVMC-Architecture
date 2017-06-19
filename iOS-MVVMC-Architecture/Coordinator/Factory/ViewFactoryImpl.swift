//
//  ViewFactoryImpl.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class ViewFactoryImpl: HomeTimeLineViewFactory, TrendLikeTweetTimeLineViewFactory, TrendReTweetTimeLineViewFactory {
    
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
    
    func generateFollowerListView(userId: String) -> Presentable & UserListViewProtocol {
        let followerListView = UIStoryboard.instantiateInitialViewController(withType: UserListViewController.self)
        let viewModel = UserListViewModel(viewWillAppear: followerListView.rx.viewWillAppear.asDriver(), userId: userId, RequestType: FollowerUserListRequest.self)
        followerListView.viewModel = viewModel
        return followerListView
    }
    
    func generateFollowingListView(userId: String) -> Presentable & UserListViewProtocol {
        let followingListView = UIStoryboard.instantiateInitialViewController(withType: UserListViewController.self)
        let viewModel = UserListViewModel(viewWillAppear: followingListView.rx.viewWillAppear.asDriver(), userId: userId, RequestType: FollowingUserListRequest.self)
        followingListView.viewModel = viewModel
        return followingListView
    }
    
    func generateTrendLikeTweetTimeLineView() -> HomeTimeLineViewProtocol & Presentable {
        let trendLikeListView = UIStoryboard.instantiateInitialViewController(withType: HomeTimeLineViewController.self)
        let viewModel = SearchTweetListViewModel(viewWillAppear: trendLikeListView.rx.viewWillAppear.asDriver(), RequestType: SearchTweetRequest.self, searchQuery: "lang:ja min_faves:2000")
        trendLikeListView.viewModel = viewModel
        return trendLikeListView
    }
    
    func generateTrendReTweetTimeLineView() -> HomeTimeLineViewProtocol & Presentable {
        let trendReTweetTimeLineView = UIStoryboard.instantiateInitialViewController(withType: HomeTimeLineViewController.self)
        let viewModel = SearchTweetListViewModel(viewWillAppear: trendReTweetTimeLineView.rx.viewWillAppear.asDriver(), RequestType: SearchTweetRequest.self, searchQuery: "lang:ja min_retweets:2000")
        trendReTweetTimeLineView.viewModel = viewModel
        return trendReTweetTimeLineView
    }
    
}
