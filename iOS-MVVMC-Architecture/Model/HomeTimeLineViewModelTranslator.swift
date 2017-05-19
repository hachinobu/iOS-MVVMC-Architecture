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
        
        let id = input.idStr
        let userId = input.user.idStr
        let userName = input.user.name
        let screenName = input.user.screenName
        let body = input.text
        let profileURL = URL(string: input.user.profileImageHttpsUrl)
        
        let viewModel = HomeTimeLineCellViewModel(id: id,
                                                  userId: userId,
                                                  userName: userName,
                                                  screenName: screenName,
                                                  body: body,
                                                  profileURL: profileURL)
        return viewModel
        
    }
    
}

