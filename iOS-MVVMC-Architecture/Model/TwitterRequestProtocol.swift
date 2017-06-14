//
//  RequestProtocol.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import Accounts
import Social

enum TwitterRequestError: Error {
    case invalidParameters
    case invalidRequest
}

protocol TwitterRequestProtocol {
    
    associatedtype Response
    
    var method: SLRequestMethod { get }
    var path: String { get }
    var parameters: [String: Any]! { get }
    var account: ACAccount { get }
    var translator: ValueObjectTranslator<Response> { get }
    var validator: NetworkValidator { get }
    
    init(account: ACAccount, parameters: [String: Any]!)
    
}

extension TwitterRequestProtocol {
    
    var serviceType: String {
        return SLServiceTypeTwitter
    }
    
    var baseURL: URL {
        return URL(string: "https://api.twitter.com/1.1/")!
    }
    
    func buildRequest() throws -> SLRequest {
        let url = baseURL.appendingPathComponent(path)
        guard let parameters = parameters else {
            throw TwitterRequestError.invalidParameters
        }
        
        guard let request = SLRequest(forServiceType: serviceType, requestMethod: method, url: url, parameters: parameters) else {
            throw TwitterRequestError.invalidRequest
        }
        request.account = account
        
        return request
    }
    
}

