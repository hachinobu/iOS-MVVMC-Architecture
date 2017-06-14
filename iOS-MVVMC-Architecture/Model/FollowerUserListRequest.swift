//
//  FollowingUserListRequest.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/14.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import Accounts
import Social

struct FollowerUserListRequest: TwitterRequestProtocol {
    
    typealias Response = UserCursor
    
    var method: SLRequestMethod {
        return .GET
    }
    
    var path: String {
        return "followers/list.json"
    }
    
    var parameters: [String: Any]!
    var account: ACAccount
    
    init(account: ACAccount, parameters: [String: Any]!) {
        self.account = account
        self.parameters = parameters
    }
    
}
