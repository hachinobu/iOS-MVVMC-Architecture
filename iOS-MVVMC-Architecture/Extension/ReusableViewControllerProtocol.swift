//
//  ReusableViewControllerProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/09.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol ReusableViewControllerProtocol: class {}

extension ReusableViewControllerProtocol where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
}

extension UIViewController: ReusableViewControllerProtocol {}
