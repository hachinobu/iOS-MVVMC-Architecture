//
//  SearchResult.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct SearchResult {
    
    let tweets: [Tweet]
    let sinceId: String?
    let maxId: String?
    
}

extension SearchResult: ImmutableMappable {
    
    init(map: Map) throws {
        tweets = try map.value("statuses")
        sinceId = try? map.value("search_metadata.since_id_str")
        maxId = try? map.value("search_metadata.max_id_str")
    }
    
}
