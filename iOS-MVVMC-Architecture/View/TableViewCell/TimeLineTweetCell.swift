//
//  TimeLineTweetCell.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/15.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

protocol TimeLineCellViewModel: class {
    
    var userName: PublishSubject<String> { get }
    var screenName: PublishSubject<String> { get }
    var body: PublishSubject<String> { get }
    var profileURL: PublishSubject<URL> { get }
    
}

final class TimeLineTweetCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = 4.0
    }

}
