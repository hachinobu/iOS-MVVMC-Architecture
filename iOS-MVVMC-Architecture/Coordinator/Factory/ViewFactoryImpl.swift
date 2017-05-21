//
//  ViewFactoryImpl.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/12.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class ViewFactoryImpl: HomeTimeLineViewFactory {
    
    func generateHomeTimeLineView() -> TimeLineViewProtocol & Presentable {
        let homeTimeLineView = UIStoryboard.instantiateInitialViewController(withType: HomeTimeLineViewController.self)
        let viewModel = HomeTimeLineViewModel(viewWillAppear: homeTimeLineView.rx.viewWillAppear.asDriver())
        homeTimeLineView.viewModel = viewModel
        return homeTimeLineView
    }
    
}
