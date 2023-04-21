//
//  NetworkManager.swift
//  SVPSVadnagara
//
//  Created by Varun on 05/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

struct BaseObjectResponseParser<T:Mappable>: Mappable {
    public var data: T?
    public var status:Bool?
    public var message: String?
    init?(map: Map){
    }
    mutating func mapping(map: Map) {
        data <- map["data"]
        status <- map["status"]
        message <- map["message"]
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func request<T: Mappable>(_ urlString: String,
                                            method: HTTPMethod,
                                            params: Parameters?,
                                            type: T.Type,
                                            completion: @escaping (T?, String?) -> Void) {
        
        Alamofire.request(urlString, method: method, parameters: params).responseObject { (response: DataResponse<BaseObjectResponseParser<T>>) in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    if result.status ?? false {
                        completion(result.data, nil)
                    } else {
                        completion(nil, result.message)
                    }
                }
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
