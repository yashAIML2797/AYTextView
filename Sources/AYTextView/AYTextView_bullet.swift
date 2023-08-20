//
//  AYTextView_bullet.swift
//  TextEditor
//
//  Created by Yash Uttekar on 02/06/22.
//

import Foundation
import UIKit

extension AYTextView {
    func handleBullets() {
        maintainListNewLineChar()
        if paragraphString.containsBullet {
            textStorage.enumerateAttribute(.listAttachment, in: paragraphRange) { attribute, range, _ in
                if let listAttachment = attribute as? String,
                   listAttachment == ListAttachmentType.bullet.rawValue {
                    removeListAttachment(in: range)
                }
            }
        } else {
            addListAttachment(of: .bullet, in: paragraphRange)
        }
    }
}

extension NSAttributedString {
    var containsBullet: Bool {
        var containsBullet = false
        
        self.enumerateAttribute(.listAttachment, in: maxRange) { attribute, range, pointee in
            if let bullet = attribute as? String {
                if !containsBullet {
                    containsBullet = bullet == ListAttachmentType.bullet.rawValue
                }
            }
        }
        
        return containsBullet
    }
}
