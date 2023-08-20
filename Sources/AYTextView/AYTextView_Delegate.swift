//
//  AYTextView_Delegate.swift
//  AYTextView
//
//  Created by Yash Uttekar on 18/08/23.
//

import UIKit

extension AYTextView: UITextViewDelegate {

    public func textViewDidChangeSelection(_ textView: UITextView) {
        //Ignores the last new line char that we are adding.
        if textStorage.length != 0 {
            let range = NSRange(location: textStorage.length - 1, length: 1)
            let string = textStorage.attributedSubstring(from: range).string
            
            if  string == "\n" && (selectedRange.location + selectedRange.length) == textStorage.length {
                if selectedRange.length == 0 {
                    selectedRange = NSRange(location: selectedRange.location - 1, length: selectedRange.length)
                } else {
                    selectedRange = NSRange(location: selectedRange.location, length: selectedRange.length - 1)
                }
            }
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        //Maintaining custom attribute by adding it to the new text.
        if let type = listAttachmentType {
            textView.textStorage.addAttribute(.listAttachment, value: type.rawValue, range: textView.paragraphRange)
            listAttachmentType = nil
        }
        
        if shouldRemoveListAttachment {
            removeListAttachment(in: paragraphRange)
            shouldRemoveListAttachment = false
        }
        
        self.maintainListNewLineChar()
        self.configure()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard textView.textStorage.length > 0 else {
            return true
        }
        
        //Updates attributes for new line char that we are adding
        if textStorage.length > 0 {
            if selectedRange.upperBound == textStorage.length - 1 {
                textStorage.addAttributes(typingAttributes, range: NSRange(location: textStorage.length - 1, length: 1))
            }
        }
        
        //Maintain custom lists attribute
        if let type = textView.paragraphString.listAttachmentType {
            if text == "\n" && type.rawValue == ListAttachmentType.checkboxChecked.rawValue {
                listAttachmentType = ListAttachmentType.checkboxUnchecked
            } else {
                listAttachmentType = type
            }
        }
        
        //Detect if user press backspace
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                //Removes lists (bullet) if pressed backspace after it
                if textView.paragraphString.containListAttachments,
                   textView.selectedRange.location == textView.paragraphRange.location,
                   textView.selectedRange.length == 0 {
                    removeListAttachment(in: textView.paragraphRange)
                    listAttachmentType = nil
                    return false
                }
                
                //Selects NSTextAttachment if pressed backspace after it
                if let temp = isAttachmentBeforeRange(range: selectedRange) {
                    if temp && textView.selectedRange.length == 0 {
                        let range = NSRange(location: textView.selectedRange.location - 1, length: 1)
                        textView.selectedRange = range
                        return false
                    }
                }
            }
        }
        
        //Removes lists (bullet) if pressed enter after it
        if text == "\n" {
            if textView.paragraphString.containListAttachments,
               textView.paragraphString.length == 1,
               textView.paragraphString.string == "\n"
            {
                removeListAttachment(in: textView.paragraphRange)
                listAttachmentType = nil
                return false
            }
        }
        
        if selectedRange.length > 0 {
            let paragraphRange = textView.paragraphRange(for: NSRange(location: selectedRange.location, length: 0))
            let paragraphString = textView.paragraphString(for: paragraphRange)
            if !paragraphString.containListAttachments {
                shouldRemoveListAttachment = true
            }
        }
        
        return true
    }
}
