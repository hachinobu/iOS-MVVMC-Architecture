//
//  TwitterRequest+Validator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

extension TwitterRequestProtocol {
    
    var validator: NetworkValidator {
        return NetworkValidator()
    }
    
}
