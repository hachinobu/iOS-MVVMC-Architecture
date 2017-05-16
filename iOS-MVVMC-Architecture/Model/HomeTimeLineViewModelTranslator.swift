//
//  HomeTimeLineViewModelTranslator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/16.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

struct HomeTimeLineViewModelTranslator: Translator {
    
    func translate(_ input: Tweet) throws -> TimeLineCellViewModel {
        
        let viewModel = HomeTimeLineCellViewModel()
        let userName = input.user.name 
        viewModel.userName.onNext(userName)
        
        let screenName = input.user.screenName
        viewModel.screenName.onNext(screenName)
        
        let body = input.text
        viewModel.screenName.onNext(body)
        
        let profileURL = URL(fileURLWithPath: input.user.profileImageHttpsUrl)
        viewModel.profileURL.onNext(profileURL)
        
        return viewModel
        
    }
    
}

