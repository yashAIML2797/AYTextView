//
//  AYTextView_Font.swift
//  AYTextView
//
//  Created by Yash Uttekar on 17/08/23.
//

import UIKit


extension AYTextView {
    
    func changeFontSize(of font: UIFont, to pointSize: CGFloat, in range: NSRange? = nil) {
        guard pointSize >= Constants.minFontSize && pointSize <= Constants.maxFontSize else {
            return
        }
        
        let newFont = font.ofSize(size: pointSize)
        
        if let range = range {
            textStorage.addAttribute(.font, value: newFont, range: range)
        } else {
            typingAttributes[.font] = newFont
        }
    }
    
    func increaseFontSize() {
        textStorage.enumerateAttribute(.font, in: selectedRange) { attribute, range, _ in
            if let font = attribute as? UIFont {
                self.changeFontSize(of: font, to: font.pointSize + 2, in: range)
            }
        }
        
        if let font = typingAttributes[.font] as? UIFont {
            self.changeFontSize(of: font, to: font.pointSize + 2)
        }
        
        configure()
        setNeedsDisplay()
    }
    
    func reduceFontSize() {
        textStorage.enumerateAttribute(.font, in: selectedRange) { attribute, range, _ in
            if let font = attribute as? UIFont {
                self.changeFontSize(of: font, to: font.pointSize - 2, in: range)
            }
        }
        
        if let font = typingAttributes[.font] as? UIFont {
            self.changeFontSize(of: font, to: font.pointSize - 2)
        }
        
        configure()
        setNeedsDisplay()
    }
}
