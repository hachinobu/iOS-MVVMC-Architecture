//
//  User.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct User {
    
    let createdAt: String
    let isDefaultProfile: Bool
    let defaultProfileImage: Bool
    let description: String?
    let favouritesCount: Int
    let following: Bool?
    let followersCount: Int
    let friendsCount: Int
    let id: Int
    let idStr: String
    let lang: String
    let listedCount: Int
    let location: String?
    let name: String
    let profileBackgroundColor: String
    let profileBackgroundImageHttpsUrl: String?
    let profileBannerUrl: String?
    let profileImageHttpsUrl: String
    let profileTextColor: String
    let protected: Bool
    let screenName: String
    let statusesCount: Int
    let url: String?
    let utcOffset: Int?
    
}

extension User: ImmutableMappable {
    
    public init(map: Map) throws {
        createdAt = try map.value("created_at")
        isDefaultProfile = try map.value("default_profile")
        defaultProfileImage = try map.value("default_profile_image")
        description = try? map.value("description")
        favouritesCount = try map.value("favourites_count")
        following = try? map.value("following")
        followersCount = try map.value("followers_count")
        friendsCount = try map.value("friends_count")
        id = try map.value("id")
        idStr = try map.value("id_str")
        lang = try map.value("lang")
        listedCount = try map.value("listed_count")
        location = try? map.value("location")
        name = try map.value("name")
        profileBackgroundColor = try map.value("profile_background_color")
        profileBackgroundImageHttpsUrl = try? map.value("profile_background_image_url_https")
        profileBannerUrl = try? map.value("profile_banner_url")
        profileImageHttpsUrl = try map.value("profile_image_url_https")
        profileTextColor = try map.value("profile_text_color")
        protected = try map.value("protected")
        screenName = try map.value("screen_name")
        statusesCount = try map.value("statuses_count")
        url = try? map.value("url")
        utcOffset = try? map.value("utc_offset")
    }
    
}
