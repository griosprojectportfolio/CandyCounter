//
//  String+Candy.swift
//  Candy_Counter
//
//  Created by GrepRuby3 on 01/10/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

import Foundation
import UIKit

extension String {
    
    
    func removeCharsFromEndOfString(count_:Int) -> String {
        let stringLength = count(self)
        let substringIndex = (stringLength < count_) ? 0 : stringLength - count_
        let returnedString = self.substringToIndex(advance(self.startIndex, substringIndex))
        if returnedString.isEmpty {
            return "0"
        }else {
            return self.substringToIndex(advance(self.startIndex, substringIndex))
        }
    }
    
    func getMultiplicationResult() -> String {
        let arrSplited = self.componentsSeparatedByString("X")
        if arrSplited.count >= 2 {
            if var first_no : Int = arrSplited[0].toInt() , let second_no : Int = arrSplited[1].toInt() {
                return String(first_no * second_no)
            }
        }
        return "0"
    }
    
}