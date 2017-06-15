//
//  UserDetailView.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/06/05.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

protocol UserProfileViewModelProtocol: class {
    var userName: Observable<String?> { get }
    var screenName: Observable<String?> { get }
    var description: Observable<String?> { get }
    var location: Observable<String?> { get }
    var followingCount: Observable<String?> { get }
    var followerCount: Observable<String?> { get }
    var backgroundImageURL: Observable<URL?> { get }
    var profileURL: Observable<URL?> { get }
}

final class UserProfileView: UIView, NibLoadableView {

    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var profileIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingListButton: UIButton!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followerListButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileIconImageView.layer.cornerRadius = 8.0
        profileIconImageView.layer.masksToBounds = true
    }
        
}
