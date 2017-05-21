//
//  TweetDetailRequest.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/05/21.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import Accounts
import Social

struct TweetDetailRequest: TwitterRequestProtocol {
    
    typealias Response = Tweet
    
    var method: SLRequestMethod {
        return .GET
    }
    
    var path: String {
        return "statuses/show.json"
    }
    
    var parameters: [String: Any]!
    var account: ACAccount
    
    init(account: ACAccount, parameters: [String: Any]!) {
        self.account = account
        self.parameters = parameters
    }
    
}
