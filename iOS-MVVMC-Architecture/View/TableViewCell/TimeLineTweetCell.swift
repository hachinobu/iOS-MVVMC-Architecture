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
    
    var id: Int64 { get }
    var userId: Int { get }
    var userName: Observable<String?> { get }
    var screenName: Observable<String?> { get }
    var body: Observable<String?> { get }
    var profileURL: Observable<URL?> { get }
    
}

final class TimeLineTweetCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = 8.0
        iconImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}
