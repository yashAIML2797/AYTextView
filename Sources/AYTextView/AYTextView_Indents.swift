//
//  AYTextView_Indents.swift
//  Stack
//
//  Created by Yash Uttekar on 26/12/22.
//

import UIKit

extension AYTextView {
    
    func indentRight() {
        if paragraphString.length != 0 {
            var indents: [(style: NSParagraphStyle, range: NSRange)] = []
            textStorage.enumerateAttributes(in: paragraphRange) { attributes, range, _ in
                var newParagraphStyle: NSMutableParagraphStyle
                
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
                    newParagraphStyle = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
                } else {
                    newParagraphStyle = NSMutableParagraphStyle()
                }
                
                if newParagraphStyle.firstLineHeadIndent < Constants.maxIndent {
                    newParagraphStyle.firstLineHeadIndent += Constants.minIndent
                    newParagraphStyle.headIndent += Constants.minIndent
                } else {
                    newParagraphStyle.firstLineHeadIndent = Constants.maxIndent
                    newParagraphStyle.headIndent = Constants.maxIndent
                }
                
                indents.append((newParagraphStyle, range))
            }
            for indent in indents {
                textStorage.addAttribute(.paragraphStyle, value: indent.style, range: indent.range)
            }
        }
        
        //TypingAttributes
        var newParagraphStyle: NSMutableParagraphStyle
        
        if let paragraphStyle = typingAttributes[.paragraphStyle] as? NSParagraphStyle {
            newParagraphStyle = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
        } else {
            newParagraphStyle = NSMutableParagraphStyle()
        }
        
        if newParagraphStyle.firstLineHeadIndent <= Constants.maxIndent {
            newParagraphStyle.firstLineHeadIndent += Constants.minIndent
            newParagraphStyle.headIndent += Constants.minIndent
        } else {
            newParagraphStyle.firstLineHeadIndent = Constants.maxIndent
            newParagraphStyle.headIndent = Constants.maxIndent
        }
        
        typingAttributes[.paragraphStyle] = newParagraphStyle
        configure()
    }
    
    func indentLeft() {
        if paragraphString.length != 0 {
            var indents: [(style: NSParagraphStyle, range: NSRange)] = []
            textStorage.enumerateAttributes(in: paragraphRange) { attributes, range, _ in
                var newParagraphStyle: NSMutableParagraphStyle
                
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
                    newParagraphStyle = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
                } else {
                    newParagraphStyle = NSMutableParagraphStyle()
                }
                
                if attributes[.listAttachment] is String {
                    if newParagraphStyle.firstLineHeadIndent > Constants.minIndent {
                        newParagraphStyle.firstLineHeadIndent -= Constants.minIndent
                        newParagraphStyle.headIndent -= Constants.minIndent
                    } else {
                        newParagraphStyle.firstLineHeadIndent = Constants.minIndent
                        newParagraphStyle.headIndent = Constants.minIndent
                    }
                } else {
                    if newParagraphStyle.firstLineHeadIndent > 0 {
                        newParagraphStyle.firstLineHeadIndent -= Constants.minIndent
                        newParagraphStyle.headIndent -= Constants.minIndent
                    } else {
                        newParagraphStyle.firstLineHeadIndent = 0
                        newParagraphStyle.headIndent = 0
                    }
                }
                
                indents.append((newParagraphStyle, range))
            }
            for indent in indents {
                textStorage.addAttribute(.paragraphStyle, value: indent.style, range: indent.range)
            }
        }
        
        //TypingAttributes
        var newParagraphStyle: NSMutableParagraphStyle
        
        if let paragraphStyle = typingAttributes[.paragraphStyle] as? NSParagraphStyle {
            newParagraphStyle = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
        } else {
            newParagraphStyle = NSMutableParagraphStyle()
        }
        
        if typingAttributes[.listAttachment] is String {
            if newParagraphStyle.firstLineHeadIndent > Constants.minIndent {
                newParagraphStyle.firstLineHeadIndent -= Constants.minIndent
                newParagraphStyle.headIndent -= Constants.minIndent
            } else {
                newParagraphStyle.firstLineHeadIndent = Constants.minIndent
                newParagraphStyle.headIndent = Constants.minIndent
            }
        } else {
            if newParagraphStyle.firstLineHeadIndent > 0 {
                newParagraphStyle.firstLineHeadIndent -= Constants.minIndent
                newParagraphStyle.headIndent -= Constants.minIndent
            } else {
                newParagraphStyle.firstLineHeadIndent = 0
                newParagraphStyle.headIndent = 0
            }
        }
        
        typingAttributes[.paragraphStyle] = newParagraphStyle
        configure()
    }
}
