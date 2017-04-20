//
//  Tweet.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct Tweet {
    
    let createdAt: String
    let favoriteCount: Int?
    let favorited: Bool?
    let filterLevel: String?
    let id: Int64
    let idStr: String
    let lang: String?
    let retweetCount: Int
    let retweeted: Bool
    let htmlSource: String
    let text: String
    let user: User
    
}

extension Tweet: ImmutableMappable {
    
    init(map: Map) throws {
        createdAt = try map.value("created_at")
        favoriteCount = try? map.value("favorite_count")
        favorited = try? map.value("favorited")
        filterLevel = try? map.value("filter_level")
        id = try map.value("id")
        idStr = try map.value("id_str")
        lang = try? map.value("lang")
        retweetCount = try map.value("retweet_count")
        retweeted = try map.value("retweeted")
        htmlSource = try map.value("source")
        text = try map.value("text")
        user = try map.value("user")
    }
    
}

