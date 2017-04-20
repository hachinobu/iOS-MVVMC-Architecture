//
//  TwitterApiClient.swift
//  iOS-MVVMC-Architecture
//
//  Created by Nishinobu.Takahiro on 2017/04/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import Accounts
import Social

enum APIError: Error {
    case connectionError(Error)
    case requestError(Error)
    case responseError(Error)
}

enum ResponseError: Error {
    case nonHTTPURLResponse(URLResponse?)
    case unacceptableStatusCode(Int)
    case unexpectedObject(Any)
}

protocol TwitterApiClientProtocol {
    static func execute<R>(request: R) -> Observable<R.Response> where R :TwitterRequestProtocol
}

struct TwitterApiClient: TwitterApiClientProtocol {
    
    static func execute<R>(request: R) -> Observable<R.Response> where R :TwitterRequestProtocol {
        
        return Observable.create { observer -> Disposable in
            
            let apiRequest: SLRequest
            do {
                apiRequest = try request.buildRequest()
            } catch {
                observer.onError(APIError.requestError(error))
                return Disposables.create()
            }
            
            apiRequest.perform { data, response, error in
                
                switch (data, response, error) {
                case (_, _, let error?):
                    observer.onError(error)
                case (let data?, let response?, _):
                    do {
                        try request.validator.validate((response, data))
                        let responseObject = try request.translator.translate((response, data))
                        observer.onNext(responseObject)
                    } catch {
                        observer.onError(error)
                    }
                default:
                    observer.onError(ResponseError.nonHTTPURLResponse(response))
                }
                
                observer.onCompleted()
                
            }
            
            return Disposables.create()
            
        }
        
    }
    
}

