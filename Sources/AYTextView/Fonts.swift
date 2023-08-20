//
//  Fonts.swift
//  AYTextView
//
//  Created by Yash Uttekar on 06/07/23.
//

import UIKit

class Fonts {
    static let shared = Fonts()
    
    private init() {}
    
    var sfRounded: UIFont {
        let font = UIFont.systemFont(ofSize: 19)
        
        guard let descriptor = font.fontDescriptor.withDesign(.rounded) else {
            return font
        }

        return UIFont(descriptor: descriptor, size: font.pointSize)
    }
    
    var serif: UIFont {
        let font = UIFont.systemFont(ofSize: 19)
        
        guard let descriptor = font.fontDescriptor.withDesign(.serif) else {
            return font
        }

        return UIFont(descriptor: descriptor, size: font.pointSize)
    }
}
