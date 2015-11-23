//
//  CandyTextField.swift
//  Candy_Counter
//
//  Created by GrepRuby3 on 30/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class CandyTextField : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTextFieldBasicProperty() {
        self.textColor = UIColor.appTextFieldColor()
        self.userInteractionEnabled = false
        self.textAlignment = .Right
        self.font = UIFont.totalCandyTextFieldFont()
        if isiPadAir2 {
            self.font = UIFont.appFontOfSize(65)
        }
        self.text = "0"
    }
    
    func setupCandyCountTextFieldBasicProperty(imageName:String) {
        self.background = UIImage(named: imageName)
        self.textColor = UIColor.appCandyCountTextFieldColor()
        self.userInteractionEnabled = false
        self.textAlignment = .Center
        self.font = UIFont.candyCountTextFieldFont()
        if isiPadAir2 {
            self.font = UIFont.appFontOfSize(45)
        }
        self.text = "0"
    }
    
    func setupCandyTotalCountTextFieldBasicProperty(imageName:String) {
        self.background = UIImage(named: imageName)
        self.textColor = UIColor.appCandyCountTextFieldColor()
        self.userInteractionEnabled = false
        self.textAlignment = .Center
        self.font = UIFont.candyTotalCountTextFieldFont()
        if isiPadAir2 {
            self.font = UIFont.appFontOfSize(55)
        }
        self.text = "0"
    }
    
}