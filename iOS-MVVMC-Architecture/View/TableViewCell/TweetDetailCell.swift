//
//  TweetDetailCell.swift
//  iOS-MVVMC-Architecture
//
//  Created by Takahiro Nishinobu on 2017/05/21.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

protocol TweetDetailCellViewModelProtocol: class {
    
    var id: Observable<String?> { get }
    var userId: Observable<String?> { get }
    var userName: Observable<String?> { get }
    var screenName: Observable<String?> { get }
    var body: Observable<String?> { get }
    var profileURL: Observable<URL?> { get }
    var statusCount: Observable<String?> { get }
    
}

class TweetDetailCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = 4.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

}
