//
//  AYTextView_BIU.swift
//  Stack
//
//  Created by Yash Uttekar on 26/12/22.
//

import UIKit

extension AYTextView {
    
    func bold() {
        var currentAttributes = typingAttributes
        var isBold: Bool?
        
        if let font = currentAttributes[.font] as? UIFont {
            let traits = font.fontDescriptor.symbolicTraits
            if traits.contains(.traitBold) {
                currentAttributes[.font] = Fonts.shared.sfRounded.ofSize(size: font.pointSize)
                isBold = true
            } else {
                currentAttributes[.font] = Fonts.shared.sfRounded.bold().ofSize(size: font.pointSize)
                isBold = false
            }
        }
        
        attributedText.enumerateAttribute(.font, in: selectedRange) { attribute, range, pointee in
            if let font = attribute as? UIFont {
                if let isBold = isBold {
                    if isBold {
                        textStorage.addAttribute(.font, value: Fonts.shared.sfRounded.ofSize(size: font.pointSize), range: range)
                    } else {
                        textStorage.addAttribute(.font, value: Fonts.shared.sfRounded.bold().ofSize(size: font.pointSize), range: range)
                    }
                }
            }
        }
        
        typingAttributes =  currentAttributes
    }
    
    func italic() {
        var currentAttributes = typingAttributes
        var isBold: Bool?
        
        if let font = currentAttributes[.font] as? UIFont {
            var traits = font.fontDescriptor.symbolicTraits
            if traits.contains(.traitItalic) {
                traits.remove(.traitItalic)
                isBold = true
            } else {
                traits.insert(.traitItalic)
                isBold = false
            }
            let newFont = font.withTraits(traits)
            currentAttributes[.font] = newFont
        }
        
        attributedText.enumerateAttribute(.font, in: selectedRange) { attribute, range, pointee in
            if let font = attribute as? UIFont {
                var traits = font.fontDescriptor.symbolicTraits
                if let isBold = isBold {
                    if isBold {
                        traits.remove(.traitItalic)
                    } else {
                        traits.insert(.traitItalic)
                    }
                }
                let newFont = font.withTraits(traits)
                textStorage.addAttribute(.font, value: newFont, range: range)
            }
        }
        
        typingAttributes =  currentAttributes
    }
    
    func underline() {
        var currentAttributes = typingAttributes
        
        var underlineStyle: Int
        if currentAttributes[.underlineStyle] as? Int == 1 {
            underlineStyle = 0
        } else {
            underlineStyle = 1
        }
            
        currentAttributes[.underlineStyle] = underlineStyle
        textStorage.addAttribute(.underlineStyle, value: underlineStyle, range: selectedRange)
        
        typingAttributes =  currentAttributes
    }
    
    func strikethrough() {
        var currentAttributes = typingAttributes
        
        var underlineStyle: Int
        if currentAttributes[.strikethroughStyle] as? Int == 1 {
            underlineStyle = 0
        } else {
            underlineStyle = 1
        }
            
        currentAttributes[.strikethroughStyle] = underlineStyle
        textStorage.addAttribute(.strikethroughStyle, value: underlineStyle, range: selectedRange)
        
        typingAttributes =  currentAttributes
    }
}
