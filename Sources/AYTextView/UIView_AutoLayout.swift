//
//  UIView_AutoLayout.swift
//  Home
//
//  Created by Yash Uttekar on 03/01/23.
//

import UIKit

extension UIView {
    func fillInSuperView(inset: UIEdgeInsets = .zero) {
        if let superview = superview {
            translatesAutoresizingMaskIntoConstraints = false
            [
                topAnchor.constraint(equalTo: superview.topAnchor, constant: inset.top),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset.left),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: inset.right),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: inset.bottom)
            ].forEach {
                $0.isActive = true
            }
        }
    }
    
    func anchor(top: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
                leading: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
                trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
                bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                inset: UIEdgeInsets = .zero
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: inset.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: inset.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: inset.right).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: inset.bottom).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerInSuperview(width: CGFloat? = nil, height: CGFloat? = nil, inset: CGPoint = .zero) {
        if let superview = superview {
            translatesAutoresizingMaskIntoConstraints = false

            if let width = width {
                widthAnchor.constraint(equalToConstant: width).isActive = true
            }
            
            if let height = height {
                heightAnchor.constraint(equalToConstant: height).isActive = true
            }
            
            [   centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: inset.x),
                centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: inset.y)
            ].forEach {
                $0.isActive = true
            }
        }
    }
}
