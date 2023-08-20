//
//  Ext_NSAttributedString.swift
//  TextEditor
//
//  Created by Yash Uttekar on 03/06/22.
//

import UIKit

extension NSAttributedString {
    var maxRange: NSRange {
        NSRange(location: 0, length: length)
    }
}

extension NSAttributedString {
    var paragraphRanges: [NSRange] {
        
        var ranges = [NSRange]()
        let mutableAttributedText = self.mutableCopy() as! NSMutableAttributedString
        
        string.enumerateSubstrings(in: string.startIndex..., options: .byParagraphs) { substring, substringRange, enclosingRange, _ in
            let index = substringRange.lowerBound.utf16Offset(in: self.string)
            let paragraphRange = mutableAttributedText.mutableString.paragraphRange(for: NSRange(location: index, length: 0))
            ranges.append(paragraphRange)
        }
        
        return ranges
    }
    
    var paragraphs: [NSAttributedString] {
        var paragraphs: [NSAttributedString] = []
        for range in paragraphRanges {
            paragraphs.append(self.attributedSubstring(from: range))
        }
        return paragraphs
    }
}

extension NSAttributedString.Key {
    static let listAttachment: NSAttributedString.Key = .init("listAttachment")
}

extension NSAttributedString {
    var listAttachmentType: ListAttachmentType? {
        var listAttachmentType: ListAttachmentType? = nil
        
        self.enumerateAttribute(.listAttachment, in: maxRange) { attribute, range, pointee in
            if let type = attribute as? String {
                listAttachmentType = ListAttachmentType(rawValue: type)
            }
        }
        
        return listAttachmentType
    }
    
    var containListAttachments: Bool {
        if let _ = self.listAttachmentType {
            return true
        }
        
        return false
    }
}
