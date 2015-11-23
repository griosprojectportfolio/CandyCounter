//
//  CandyTypeController.swift
//  Candy_Counter
//
//  Created by GrepRuby3 on 29/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class CandyTypeController : BaseController , selectedCandyDelegate {
    
    @IBOutlet var txtCurrentCount : CandyTextField!
    @IBOutlet var scrollView : UIScrollView!
    var arrCandyData : NSArray = NSArray()
    var objSelectedCandy : Candy!
    var intPreselectedTag : Int = Int(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after appear the view.
        self.arrCandyData =  Candy.MR_findAllSortedBy("candy_id", ascending: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appear the view.
    }
    
    
    // MARK: - Candy buttons Tapped Methods
    @IBAction func candyButtonTapped(sender: UIButton) {
        
        if intPreselectedTag != 0 {
            var button = self.view.viewWithTag(intPreselectedTag) as! UIButton
            button.layer.borderColor = UIColor.clearColor().CGColor
        }
        self.intPreselectedTag = sender.tag
        self.objSelectedCandy = arrCandyData[sender.tag - 1] as! Candy
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    
    // MARK: - Other buttons Tapped Methods
    @IBAction func otherButtonTapped(sender: UIButton) {
        self.alertCandy = UIAlertController.alertWithTitleAndMessage("Choose Candy",message:"Please choose atleast one candy to add.", handler:{(objAlertAction : UIAlertAction!) -> Void in
        })
        self.presentViewController(self.alertCandy, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Add, Subtract and Multiply buttons Tapped Methods
    @IBAction func multiplyButtonTapped(sender: UIButton) {
        if objSelectedCandy != nil {
            let addCandy : AddCandyController = self.storyboard?.instantiateViewControllerWithIdentifier("AddCandy") as! AddCandyController
            addCandy.objCandy = objSelectedCandy
            self.navigationController?.pushViewController(addCandy, animated: false)
        }else{
            self.alertCandy = UIAlertController.alertWithTitleAndMessage("Choose Candy",message:"Please choose atleast one candy to multiply.", handler:{(objAlertAction : UIAlertAction!) -> Void in
            })
            self.presentViewController(self.alertCandy, animated: true, completion: nil)
        }
    }
    
    @IBAction func plusButtonTapped(sender: UIButton) {
        if objSelectedCandy != nil {
            objSelectedCandy.candy_count =  objSelectedCandy.candy_count.integerValue + 1
            self.saveCalculatedDataToDataBase()
        }else{
            self.alertCandy = UIAlertController.alertWithTitleAndMessage("Choose Candy",message:"Please choose atleast one candy to add.", handler:{(objAlertAction : UIAlertAction!) -> Void in
            })
            self.presentViewController(self.alertCandy, animated: true, completion: nil)
        }
    }
    
    @IBAction func minusButtonTapped(sender: UIButton) {
        
        if objSelectedCandy != nil {
            if objSelectedCandy.candy_count.integerValue > 0 {
                objSelectedCandy.candy_count =  objSelectedCandy.candy_count.integerValue - 1
                self.saveCalculatedDataToDataBase()
            }else {
                self.alertCandy = UIAlertController.alertWithTitleAndMessage(objSelectedCandy.candy_name, message:"You have only \(objSelectedCandy.candy_count.integerValue) candies", handler:{(objAlertAction : UIAlertAction!) -> Void in
                })
                self.presentViewController(self.alertCandy, animated: true, completion: nil)
            }
        }else{
            self.alertCandy = UIAlertController.alertWithTitleAndMessage("Choose Candy",message:"Please choose atleast one candy to subtract.", handler:{(objAlertAction : UIAlertAction!) -> Void in
            })
            self.presentViewController(self.alertCandy, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - Total , Download and Reset buttons Tapped Methods
    @IBAction func totalButtonTapped(sender: UIButton) {
        var totalView : TreatsTotalView = TreatsTotalView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - self.btnFacebook.frame.size.height - self.iAdView.frame.size.height))
        totalView.delegate = self
        self.view.addSubview(totalView)
    }
    
    @IBAction func downloadButtonTapped(sender: UIButton) {
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            self.alertCandy = UIAlertController.alertWithTitleAndMessage("Download",message:"Screen shot downloaded to Photos.", handler:{(objAlertAction : UIAlertAction!) -> Void in
            })
            self.presentViewController(self.alertCandy, animated: true, completion: nil)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.captureCurrentVisibleScreen(true)
            })
        })
        
    }
    
    @IBAction func resetButtonTapped(sender: UIButton) {
        let strMessage = "Do you want to reset all candies"
        self.alertCandy = UIAlertController.confirmAlertWithOkAndCancel(strMessage, handler: { (objAlertAction : UIAlertAction! ) -> Void in
            switch objAlertAction.style {
            case .Default :
                self.appDelegate.isDBSetUpped = false
                self.appDelegate.resetTablesInCoreData()
                self.activityIndicator = ActivityIndicatorView(frame: self.view.frame)
                self.activityIndicator.startActivityIndicator(self)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.arrCandyData =  Candy.MR_findAllSortedBy("candy_id", ascending: true)
                    self.assignDataToComponents()
                    self.activityIndicator.stopActivityIndicator(self)
                }
            case .Destructive :
                println("Destructive Button")
            case .Cancel :
                println("Cancel Button")
            }
        })
        self.presentViewController(self.alertCandy, animated: true, completion: nil)
    }
    
    
    
    // MARK: -  Save calculated Data in CoreData Base
    func saveCalculatedDataToDataBase(){
        var arrData : NSMutableArray = [["candy_id":objSelectedCandy.candy_id, "candy_name":objSelectedCandy.candy_name, "candy_img":objSelectedCandy.candy_img, "candy_count":objSelectedCandy.candy_count]]
        MagicalRecord.saveWithBlock({ (context : NSManagedObjectContext!) -> Void in
            Candy.entityFromArrayInContext(arrData , localContext:context)
        })
        self.arrCandyData =  Candy.MR_findAllSortedBy("candy_id", ascending: true)
        self.assignDataToComponents()
    }
    
    
    
    // MARK: - selectedCandyDelegate Dlegate Methods
    func getCandyObjectFromTreatsTotal(candyObj:Candy) {
        let addCandy : AddCandyController = self.storyboard?.instantiateViewControllerWithIdentifier("AddCandy") as! AddCandyController
        addCandy.objCandy = candyObj
        self.navigationController?.pushViewController(addCandy, animated: false)
    }
    
    
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        self.txtCurrentCount.setupTextFieldBasicProperty()
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 17 , self.scrollView.frame.size.height)
    }
    
    override func assignDataToComponents(){
        // This function use for assign data to components.
        var intTotalCandy : Int = Int(0)
        for objCandy in self.arrCandyData {
            let obj = objCandy as! Candy
            intTotalCandy = intTotalCandy + obj.candy_count.integerValue
            println(obj.candy_count.integerValue)
        }
        txtCurrentCount.text = "\(intTotalCandy)"
    }
}

