//
//  NetworkValidator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

enum NetworkValidatorError: Error {
    case APIError(Int)
}

struct NetworkValidator: Validator {
    
    func validate(_ input: (response: HTTPURLResponse, data: Data?)) throws -> Void {
        let statusCode = input.response.statusCode
        guard 200..<300 ~= statusCode else {
            throw NetworkValidatorError.APIError(statusCode)
        }
    }
    
}
