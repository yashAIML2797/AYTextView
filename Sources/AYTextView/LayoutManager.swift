//
//  LayoutManager.swift
//  TextEditor
//
//  Created by Yash Uttekar on 02/08/22.
//

import SwiftUI

class LayoutManager: NSLayoutManager {
    var indentNumbers: [CGFloat: Int] = [:] //To keep track of numbers for each indent value
    
    public override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
        
        guard let textStorage = textStorage else {
            return
        }
        
        let paragraphRanges = textStorage.paragraphRanges
        
        indentNumbers = [:]
        var n = 1
        
        let context = UIGraphicsGetCurrentContext()!
        
        for paragraphRange in paragraphRanges {
            let paragraphString = textStorage.attributedSubstring(from: paragraphRange)
            
            paragraphString.enumerateAttributes(in: NSRange(location: 0, length: 1)) { attributes, range, _ in
                
                guard let paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle else {
                    return
                }
                
                guard let font = attributes[.font] as? UIFont else {
                    return
                }
                
                if let attachment = attributes[.listAttachment] as? String {
                    
                    let listAttachment = self.createListAttachment(
                        listAttachmentType: ListAttachmentType(rawValue: attachment),
                        attributes: attributes,
                        currentNumber: &n
                    )
                    
                    let usedRect = lineFragmentUsedRect(forGlyphAt: paragraphRange.location, effectiveRange: nil)
                    let glyphRange = glyphRange(forBoundingRect: usedRect, in: textContainers.first!)
                    
                    var largerFontSize = CGFloat.zero
                    textStorage.enumerateAttribute(.font, in: glyphRange) { attribute, range, _ in
                        if let font = attribute as? UIFont {
                            largerFontSize = max(largerFontSize, font.pointSize)
                        }
                    }
                    
                    let size: CGSize = textContainers.first?.size ?? .zero
                    var x = (paragraphStyle.firstLineHeadIndent - (AYTextView.Constants.minIndent - 10)) + (size.width * 0.05)
                    let y = usedRect.origin.y + 20 + (largerFontSize > font.pointSize ? largerFontSize - font.pointSize : .zero)
                    //20 is the textView's textContainer top inset.
                    //Also subtracting the difference between two differnt font sizes if there are any on the same line.
                    //This helps to get y coordinate relative to first character in the paragraph when the lineFragmentRect increases due to any large font.
                    
                    if let stringToDraw = listAttachment {
                        
                        x -= stringToDraw.size().width
                        x += ((AYTextView.Constants.minIndent / 2) - stringToDraw.size().width)
                        
                        let listAttachmentRect = CGRect(
                            origin: CGPoint(x: x, y: y),
                            size: stringToDraw.size()
                        )
                        
                        stringToDraw.draw(in: listAttachmentRect)
                    }
                    
                    if ListAttachmentType(rawValue: attachment) == .checkboxUnchecked ||
                        ListAttachmentType(rawValue: attachment) == .checkboxChecked {
                        let isChecked = ListAttachmentType(rawValue: attachment) == .checkboxChecked
                        let checkboxRect = CGRect(x: x, y: y, width: font.lineHeight, height: font.lineHeight)
                        drawCheckbox(ctx: context, paragraphStyle: paragraphStyle, isChecked: isChecked, rect: checkboxRect)
                    }
                    
                } else {
                    indentNumbers[paragraphStyle.firstLineHeadIndent] = 1
                }
            }
        }
    }
    
    func createListAttachment(
        listAttachmentType: ListAttachmentType?,
        attributes: [NSAttributedString.Key: Any],
        currentNumber: inout Int
    ) -> NSAttributedString? {
        
        guard let paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle else {
            return NSAttributedString(string: "")
        }
        
        var attachmentString = ""
        let paragraphIndent = paragraphStyle.firstLineHeadIndent
        
        switch listAttachmentType {
        case .number:
            currentNumber = indentNumbers[paragraphIndent] ?? 1 //Pick current running numnber
            indentNumbers[paragraphIndent] = currentNumber + 1 //Update current running number
            
            //If an indent is larger than previous indents, reset current running number of previous indents to one
            for indent in indentNumbers.keys {
                if indent > paragraphIndent {
                    indentNumbers[indent] = 1
                }
            }
            
            attachmentString = "\(currentNumber)."
        case .bullet:
            indentNumbers[paragraphIndent] = 1
            attachmentString = "•"
        default:
            //If line does not contain a number text attachment reset current running number for that particular indent to one
            indentNumbers[paragraphIndent] = 1
            return nil
        }
        
        let attachment = NSMutableAttributedString(string: attachmentString)
        attachment.addAttributes(attributes, range: attachment.maxRange)
        attachment.removeAttribute(.strikethroughStyle, range: attachment.maxRange)
        attachment.removeAttribute(.underlineStyle, range: attachment.maxRange)
        
        return attachment
    }
    
    func drawCheckbox(ctx: CGContext, paragraphStyle: NSParagraphStyle, isChecked: Bool = false, rect: CGRect) {
        ctx.saveGState()
        
        if isChecked {
            if let image = UIImage(named: "Checkmark") {
                image.draw(in: rect)
            }
        } else {
            let pathRect = rect.insetBy(dx: 0.5, dy: 0.5)
            let path = UIBezierPath(roundedRect: pathRect, cornerRadius: rect.width / 2)
            Colors.shared.tint.setStroke()
            path.lineWidth = 1
            path.stroke()
        }
        
        ctx.restoreGState()
    }
}
