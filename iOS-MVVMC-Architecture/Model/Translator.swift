//
//  Translator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol Translator {
    associatedtype Input
    associatedtype Output
    func translate(_ input: Input) throws -> Output
}

extension Collection {
    func map<T: Translator>(_ translator: T) throws -> [T.Output] where Self.Iterator.Element == T.Input {
        return try map { try translator.translate($0) }
    }
}

