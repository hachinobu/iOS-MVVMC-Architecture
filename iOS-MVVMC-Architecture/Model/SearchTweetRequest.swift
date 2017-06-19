//
//  SearchTweetRequest.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import Accounts
import Social

struct SearchTweetRequest: TwitterRequestProtocol {
    
    typealias Response = SearchResult
    
    var method: SLRequestMethod {
        return .GET
    }
    
    var path: String {
        return "search/tweets.json"
    }
    
    var parameters: [String: Any]!
    var account: ACAccount
    
    init(account: ACAccount, parameters: [String: Any]!) {
        self.account = account
        self.parameters = parameters
    }
    
}
