//
//  TwitterRequestProtocol+Translator.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

extension TwitterRequestProtocol {
    
    fileprivate func parse(with data: Data) throws -> Any {
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
    
}

extension TwitterRequestProtocol where Response == Void {
    
    var translator: ValueObjectTranslator<Response> {
        return ValueObjectTranslator<Response> { _ in
            return
        }
    }
    
}

extension TwitterRequestProtocol where Response: ImmutableMappable {
    
    var translator: ValueObjectTranslator<Response> {
        return ValueObjectTranslator<Response> { _, data in
            guard let data = data else { throw ValueObjectTranslatorError.dataIsRequired }
            let json = try self.parse(with: data)
            return try Mapper().map(JSONObject: json)
        }
    }
    
}

extension TwitterRequestProtocol where Response: Sequence, Response.Iterator.Element: ImmutableMappable {
    
    var translator: ValueObjectTranslator<Response> {
        return ValueObjectTranslator<Response> { _, data in
            guard let data = data else { throw ValueObjectTranslatorError.dataIsRequired }
            let json = try self.parse(with: data)
            guard let jsonArray = json as? [[String: Any]] else {
                throw ValueObjectTranslatorError.mappingToEntity
            }
            let mapper = Mapper<Response.Iterator.Element>()
            return try mapper.mapArray(JSONArray: jsonArray) as! Self.Response
        }
    }
    
}

extension TwitterRequestProtocol where Response: Mappable {
    
    var translator: ValueObjectTranslator<Response> {
        return ValueObjectTranslator<Response> { _, data in
            guard let data = data else { throw ValueObjectTranslatorError.dataIsRequired }
            let json = try self.parse(with: data)
            guard let object = Mapper<Response>().map(JSONObject: json) else { throw ValueObjectTranslatorError.mappingToEntity }
            return object
        }
    }
    
}
