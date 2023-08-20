//
//  AYTextView_number.swift
//  TextEditor
//
//  Created by Yash Uttekar on 06/06/22.
//

import UIKit

extension AYTextView {
    func handleNumbers() {
        maintainListNewLineChar()
        if paragraphString.containsNumber {
            textStorage.enumerateAttribute(.listAttachment, in: paragraphRange) { attribute, range, _ in
                if let listAttachment = attribute as? String,
                   listAttachment == ListAttachmentType.number.rawValue {
                    removeListAttachment(in: range)
                }
            }
        } else {
            addListAttachment(of: .number, in: paragraphRange)
        }
    }
}

extension NSAttributedString {
    var containsNumber: Bool {
        var containsNumber = false
        
        self.enumerateAttribute(.listAttachment, in: maxRange) { attribute, range, pointee in
            if let number = attribute as? String {
                if !containsNumber {
                    containsNumber = number == ListAttachmentType.number.rawValue
                }
            }
        }
        return containsNumber
    }
}
