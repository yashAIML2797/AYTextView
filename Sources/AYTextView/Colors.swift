//
//  Colors.swift
//  AYTextView
//
//  Created by Yash Uttekar on 18/08/23.
//

import UIKit

class Colors {
    static let shared = Colors()
    
    private init() {}
    
    var text: UIColor {
        UIColor(named: "Text") ?? .darkGray
    }
    
    var tint: UIColor {
        UIColor(named: "Tint") ?? .gray
    }
    
    var background: UIColor {
        UIColor(named: "Background") ?? .white
    }
}
