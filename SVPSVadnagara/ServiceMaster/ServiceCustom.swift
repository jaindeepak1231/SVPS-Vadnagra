//
//  ServiceCustom.swift
//  SwiftTutorialDemo
//
//  Created by iMac-4 on 7/4/17.
//  Copyright © 2017 iMac-4. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class ServiceCustom: NSObject  {
    
    class var shared : ServiceCustom {
        struct Static {
            static let instance : ServiceCustom = ServiceCustom()
        }
        return Static.instance
    }
    
    var alamofireManager: SessionManager?
    let cookies = HTTPCookieStorage.shared
    var AuthorizationToken = ""
    
    
    //MARK: - API CALL
    
    func requestURL(_ URLString: URLConvertible, parameters: [String: Any]?,completion: @escaping ((URLRequest?, HTTPURLResponse?, _ JSON:NSDictionary?) -> Void), failure:@escaping ((Error) -> Void)) {
        
        let headers:HTTPHeaders = getHeaders()
        debugPrint(parameters ?? "No Parameter")
         print("===> \(URLString)")
        Alamofire.request(URLString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody), headers: headers)
            .responseJSON { response in
                
                switch(response.result) {
                    
                case .success( _):
                    if response.result.value != nil {

                        if let dataDict = response.value as? NSDictionary {
                            completion(response.request, response.response, dataDict)
                        }

                    }
                    break
                    
                case .failure(let encodingError):
                    print("Error:\(String(describing: response.result.error))")
                    failure(encodingError)
                    break
                }
            }
            .responseString { (responseString) in
                debugPrint("responseString:-",responseString)
        }
    }
    
    
    
    //MARK: - API CALL
    
    func requestURLwithData(_ URLString: URLConvertible, Method:String, parameters: [String: Any]?,completion: @escaping ((URLRequest?, HTTPURLResponse?, _ JSON:NSDictionary?, _ Data: Data?) -> Void), failure:@escaping ((Error) -> Void)) {
        
        let headers:HTTPHeaders = getHeaders()
        
        debugPrint(parameters ?? "No Parameter")
        print("===> \(URLString)")
        Alamofire.request(URLString, method: self.getHTTPMethod(strMethod: Method), parameters: parameters, encoding: URLEncoding(destination: .httpBody), headers: headers)
            .responseJSON { response in
                
                switch(response.result) {
                    
                case .success( _):
                    if response.result.value != nil {
                        
                        if let dataDict = response.value as? NSDictionary {
                            completion(response.request, response.response, dataDict, response.data)
                        }

                    }
                    break
                    
                case .failure(let encodingError):
                    print("Error:\(String(describing: response.result.error))")
                    failure(encodingError)
                    break
                }
            }
            .responseString { (responseString) in
                debugPrint("responseString:-",responseString)
        }
    }
    
    
    //MARK: - API CALL
    
    func requestURLwithBlankHeaderData(_ URLString: URLConvertible, Method:String, parameters: [String: Any]?,completion: @escaping ((URLRequest?, HTTPURLResponse?, _ JSON:NSDictionary?, _ Data: Data?) -> Void), failure:@escaping ((Error) -> Void)) {
        
        let headers:HTTPHeaders = getBlankHeader()

        debugPrint(parameters ?? "No Parameter")
        print("===> \(URLString)")
        Alamofire.request(URLString, method: self.getHTTPMethod(strMethod: Method), parameters: parameters, encoding: URLEncoding.default /* URLEncoding(destination: .httpBody)*/, headers: headers)
            .responseJSON { response in
                
                switch(response.result) {
                    
                case .success( _):
                    if response.result.value != nil {
                        
                        if let dataDict = response.value as? NSDictionary {
                            completion(response.request, response.response, dataDict, response.data)
                        }
                        
                    }
                    break
                    
                case .failure(let encodingError):
                    print("Error:\(String(describing: response.result.error))")
                    failure(encodingError)
                    break
                }
            }
            .responseString { (responseString) in
                debugPrint("responseString:-",responseString)
        }
    }
    
    
    
    //MARK:- Multi part request with parameters.
    func requestMultiPartWithUrlAndParameters(_ URLString: URLConvertible, Method:String, parameters: [String: Any]?, fileParameterName: String, fileName:String, fileData : Data, mimeType : String,completion: @escaping ((URLRequest?, HTTPURLResponse?, _ JSON:NSDictionary?, _ Data: Data?) -> Void), failure:@escaping ((Error) -> Void)) {
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // The for loop is to append all parameters to multipart form data.
                for element in parameters!.keys {
                    let strElement = String(element)
                    let strValueElement = parameters?[strElement] as! String
                    multipartFormData.append(strValueElement.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: strElement)
                }
                
                // Append file to multipart form data.
                multipartFormData.append(fileData, withName: fileParameterName, fileName: fileName, mimeType: mimeType)
        },
            to: URLString,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                        if response.result.value != nil {
                            if let dataDict = response.value as? NSDictionary {
                                completion(response.request, response.response, dataDict, response.data)
                            }
                        }
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    failure(encodingError)
                }
        })
    }
    
    
    
    //Multiple Image Upload
    //MARK: - upload multiple photos
    
    func requestMultipleImageWithUrlAndParameters(api_url: String, params:[String : Any]?,image1: UIImage,image2: UIImage, imag1: Bool?, imag2: Bool?, janmasharFile: Bool?, urlBase2: URL?, namePDF: String?, completion: @escaping ((URLRequest?, HTTPURLResponse?, _ JSON:NSDictionary?, _ Data: Data?) -> Void), failure:@escaping ((Error) -> Void)) {

        Alamofire.upload(multipartFormData: { multipartFormData in

            for (key, value) in params! {
                if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
            guard let imageData1 = image1.jpegData(compressionQuality: 0.75) else {
                return
            }

            multipartFormData.append(imageData1, withName: "photo", fileName: "image.jpg", mimeType: "image/jpeg")

            guard let imageData2 = image2.jpegData(compressionQuality: 0.75) else {
                return
            }

            multipartFormData.append(imageData2, withName: "photo_2", fileName: "image.jpg", mimeType: "image/jpeg")
            
            if janmasharFile ?? false {

                if let pdfData = NSData(contentsOfFile: urlBase2!.path) {
                    let data : Data = pdfData as Data
                    
                    multipartFormData.append(data, withName: "janmakshar", fileName: namePDF!, mimeType:"application/pdf")
                }
                
                
               // if let urlString = urlBase2 {
               // let pdfData = try! Data.init(contentsOf: urlBase2!)

                    //let pdfData = try! Data(contentsOf: urlString.asURL())
                   // let data : Data = pdfData

                
                

            }


        },
                         to:  api_url, encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    
                                    if response.result.value != nil {
                                        if let dataDict = response.value as? NSDictionary {
                                            completion(response.request, response.response, dataDict, response.data)
                                        }
                                    }
                                    
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                failure(encodingError)
                            }
        })
    }
    
    
    
    
    func requestURLwithMethod(_ URLString: URLConvertible, Method:String, parameters: [String: Any]?,completion: @escaping ((URLRequest?, HTTPURLResponse?,  _ JSON:NSDictionary?) -> Void), failure:@escaping ((Error) -> Void)) {
        
        let headers:HTTPHeaders = getHeaders()
        debugPrint(parameters ?? "No Parameter")
        print("===> \(URLString)")
        Alamofire.request(URLString, method: self.getHTTPMethod(strMethod: Method), parameters: parameters, encoding:URLEncoding(destination: .httpBody), headers: headers)
            .responseJSON { response in
                
                switch(response.result) {
                    
                case .success( _):
                    if response.result.value != nil {
                        
                        if let dataDict = response.value as? NSDictionary {
                            completion(response.request, response.response, dataDict)
                        }
                        
                    }
                    break
                    
                case .failure(let encodingError):
                    print("Error:\(String(describing: response.result.error))")
                    failure(encodingError)
                    break
                }
            }
            .responseString { (responseString) in
                debugPrint("responseString:-",responseString)
        }
    }
    
    
    func requestURLwithMethodForPassarray(_ URLString: URLConvertible, Method:String, parameters: [String: Any]?,completion: @escaping ((URLRequest?, HTTPURLResponse?,  _ JSON:NSDictionary?) -> Void), failure:@escaping ((Error) -> Void)) {
        
        let headers:HTTPHeaders = getHeaders()
        debugPrint(parameters ?? "No Parameter")
        print("===> \(URLString)")
        Alamofire.request(URLString, method: self.getHTTPMethod(strMethod: Method), parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                switch(response.result) {
                    
                case .success( _):
                    if response.result.value != nil {
                        
                        if let dataDict = response.value as? NSDictionary {
                            completion(response.request, response.response, dataDict)
                        }
                        
                    }
                    break
                    
                case .failure(let encodingError):
                    print("Error:\(String(describing: response.result.error))")
                    failure(encodingError)
                    break
                }
            }
            .responseString { (responseString) in
                debugPrint("responseString:-",responseString)
        }
    }
    
    
    
    func ServieceWithURlforJsonPass(methodType: HTTPMethod, params: NSMutableDictionary? = nil, api: String, Hendler complition:@escaping (_ JSON:NSDictionary?,_ status:Int , _ Data: Data?) -> Void){

        let headers:HTTPHeaders = getHeaders()

        print("===> \(api)")

        var request = Alamofire.request(api, method: methodType, parameters: nil, headers: headers)

        if params != nil{

            request = Alamofire.request(api, method: methodType, parameters: params as? [String : Any], encoding: JSONEncoding.default, headers: headers)
        }

        request.responseJSON(queue: nil, options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: { (response : DataResponse<Any>) in

            if response.result.isSuccess {

                if let dataDict = response.value as? NSDictionary{

                    complition(dataDict, dataDict["status"] as? Int ?? -1, response.data)

                }else{

                    complition(nil, -1, response.data)

                }

            }else if response.result.isFailure{

                let errorDict = NSMutableDictionary()
                errorDict["error"] =  response.result.error?.localizedDescription
                complition(errorDict, -1, nil)
                DismissProgressHud()
            }
            else{

                let errorDict = NSMutableDictionary()
                errorDict["error"] =  "Opps! Something went wrong please try again later."
                complition(errorDict, -1, nil)
                DismissProgressHud()
            }

        })
        
    }
    
    

    func requestURLWithReturn(_ URLString: URLConvertible, parameters: [String: Any]?,completion: @escaping ((URLRequest?, HTTPURLResponse?, JSON) -> Void), failure:@escaping ((Error) -> Void)) -> DataRequest {
        
        let headers:HTTPHeaders = getHeaders()
        debugPrint("parameters:-",parameters ?? "No Parameter")
        print("===> \(URLString)")
        let objReq = Alamofire.request(URLString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .httpBody), headers: headers)
            .responseJSON { response in
                
                switch(response.result) {
                case .success(let Value):
                    if response.result.value != nil{
                        let json = JSON(Value)
//                        print("===> \(URLString) \n ===>\(json)")
                        if json["status"].numberValue == 200 {

                        }
                        completion(response.request,response.response, json)
                        self.forcefullyLogout(jsonObj: json)
                    }
                    break
                    
                case .failure(let encodingError):
                    print("Error:\(String(describing: response.result.error))")
                    failure(encodingError)
                    break
                }
            }
            .responseString { (responseString) in
//                debugPrint("responseString:\(responseString)")
        }
        return objReq
    }

    func requestDownloadfile(_ URLString: URLConvertible, progressC: @escaping ((Double) -> Void), completion: @escaping ((DefaultDownloadResponse?) -> Void)) {
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        Alamofire.download(
            URLString,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
                 print("Progress: \(progress.fractionCompleted)")
                progressC(progress.fractionCompleted)
            }).response(completionHandler: { (DefaultDownloadResponse) in
                //here you able to access the DefaultDownloadResponse
                //result closure
                debugPrint("destination URL:-",DefaultDownloadResponse.destinationURL!)
                completion(DefaultDownloadResponse)
            })
    }
    
    func getHeaders() -> (HTTPHeaders) {
        return ["content-type": "application/x-www-form-urlencoded"]
    }
    
    func getBlankHeader() -> (HTTPHeaders) {
        return [:]
    }
    
    func getHTTPMethod(strMethod:String) -> HTTPMethod {
        switch strMethod {
        case "OPTIONS":
            return HTTPMethod.options
        case "GET":
            return HTTPMethod.get
        case "HEAD":
            return HTTPMethod.head
        case "POST":
            return HTTPMethod.post
        case "PUT":
            return HTTPMethod.put
        case "PATCH":
            return HTTPMethod.patch
        case "DELETE":
            return HTTPMethod.delete
        case "TRACE":
            return HTTPMethod.trace
        case "CONNECT":
            return HTTPMethod.connect
        default:
            return HTTPMethod.post
        }
    }
    
    //MARK:- USER HELPER
    
    func forcefullyLogout(jsonObj:JSON) {
        if let dictResult = jsonObj.dictionary {
            if let serverStatus = dictResult["status"]{
                if (serverStatus.number) == 401
                {
                }
            }
        }
    }
    
}


class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
