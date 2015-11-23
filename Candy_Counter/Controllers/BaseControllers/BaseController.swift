//
//  BaseController.swift
//  Candy_Counter
//
//  Created by GrepRuby3 on 29/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit
import iAd

let isiPhone4s     =   UIScreen.mainScreen().bounds.size.height == 480
let isiPhone5      =   UIScreen.mainScreen().bounds.size.width == 320
let isiPhone6      =   UIScreen.mainScreen().bounds.size.width == 375
let isiPhone6plus  =   UIScreen.mainScreen().bounds.size.width == 414
let isiPadAir2     =   UIScreen.mainScreen().bounds.size.width == 768.0

class BaseController: UIViewController , ADBannerViewDelegate {
    
    var sharedApi : ApiClient!
    var alertCandy : UIAlertController!
    var iAdView : ADBannerView!
    var activityIndicator : ActivityIndicatorView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet var btnFacebook : UIButton!
    @IBOutlet var btnInstagram : UIButton!
    @IBOutlet var btnTwitter: UIButton!

    
    // MARK: - View Related Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializeComponents()
        self.configureComponentsLayout()
        self.setupiAdBannerView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional before appear the view.
        self.navigationController?.navigationBar.hidden = true
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appear the view.
        let isAssignable = isAssignDataToComponents()
        if isAssignable {
            self.assignDataToComponents()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - iAd Framework Delegate Methods
    func setupiAdBannerView(){
        self.iAdView = ADBannerView(frame: CGRect.zeroRect)
        self.iAdView.frame = CGRectOffset(self.iAdView.frame,0,0.0)
        self.iAdView.delegate = self
        self.iAdView.hidden = true
        self.view.addSubview(self.iAdView)
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        println("Leaving app to the Ad")
        return true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.iAdView.center = CGPoint(x: self.iAdView.center.x, y: view.bounds.size.height - self.iAdView.frame.size.height / 2)
        self.iAdView.frame = CGRectOffset(self.iAdView.frame,0.0,-self.btnFacebook.frame.size.height)
        self.iAdView.hidden = false
        println("Displaying the Ad")
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.iAdView.center = CGPoint(x: self.iAdView.center.x, y: view.bounds.size.height + view.bounds.size.height)
        println("Ad is not available")
    }
    
    
    
    // MARK: - Bottom Share button Tapped Methods
    @IBAction func shareFacebookTapped(sender: UIButton) {
        let sharedImage : UIImage = self.captureCurrentVisibleScreen(false)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64( 0.5 * Double(NSEC_PER_SEC) ))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.shareImageOnSocials("My Total Candies", sharingImage:sharedImage, isFB:true)
        }
    }
    
    @IBAction func shareTwitterTapped(sender: UIButton) {
        let sharedImage : UIImage = self.captureCurrentVisibleScreen(false)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64( 0.5 * Double(NSEC_PER_SEC) ))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.shareImageOnSocials("My Total Candies", sharingImage:sharedImage, isFB:false)
        }
    }
    
    @IBAction func shareInstagramTapped(sender: UIButton) {
        let sharedImage : UIImage = self.captureCurrentVisibleScreen(false)
        InstagramManager.sharedManager.postImageToInstagramWithCaption(sharedImage, instagramCaption: "My Total Candies", view: self.view)
    }
    
    
    
    // MARK: - capture Screen and Share on Facebook and Twitter Methods
    func captureCurrentVisibleScreen(isSavePhoto:Bool) -> UIImage {
        
        let size = CGSizeMake(self.view.bounds.width, self.view.bounds.height)
        UIGraphicsBeginImageContext(size)
        //UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if isSavePhoto {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return image
    }
    
    func shareImageOnSocials(sharingText: String?, sharingImage: UIImage?, isFB : Bool) {
        var sharingItems : NSMutableArray = NSMutableArray()
        
        if let text = sharingText {
            sharingItems.addObject(text)
        }
        if let image = sharingImage {
            sharingItems.addObject(image)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems as [AnyObject], applicationActivities: nil)
        
        if isFB {
            activityViewController.excludedActivityTypes =  [
                UIActivityTypeAirDrop,
                UIActivityTypePostToTwitter,
                UIActivityTypePostToWeibo,
                UIActivityTypeMessage,
                UIActivityTypeMail,
                UIActivityTypePrint,
                UIActivityTypeCopyToPasteboard,
                UIActivityTypeAssignToContact,
                UIActivityTypeSaveToCameraRoll,
                UIActivityTypeAddToReadingList,
                UIActivityTypePostToFlickr,
                UIActivityTypePostToVimeo,
                UIActivityTypePostToTencentWeibo
            ]
        }else {
            activityViewController.excludedActivityTypes =  [
                UIActivityTypeAirDrop,
                UIActivityTypePostToFacebook,
                UIActivityTypePostToWeibo,
                UIActivityTypeMessage,
                UIActivityTypeMail,
                UIActivityTypePrint,
                UIActivityTypeCopyToPasteboard,
                UIActivityTypeAssignToContact,
                UIActivityTypeSaveToCameraRoll,
                UIActivityTypeAddToReadingList,
                UIActivityTypePostToFlickr,
                UIActivityTypePostToVimeo,
                UIActivityTypePostToTencentWeibo
            ]
        }
        
        if let popoverController = activityViewController.popoverPresentationController {
            
            if isFB {
                popoverController.sourceView = btnFacebook
                popoverController.sourceRect = btnFacebook.bounds
            }else{
                popoverController.sourceView = btnTwitter
                popoverController.sourceRect = btnTwitter.bounds
            }
        }
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    
    
    
    // MARK: - These functions use for initialization and set layout.
    func initializeComponents(){
        initializeApplicationApiClient()
        // This function use for common initialization of components.
    }
    
    func configureComponentsLayout(){
        // This function use for set layout of components.
    }
    
    func assignDataToComponents(){
        // This function use for assign data to components.
    }
    
    func isAssignDataToComponents()->Bool{
        // This function use for triger, assignDataToComponents on viewDidAppear based on return value.
        return true
    }
    
    func initializeApplicationApiClient(){
        // This function use for Api initialization and retrun object.
        // initialization your App api class
        sharedApi = ApiClient.sharedApiClient()
    }

    
}