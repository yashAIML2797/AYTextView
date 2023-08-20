//
//  UITextView_Ext.swift
//  AYTextView
//
//  Created by Yash Uttekar on 06/07/23.
//

import UIKit

extension UITextView {
    
    func paragraphRange(for range: NSRange) -> NSRange {
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        let paragraphRange = mutableAttributedText.mutableString.paragraphRange(for: range)
        return paragraphRange
    }
    
    func paragraphString(for paragraphRange: NSRange) -> NSAttributedString {
        textStorage.attributedSubstring(from: paragraphRange)
    }
    
    var paragraphRange: NSRange {
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        let paragraphRange = mutableAttributedText.mutableString.paragraphRange(for: selectedRange)
        return paragraphRange
    }
    
    var paragraphString: NSAttributedString {
        textStorage.attributedSubstring(from: paragraphRange)
    }
}
