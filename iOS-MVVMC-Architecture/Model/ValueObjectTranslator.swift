//
//  ValueObjectTranslator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

enum ValueObjectTranslatorError: Error {
    case dataIsRequired
    case mappingToEntity
}

struct ValueObjectTranslator<ValueObject>: Translator {
    
    public typealias Input = (HTTPURLResponse, Data?)
    public typealias Output = ValueObject
    
    fileprivate let _translate: (Input) throws -> Output
    
    init<T>(translator: T) where T: Translator, Input == T.Input, Output == T.Output {
        _translate = translator.translate
    }
    
    init(_ closure: @escaping (Input) throws -> Output) {
        _translate = closure
    }
    
    func translate(_ input: Input) throws -> Output {
        return try _translate(input)
    }
    
}
