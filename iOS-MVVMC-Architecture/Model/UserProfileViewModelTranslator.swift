//
//  UserProfileViewModelTranslator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/06/06.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct UserProfileViewModelTranslator: Translator {
    
    func translate(_ input: User) throws -> UserProfileViewModel {
        let userName = input.name
        let screenName = input.screenName
        let description = input.description
        let location = input.location
        let followingCount = "フォロー数: " + input.friendsCount.description
        let followerCount = "フォロワー数: " + input.followersCount.description
        let backgroundImageURL = URL(string: input.profileBackgroundImageHttpsUrl)
        let profileImageURL = URL(string: input.profileImageHttpsUrl)
        
        return UserProfileViewModel(userName: userName, screenName: screenName,
                                    description: description, location: location,
                                    followingCount: followingCount, followerCount: followerCount,
                                    backgroundImageURL: backgroundImageURL, profileURL: profileImageURL)
        
    }
    
}
