//
//  InstagramManager.swift
//  InstagramSDK
//
//  Created by Attila Roy on 23/02/15.
//  share image with caption to instagram

import Foundation
import UIKit

private let documentInteractionController = UIDocumentInteractionController()

class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let kInstagramURL = "instagram://"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install Instagram application to share."
    
    // singleton manager
    class var sharedManager: InstagramManager {
        struct Singleton {
            static let instance = InstagramManager()
        }
        return Singleton.instance
    }
    
    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView) {
        // called to post image with caption to the instagram application
        
        let instagramURL = NSURL(string: kInstagramURL)
        if UIApplication.sharedApplication().canOpenURL(instagramURL!) {
            var jpgPath = NSTemporaryDirectory().stringByAppendingPathComponent(kfileNameExtension)
            UIImageJPEGRepresentation(imageInstagram, 1.0).writeToFile(jpgPath, atomically: true)
            var rect = CGRectZero
            var fileURL = NSURL.fileURLWithPath(jpgPath)
            documentInteractionController.URL = fileURL!
            documentInteractionController.delegate = self
            documentInteractionController.UTI = kUTI
            
            // adding caption for the image
            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
            documentInteractionController.presentOpenInMenuFromRect(rect, inView: view, animated: true)
        }
        else {
            
            // alert displayed when the instagram application is not available in the device
            UIAlertView(title: kAlertViewTitle, message: kAlertViewMessage, delegate:nil, cancelButtonTitle:"Ok").show()
        }
    }
}


