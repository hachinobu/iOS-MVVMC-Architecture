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
    
    var userName: Observable<String?> { get }
    var screenName: Observable<String?> { get }
    var body: Observable<String?> { get }
    var profileURL: Observable<URL?> { get }
    
}

final class TimeLineTweetCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
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
