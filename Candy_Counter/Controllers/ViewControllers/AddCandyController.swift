//
//  AddCandyController.swift
//  Candy_Counter
//
//  Created by GrepRuby3 on 29/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class AddCandyController : BaseController , selectedCandyDelegate {
    
    @IBOutlet var txtCurrentCount : CandyTextField!
    var objCandy : Candy!
    
    
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
    }
    
    
    
    // MARK: - Numbers Button button Tapped Methods
    @IBAction func NumbersButtonTapped(sender: UIButton) {
        if txtCurrentCount.text == "0" {
            txtCurrentCount.text = String(sender.tag)
        }else {
            txtCurrentCount.text = txtCurrentCount.text + String(sender.tag)
        }
    }
    
    
    
    // MARK: - Other Button button Tapped Methods
    @IBAction func cancelButtonTapped(sender: UIButton) {
        txtCurrentCount.text =  txtCurrentCount.text.removeCharsFromEndOfString(1)
    }
    
    @IBAction func multiplyButtonTapped(sender: UIButton) {
        if txtCurrentCount.text != "0" && txtCurrentCount.text.rangeOfString("X") == nil {
            txtCurrentCount.text = txtCurrentCount.text + "X"
        }
    }
    
    @IBAction func plusButtonTapped(sender: UIButton) {
        
        if txtCurrentCount.text.rangeOfString("X") == nil {
            if let intEnteredAmount : Int = String(txtCurrentCount.text).toInt() {
                objCandy.candy_count =  objCandy.candy_count.integerValue + intEnteredAmount
                self.saveCalculatedDataToDataBase()
            }
        }
    }
    
    @IBAction func minusButtonTapped(sender: UIButton) {
        
        if txtCurrentCount.text.rangeOfString("X") == nil {
            if let intEnteredAmount : Int = String(txtCurrentCount.text).toInt() {
                if intEnteredAmount <= objCandy.candy_count.integerValue {
                    objCandy.candy_count =  objCandy.candy_count.integerValue - intEnteredAmount
                    self.saveCalculatedDataToDataBase()
                }else {
                    self.alertCandy = UIAlertController.alertWithTitleAndMessage(objCandy.candy_name, message:"You have only \(objCandy.candy_count.integerValue) candies", handler:{(objAlertAction : UIAlertAction!) -> Void in
                    })
                    self.presentViewController(self.alertCandy, animated: true, completion: nil)
                }
            }
        }
    }
    
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
        let strMessage = "Do you want to reset all \(objCandy.candy_name) candies"
        self.alertCandy = UIAlertController.confirmAlertWithOkAndCancel(strMessage, handler: { (objAlertAction : UIAlertAction! ) -> Void in
            switch objAlertAction.style {
            case .Default :
                self.objCandy.candy_count = 0
                self.saveCalculatedDataToDataBase()
            case .Destructive :
                println("Destructive Button")
            case .Cancel :
                println("Cancel Button")
            }
        })
        self.presentViewController(self.alertCandy, animated: true, completion: nil)
    }
    
    @IBAction func equalsButtonTapped(sender: UIButton) {
        if txtCurrentCount.text.rangeOfString("X") != nil {
            if let intEnteredAmount : Int = txtCurrentCount.text.getMultiplicationResult().toInt() {
                objCandy.candy_count =  objCandy.candy_count.integerValue + intEnteredAmount
                self.saveCalculatedDataToDataBase()
            }
        }else{
            self.navigationController?.popViewControllerAnimated(false)
        }
    }
    
    
    
    // MARK: -  Save calculated Data in CoreData Base
    func saveCalculatedDataToDataBase(){
        var arrData : NSMutableArray = [["candy_id":objCandy.candy_id, "candy_name":objCandy.candy_name, "candy_img":objCandy.candy_img, "candy_count":objCandy.candy_count]]
        MagicalRecord.saveWithBlock({ (context : NSManagedObjectContext!) -> Void in
            Candy.entityFromArrayInContext(arrData , localContext:context)
        })
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    
    // MARK: - selectedCandyDelegate Dlegate Methods
    func getCandyObjectFromTreatsTotal(candyObj:Candy) {
        objCandy = candyObj
        self.txtCurrentCount.text = "0"
    }
    
    // MARK: -  Overrided Methods of BaseController
    override func configureComponentsLayout(){
        // This function use for set layout of components.
        self.txtCurrentCount.setupTextFieldBasicProperty()
        self.txtCurrentCount.text = "0"
    }
    
}

