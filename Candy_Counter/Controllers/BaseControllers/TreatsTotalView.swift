//
//  TreatsTotalView.swift
//  Candy_Counter
//
//  Created by GrepRuby3 on 29/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

protocol selectedCandyDelegate {
    func getCandyObjectFromTreatsTotal(candyObj:Candy)
}

class TreatsTotalView : UIView , UITableViewDelegate , UITableViewDataSource {
    
    var imageView: UIImageView = UIImageView()
    var tblView : UITableView = UITableView()
    var txtTotalCounter : CandyTextField!
    var delegate: selectedCandyDelegate?
    var cancelButton : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
    var arrCandyData : NSArray = NSArray()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRectMake(frame.origin.x, frame.origin.y , frame.size.width, frame.size.height)
        self.applyDefaults(frame)
        self.getTotalNumberOfCandies()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func applyDefaults(frame: CGRect) {
        
        imageView.frame = CGRectMake(frame.origin.x, frame.origin.y , frame.size.width, frame.size.height)
        imageView.image = UIImage(named: "treatsTotalBox")
        imageView.userInteractionEnabled = true
        self.addSubview(imageView)

        cancelButton.frame = CGRectMake(frame.size.width - 40, frame.origin.y + 55, 20, 30)
        cancelButton.addTarget(self, action: Selector("removeCurrentFromSuper"), forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.setImage(UIImage(named: "treatsTotal-X"), forState: UIControlState.Normal)
        self.imageView.addSubview(cancelButton)
        
        txtTotalCounter = CandyTextField(frame:CGRectMake((frame.size.width / 2) - 80, frame.origin.y + 115 , 160, 50))
        txtTotalCounter.setupCandyTotalCountTextFieldBasicProperty("treatsTotalCounter")
        self.imageView.addSubview(txtTotalCounter)
        
        tblView.frame = CGRectMake(frame.origin.x + 10, frame.origin.y + 170 , frame.size.width - 20 , frame.size.height - 180)
        self.tblView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = UITableViewCellSeparatorStyle.None
        tblView.scrollEnabled = true
        tblView.backgroundColor = UIColor.clearColor()
        self.imageView.addSubview(tblView)
        
        self.setFrameSizeOfEachContent(frame)
    }
    
    
    func setFrameSizeOfEachContent(frame:CGRect){
        if isiPhone4s {
            cancelButton.frame = CGRectMake(frame.size.width - 34, frame.origin.y + 35, 20, 25)
            txtTotalCounter.frame = CGRectMake((frame.size.width / 2) - 80, frame.origin.y + 80 , 160, 50)
            tblView.frame = CGRectMake(frame.origin.x + 10, frame.origin.y + 130 , frame.size.width - 20 , frame.size.height - 140)
        }else if isiPhone5 {
            cancelButton.frame = CGRectMake(frame.size.width - 34, frame.origin.y + 43, 20, 30)
            txtTotalCounter.frame = CGRectMake((frame.size.width / 2) - 80, frame.origin.y + 100 , 160, 50)
            tblView.frame = CGRectMake(frame.origin.x + 10, frame.origin.y + 150 , frame.size.width - 20 , frame.size.height - 160)
        }else if isiPhone6plus {
            cancelButton.frame = CGRectMake(frame.size.width - 42, frame.origin.y + 60, 25, 35)
            txtTotalCounter.frame = CGRectMake((frame.size.width / 2) - 80, frame.origin.y + 130 , 160, 50)
            tblView.frame = CGRectMake(frame.origin.x + 10, frame.origin.y + 200 , frame.size.width - 20 , frame.size.height - 240)
        }else if isiPadAir2 {
            cancelButton.frame = CGRectMake(frame.size.width - 80, frame.origin.y + 85, 50, 50)
            txtTotalCounter.frame = CGRectMake((frame.size.width / 2) - 100, frame.origin.y + 180 , 200, 50)
            tblView.frame = CGRectMake(frame.origin.x + 20, frame.origin.y + 250 , frame.size.width - 40 , frame.size.height - 300)
        }
    }
    
    
    // MARK: - Cancel Button Tapped Action
    func removeCurrentFromSuper(){
        self.removeFromSuperview()
    }
    
    
    // MARK: - TableView Delegate and Data Source Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCandyData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let objCandy : Candy = arrCandyData[indexPath.row] as! Candy
        
        var cell  = self.tblView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        cell?.backgroundColor = UIColor.clearColor()
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        
        var candyImage : UIImageView = UIImageView(frame: CGRectMake(cell!.frame.origin.x + 20 ,cell!.frame.origin.y + 7 , 55, 30))
        candyImage.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin)
        candyImage.image = UIImage(named: objCandy.candy_img)
        cell?.addSubview(candyImage)
        
        var txtCandyCounter : CandyTextField = CandyTextField(frame:CGRectMake(cell!.center.x - 50, self.frame.origin.y + 15, 100, 40))
        txtCandyCounter.autoresizingMask = ( UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin)
        txtCandyCounter.setupCandyCountTextFieldBasicProperty("treatsCandyCounter")
        txtCandyCounter.text = "\(objCandy.candy_count)"
        cell?.addSubview(txtCandyCounter)
        
        var addButton : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        addButton.tag = indexPath.row
        addButton.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin )
        addButton.frame = CGRectMake(cell!.center.x + 70, cell!.frame.origin.y + 10, 30, 20)
        if isiPadAir2 {
            addButton.frame = CGRectMake(cell!.center.x + 30, cell!.frame.origin.y + 10, 30, 20)
        }
        addButton.addTarget(self, action: Selector("cellAddButtonTappedAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        addButton.setImage(UIImage(named: "treatsCandyPlus"), forState: UIControlState.Normal)
        cell?.addSubview(addButton)
        
        var minusButton : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        minusButton.tag = indexPath.row
        minusButton.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin )
        minusButton.frame = CGRectMake(cell!.center.x + 110, cell!.frame.origin.y + 10, 30, 20)
        minusButton.addTarget(self, action: Selector("cellRemoveButtonTappedAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        minusButton.setImage(UIImage(named: "treatsCandyMinus"), forState: UIControlState.Normal)
        cell?.addSubview(minusButton)
        
        return cell!
        
    }
    
    
    
    // MARK: - TableView Button Tap Methods
    func cellAddButtonTappedAction(sender:UIButton){
        self.removeCurrentFromSuper()
        self.delegate?.getCandyObjectFromTreatsTotal(self.arrCandyData[sender.tag] as! Candy)
    }
    
    func cellRemoveButtonTappedAction(sender:UIButton){
        self.removeCurrentFromSuper()
        self.delegate?.getCandyObjectFromTreatsTotal(self.arrCandyData[sender.tag] as! Candy)
    }
    
    
    
    // MARK: - Get Display Data From DataBase Methods
    func getTotalNumberOfCandies(){
        
        let totalPredicate : NSPredicate = NSPredicate(format: "candy_count != 0 ")
        self.arrCandyData =  Candy.MR_findAllSortedBy("candy_id", ascending: true, withPredicate: totalPredicate)
        
        var intTotalCandy : Int = Int(0)
        
        for objCandy in self.arrCandyData {
            let obj = objCandy as! Candy
            intTotalCandy = intTotalCandy + obj.candy_count.integerValue
            println(obj.candy_count.integerValue)
        }
        txtTotalCounter.text = "\(intTotalCandy)"
    }
    
}