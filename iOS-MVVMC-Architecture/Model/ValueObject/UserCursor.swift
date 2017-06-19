//
//  UserCursor.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/14.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserCursor {
    let users: [User]
    let nextCursor: String
}

extension UserCursor: ImmutableMappable {
    
    init(map: Map) throws {
        users = try map.value("users")
        nextCursor = try map.value("next_cursor_str")
    }
    
}
