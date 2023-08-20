//
//  AYTextView_Checkbox.swift
//  TextEditor
//
//  Created by Yash Uttekar on 06/06/22.
//

import SwiftUI

extension AYTextView: UIGestureRecognizerDelegate {
    func handleCheckbox() {
        maintainListNewLineChar()
        if paragraphString.containsCheckbox {
            textStorage.enumerateAttribute(.listAttachment, in: paragraphRange) { attribute, range, _ in
                if let listAttachment = attribute as? String,
                   (listAttachment == ListAttachmentType.checkboxChecked.rawValue || listAttachment == ListAttachmentType.checkboxUnchecked.rawValue) {
                    removeListAttachment(in: range)
                }
            }
        } else {
            addListAttachment(of: .checkboxUnchecked, in: paragraphRange)
        }
    }
    
    func addTapGestureForCheckbox() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnCheckbox))
        tap.name = "checkbox"
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    
    @objc func handleTapOnCheckbox(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        
        if let tapPosition = closestPosition(to: location),
           let range = textRange(from: tapPosition, to: tapPosition) {
            
            let loc = offset(from: beginningOfDocument, to: tapPosition)
            let length = offset(from: range.start, to: range.end)
            
            let range = NSRange(location: loc, length: length)
            
            let paraRange = textStorage.mutableString.paragraphRange(for: range)
            if paraRange.length > 0 {
                let paraString = textStorage.attributedSubstring(from: paraRange)
                let attributes = paraString.attributes(at: 0, effectiveRange: nil)
                if let type = attributes[.listAttachment]  as? String, paraString.containsCheckbox {
                    if ListAttachmentType(rawValue: type) == .checkboxChecked {
                        textStorage.addAttribute(.listAttachment, value: ListAttachmentType.checkboxUnchecked.rawValue, range: paraRange)
                    } else {
                        textStorage.addAttribute(.listAttachment, value: ListAttachmentType.checkboxChecked.rawValue, range: paraRange)
                    }
                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                    generator.impactOccurred()
                    configure()
                    return
                }
            }
            
            let _ = becomeFirstResponder()
            selectedRange = range
        }
    }
    
    func checkIfTappedOnCheckbox(location: CGPoint) -> Bool {
        //Detects if tap is on the checkbox
        var didTapOnTheCheckbox = false
        
        if let tapPosition = closestPosition(to: location),
           let range = textRange(from: tapPosition, to: tapPosition) {
            
            let loc = offset(from: beginningOfDocument, to: tapPosition)
            let length = offset(from: range.start, to: range.end)
            
            let range = NSRange(location: loc, length: length)
            let paraRange = textStorage.mutableString.paragraphRange(for: range)
            
            if paraRange.length > 0 {
                let paraString = textStorage.attributedSubstring(from: paraRange)
                let attributes = paraString.attributes(at: 0, effectiveRange: nil)
                
                if let type = attributes[.listAttachment]  as? String,
                   (ListAttachmentType(rawValue: type) == .checkboxChecked || ListAttachmentType(rawValue: type) == .checkboxUnchecked) {
                    if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
                        let xLimit = (paragraphStyle.firstLineHeadIndent - Constants.minIndent) + (frame.width * 0.05)
                        let isInXBounds = location.x >= xLimit && location.x <= xLimit + 30 + textContainerInset.left
                        
                        let boundingRect = layoutManager.boundingRect(forGlyphRange: paraRange, in: textContainer)
                        let lineHeight = layoutManager.lineFragmentRect(forGlyphAt: loc, effectiveRange: nil)
                        let yLimit = boundingRect.origin.y + 20
                        
                        let isInYBounds = location.y >= yLimit && location.y <= yLimit + lineHeight.height
                        
                        didTapOnTheCheckbox = isInXBounds && isInYBounds
                    }
                }
            }
        }
        
        return didTapOnTheCheckbox
    }
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //Allow tap gesture only if tapped on the checkbox
        if let gesture = gestureRecognizer as? UITapGestureRecognizer,
           gesture.name == "checkbox" {
            let location = gesture.location(in: gesture.view)

            let shouldBegin = checkIfTappedOnCheckbox(location: location)
            
            return shouldBegin
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gesture = gestureRecognizer as? UITapGestureRecognizer,
           gesture.name == "checkbox" {
            let location = gesture.location(in: gesture.view)

            return checkIfTappedOnCheckbox(location: location)
        }
        
        return false
    }
}

extension NSAttributedString {
    var containsCheckbox: Bool {
        var containsCheckbox = false
        
        self.enumerateAttribute(.listAttachment, in: maxRange) { attribute, range, pointee in
            if let checkbox = attribute as? String {
                if !containsCheckbox {
                    containsCheckbox = ((checkbox == ListAttachmentType.checkboxChecked.rawValue) || (checkbox == ListAttachmentType.checkboxUnchecked.rawValue))
                }
            }
        }
        return containsCheckbox
    }
}
