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
        let identifier = T.storyboardIdentifier
        return UIStoryboard(name: identifier, bundle: nil).instantiateViewController(withIdentifier: T.storyboardIdentifier) as! T
    }
    
    static func instantiateInitialViewController<T: UIViewController>(withType type: T.Type) -> T where T: ReusableViewControllerProtocol {
        let identifier = T.storyboardIdentifier
        return UIStoryboard(name: identifier, bundle: nil).instantiateInitialViewController() as! T
    }
        
}
