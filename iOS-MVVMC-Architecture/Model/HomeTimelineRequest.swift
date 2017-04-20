//
//  HomeTimelineRequest.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import Accounts
import Social

struct HomeTimelineRequest: TwitterRequestProtocol {
    
    typealias Response = [Tweet]
    
    var method: SLRequestMethod {
        return .GET
    }
    
    var path: String {
        return "statuses/home_timeline.json"
    }
    
    var parameters: [String: Any]!
    var account: ACAccount
    
    init(account: ACAccount, parameters: [String: Any]!) {
        self.account = account
        self.parameters = parameters
    }
    
}
