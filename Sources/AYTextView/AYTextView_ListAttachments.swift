//
//  AYTextView_ListAttachments.swift
//  AYTextView
//
//  Created by Yash Uttekar on 06/07/23.
//

import UIKit

extension AYTextView: NSTextLayoutManagerDelegate, NSTextContentStorageDelegate {
    func maintainListNewLineChar() {
        //Maintains a new line char in the end of the text in all cases.
        //This helps to draw lists (bullet) for a empty paragraph.
        let range = selectedRange
        
        if range.location == textStorage.length && range.length == 0 {
            isScrollEnabled = false
            textStorage.append(NSAttributedString(string: "\n", attributes: typingAttributes))
            isScrollEnabled = true
        }
        
        selectedRange = range
    }
    
    func addListAttachment(of type: ListAttachmentType, in range: NSRange) {
        
        textStorage.enumerateAttributes(in: range) { attributes, range, _ in
            if !(attributes[.listAttachment] is String) {
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
                    let newParagraphStyle = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
                    newParagraphStyle.firstLineHeadIndent += Constants.minIndent
                    newParagraphStyle.headIndent += Constants.minIndent
                    
                    textStorage.addAttribute(.paragraphStyle, value: newParagraphStyle, range: range)
                }
            }
        }
        
        if !(paragraphString.containListAttachments) {
            if let paragraphStyle = typingAttributes[.paragraphStyle] as? NSParagraphStyle {
                let newParagraphStyle = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
                newParagraphStyle.firstLineHeadIndent += Constants.minIndent
                newParagraphStyle.headIndent += Constants.minIndent
                
                typingAttributes[.paragraphStyle] = newParagraphStyle
            }
        }
        
        textStorage.addAttribute(.listAttachment, value: type.rawValue, range: range)
        configure()
    }
    
    func removeListAttachment(in range: NSRange) {
        
        textStorage.enumerateAttribute(.paragraphStyle, in: range) { attribute, range, _ in
            if let paragraphStyle = attribute as? NSParagraphStyle {
                let newParagraphStyle = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
                if newParagraphStyle.firstLineHeadIndent < Constants.minIndent {
                    newParagraphStyle.firstLineHeadIndent = 0
                    newParagraphStyle.headIndent = 0
                } else {
                    newParagraphStyle.firstLineHeadIndent -= Constants.minIndent
                    newParagraphStyle.headIndent -= Constants.minIndent
                }
                
                textStorage.addAttribute(.paragraphStyle, value: newParagraphStyle, range: range)
            }
        }
        
        if let paragraphStyle = typingAttributes[.paragraphStyle] as? NSParagraphStyle {
            let newParagraphStyle = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
            if newParagraphStyle.firstLineHeadIndent < Constants.minIndent {
                newParagraphStyle.firstLineHeadIndent = 0
                newParagraphStyle.headIndent = 0
            } else {
                newParagraphStyle.firstLineHeadIndent -= Constants.minIndent
                newParagraphStyle.headIndent -= Constants.minIndent
            }
            
            typingAttributes[.paragraphStyle] = newParagraphStyle
        }
        
        textStorage.removeAttribute(.listAttachment, range: range)
        configure()
    }
}
