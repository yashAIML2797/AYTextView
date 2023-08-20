//
//  AYTextView_Caret.swift
//  AYTextView
//
//  Created by Yash Uttekar on 18/08/23.
//

import UIKit

extension AYTextView {
    public override func caretRect(for position: UITextPosition) -> CGRect {
        let superRect = super.caretRect(for: position)
        
        guard let font = typingAttributes[.font] as? UIFont else {
            return superRect
        }
        
        guard textStorage.length != selectedRange.upperBound else {
            return superRect
        }
        
        if let temp = isAttachmentBeforeRange(range: selectedRange), temp == true {
            return superRect
        }
        
        var largerFontSize = CGFloat.zero
        let usedRect = layoutManager.lineFragmentUsedRect(forGlyphAt: selectedRange.location, effectiveRange: nil)
        let glyphRange = layoutManager.glyphRange(forBoundingRect: usedRect, in: textContainer)
        
        textStorage.enumerateAttribute(.font, in: glyphRange) { attribute, range, _ in
            if let font = attribute as? UIFont {
                largerFontSize = max(largerFontSize, font.pointSize)
            }
        }
        
        let y = superRect.origin.y + (largerFontSize > font.pointSize ? largerFontSize - font.pointSize : .zero)
        //Subtracting the difference between two differnt font sizes if there are any on the same line.
        //This helps to get y coordinate relative current character in the paragraph when the lineFragmentRect increases due to any large font.

        
        let rect = CGRect(
            origin: CGPoint(x: superRect.origin.x, y: y),
            size: CGSize(width: superRect.width, height: font.lineHeight)
        )
        
        return rect
    }
}
