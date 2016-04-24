//
//  AlamofireNetworkRequestManager.swift
//  Gloss
//
// Copyright (c) 2016 Harlan Kellaway
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Alamofire
import Foundation

/**
 Alamofire network request manager.
 */
public struct AlamofireNetworkRequestManager: NetworkRequestManager {
    
    // MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - Convenience functions
    
    public func request<T: Decodable>(method: HTTPMethod, URLString: URLStringConvertible, parameters: [String : AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String : String]? = nil, completion: Alamofire.Result<T, NSError> -> ()) {
        let completion: Gloss.Result<T> -> () = {
            result in
            
            switch result {
            case Gloss.Result.Success(let value):
                completion(Alamofire.Result.Success(value))
            case Gloss.Result.Failure(let error):
                completion(Alamofire.Result.Failure(error as NSError))
            }
        }
        
        request(method, URLString: URLString.URLString, parameters: parameters, headers: headers, completion: completion)
    }
    
    public func request<T: Decodable>(method: HTTPMethod, URLString: URLStringConvertible, parameters: [String : AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String : String]? = nil, completion: Alamofire.Result<[T], NSError> -> ()) {
        let completion: Gloss.Result<[T]> -> () = {
            result in
            
            switch result {
            case Gloss.Result.Success(let value):
                completion(Alamofire.Result.Success(value))
            case Gloss.Result.Failure(let error):
                completion(Alamofire.Result.Failure(error as NSError))
            }
        }
        
        request(method, URLString: URLString.URLString, parameters: parameters, headers: headers, completion: completion)
    }
    
    // MARK: - Protocol conformance
    
    // MARK: NetworkRequestManager
    
    public func request<T: Decodable>(method: HTTPMethod, URLString: String, parameters: [String : AnyObject]?, headers: [String : String]?, completion: Gloss.Result<T> -> ()) {
        let requestMethod = alamofireMethodForMethod(method)
        
        let responseCompletion: Response<T, NSError> -> () = {
            response in
            
            switch response.result {
            case .Success(let value):
                completion(Gloss.Result(value: value))
            case .Failure(let error):
                completion(Gloss.Result(error: error))
            }
        }
        
        Alamofire.request(requestMethod, URLString, parameters: parameters, encoding: .URL, headers: headers).responseGlossDecodable(responseCompletion)
    }
    
    public func request<T : Decodable>(method: HTTPMethod, URLString: String, parameters: [String : AnyObject]?, headers: [String : String]?, completion: Gloss.Result<[T]> -> ()) {
        let requestMethod = alamofireMethodForMethod(method)
        
        let responseCompletion: Response<[T], NSError> -> () = {
            response in
            
            switch response.result {
            case .Success(let value):
                completion(Gloss.Result(value: value))
            case .Failure(let error):
                completion(Gloss.Result(error: error))
            }
        }
        
        Alamofire.request(requestMethod, URLString, parameters: parameters, encoding: .URL, headers: headers).responseGlossDecodable(responseCompletion)
    }
    
    // MARK: - Private functions
    
    private func alamofireMethodForMethod(method: HTTPMethod) -> Alamofire.Method {
        switch method {
        case .CONNECT:
            return Alamofire.Method.CONNECT
        case .DELETE:
            return Alamofire.Method.DELETE
        case .GET:
            return Alamofire.Method.GET
        case .HEAD:
            return Alamofire.Method.HEAD
        case .OPTIONS:
            return Alamofire.Method.OPTIONS
        case .PATCH:
            return Alamofire.Method.PATCH
        case .POST:
            return Alamofire.Method.POST
        case .PUT:
            return Alamofire.Method.PUT
        case .TRACE:
            return Alamofire.Method.TRACE
        }
    }
    
}
