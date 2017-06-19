//
//  NibLoadableView.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/16.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
    
    static func loadView() -> Self {
        return UINib(nibName: nibName, bundle: nil)
            .instantiate(withOwner: self, options: nil)[0] as! Self
    }
    
}

extension UITableViewCell: NibLoadableView {}


