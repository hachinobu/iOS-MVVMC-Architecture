//
//  Storyboard+Extension.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/05/09.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func instantiateViewController<T: UIViewController>(withType type: T.Type) -> T where T: ReusableViewControllerProtocol {
        return UIStoryboard().instantiateViewController(withIdentifier: T.storyboardIdentifier) as! T
    }
    
}
