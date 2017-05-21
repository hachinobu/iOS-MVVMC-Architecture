//
//  TweetDetailCellViewModelTranslator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/05/21.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

struct TweetDetailCellViewModelTranslator: Translator {
    
    func translate(_ input: Tweet) throws -> TweetDetailCellViewModel {
        
        let id = input.idStr
        let userId = input.user.idStr
        let userName = input.user.name
        let screenName = "@" + input.user.screenName
        let body = input.text
        let profileURL = URL(string: input.user.profileImageHttpsUrl)
        let reTweetCount = input.retweetCount
        let likeCount = input.favoriteCount ?? 0
        let statusCount = "\(reTweetCount) リツイート   \(likeCount) いいね"
        
        let viewModel = TweetDetailCellViewModel(id: id, userId: userId,
                                                 userName: userName, screenName: screenName,
                                                 body: body, profileURL: profileURL,
                                                 statusCount: statusCount)
        return viewModel
        
    }

}
