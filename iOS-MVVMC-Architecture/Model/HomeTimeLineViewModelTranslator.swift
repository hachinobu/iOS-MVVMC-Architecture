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
        
        let id = input.id
        let userId = input.user.id
        let userName = input.user.name
        let screenName = "@" + input.user.screenName
        let body = input.text
        let profileURL = URL(string: input.user.profileImageHttpsUrl)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let likeCount = numberFormatter.string(for: input.favoriteCount) ?? ""
        let retweetCount = numberFormatter.string(for: input.retweetCount) ?? ""
        
        let viewModel = HomeTimeLineCellViewModel(id: id,
                                                  userId: userId,
                                                  userName: userName,
                                                  screenName: screenName,
                                                  body: body,
                                                  profileURL: profileURL,
                                                  retweetCount: retweetCount,
                                                  likeCount: likeCount)
        return viewModel
        
    }
    
}

