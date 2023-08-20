//
//  Ext_UIFont.swift
//  TextEditor2.0
//
//  Created by Yash Uttekar on 15/03/22.
//  Reference - https://stackoverflow.com/questions/34499735/how-to-apply-bold-and-italics-to-an-nsmutableattributedstring-range

import Foundation
import UIKit

extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        //create a new font descriptor with given traits
        guard let fd = fontDescriptor.withSymbolicTraits(traits) else {
            //the given traits couldn't be applied, return self
            return self
        }
        
        return UIFont(descriptor: fd, size: pointSize)
    }
    
    func italics() -> UIFont {
        return withTraits(.traitItalic)
    }
    
    func bold() -> UIFont {
        return withTraits(.traitBold)
    }
    
    func boldItalics() -> UIFont {
        return withTraits([.traitBold, .traitItalic])
    }
    
    var isBold: Bool {
        self.fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        self.fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    func ofSize(size: CGFloat) -> UIFont {
        return UIFont(descriptor: self.fontDescriptor, size: size)
    }
}
