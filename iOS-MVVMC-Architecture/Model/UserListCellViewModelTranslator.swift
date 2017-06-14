//
//  UserListCellViewModelTranslator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/14.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct UserListCellViewModelTranslator: Translator {
    
    func translate(_ input: User) throws -> UserListCellViewModelProtocol {
        
        let userId = input.id
        let userName = input.name
        let screenName = input.screenName
        let description = input.description
        let profileImageURL = URL(string: input.profileImageHttpsUrl)
        
        return UserListCellViewModel(userId: userId, userName: userName,
                                     screenName: screenName, description: description,
                                     profileURL: profileImageURL)
        
    }
    
}
