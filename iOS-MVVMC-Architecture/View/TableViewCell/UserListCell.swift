//
//  UserListCell.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/06/14.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

protocol UserListCellViewModelProtocol {
    
    var userId: Int { get }
    var userName: Observable<String?> { get }
    var screenName: Observable<String?> { get }
    var description: Observable<String?> { get }
    var profileURL: Observable<URL?> { get }
    
}

class UserListCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
