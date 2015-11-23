//
//  ApiClient.swift
//  DemoAppSwift
//
//  Created by GrepRuby1 on 04/09/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import Foundation
import UIKit

var kAppAPIBaseURLString : String! = ""

class ApiClient : AFHTTPRequestOperationManager {
    
    // MARK: - API Clients
    class func sharedApiClient() -> ApiClient {
        
        var onceToken: dispatch_once_t = 0
        var instance: ApiClient = ApiClient()
        
        dispatch_once(&onceToken, { () -> Void in
            instance = ApiClient(baseURL : NSURL(string : kAppAPIBaseURLString))
        });
        return instance
    }
    
    // MARK: - API Initialization
    override init(baseURL url: NSURL?) {
        super.init(baseURL: url)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Check Network Reachability
    func isNetworkReachable() -> Bool{
        self.checkNetworkConnectionCompletionBlock({(isReachable:Bool) in
            println(isReachable)
        })
        return false
    }
    
    func checkNetworkConnectionCompletionBlock(isConnectedBlock:(isReachable : Bool) -> () ){
        
        let reachabilityManager : AFNetworkReachabilityManager = AFNetworkReachabilityManager.sharedManager()
        reachabilityManager.startMonitoring()
        reachabilityManager.setReachabilityStatusChangeBlock { ( status : AFNetworkReachabilityStatus) -> Void in
            
            var isConnect : Bool = false
            print(AFStringFromNetworkReachabilityStatus(status))
            if (status.rawValue == 1 || status.rawValue == 2 ){
                isConnect = true
            }
            
            if (isConnect){
                reachabilityManager.stopMonitoring()
                isConnectedBlock(isReachable : isConnect)
            }
        }
    }
    
    
    // MARK: - Base Method
    func baseRequestWithHTTPMethod(method : String, URLString : String, parameters : NSDictionary, successBlock:(task:AFHTTPRequestOperation, responseObject:AnyObject) ->(),failureBlock:(task:AFHTTPRequestOperation, error:NSError) ->()) -> AFHTTPRequestOperation {
        
        let isReachable : Bool = isNetworkReachable()
        var requestOperation : AFHTTPRequestOperation!
        
        if isReachable {
            
            var alert:UIAlertView = UIAlertView(title:"Network error!", message:"Network seems to be Disconnected", delegate:nil, cancelButtonTitle:"OK")
            alert.show()
            
            return requestOperation
            
        }else{
            
            var URL : String = kAppAPIBaseURLString.stringByAppendingString(URLString)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            var baseSuccessBlock: (task:AFHTTPRequestOperation!, responseObject:AnyObject!) ->() = { (task:AFHTTPRequestOperation!, responseObject:AnyObject!) ->() in
                print(responseObject)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                successBlock(task:task,responseObject:responseObject)
            };
            
            var baseFailureBlock: (task:AFHTTPRequestOperation!, error:NSError!) ->() = { (task:AFHTTPRequestOperation!, error:NSError!) ->() in
                print(error)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                failureBlock(task:task,error:error)
            };
            
            switch method {
                
            case "GET":
                requestOperation = self.GET(URL, parameters:parameters, success:baseSuccessBlock, failure:baseFailureBlock)
            case "POST":
                requestOperation = self.POST(URL, parameters:parameters, success:baseSuccessBlock, failure:baseFailureBlock)
            case "PATCH":
                requestOperation = self.PATCH(URL, parameters:parameters, success:baseSuccessBlock, failure:baseFailureBlock)
            case "DELETE":
                requestOperation = self.DELETE(URL, parameters:parameters, success:baseSuccessBlock, failure:baseFailureBlock)
            default:
                requestOperation = nil
            }
            
            return requestOperation
            
        }
    }
    
}