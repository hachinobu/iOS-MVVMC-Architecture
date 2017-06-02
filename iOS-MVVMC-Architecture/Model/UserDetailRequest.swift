//
//  UserDetailRequest.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/06/02.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import Accounts
import Social

struct UserDetailRequest: TwitterRequestProtocol {
    
    typealias Response = User
    
    var method: SLRequestMethod {
        return .GET
    }
    
    var path: String {
        return "users/show.json"
    }
    
    var parameters: [String: Any]!
    var account: ACAccount
    
    init(account: ACAccount, parameters: [String: Any]!) {
        self.account = account
        self.parameters = parameters
    }
    
}
