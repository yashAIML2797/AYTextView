//
//  NSRange_Ext.swift
//  AYTextView
//
//  Created by Yash Uttekar on 17/08/23.
//

import Foundation

extension NSRange {
    func isValid(for string: NSAttributedString) -> Bool {
        let range = string.maxRange
        
        return self.lowerBound >= range.lowerBound && self.upperBound <= range.upperBound
    }
}
