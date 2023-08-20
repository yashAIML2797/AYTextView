//
//  UIImage_Ext.swift
//  NoteStack
//
//  Created by Yash Uttekar on 09/06/23.
//

import UIKit
import AVFoundation

extension UIImage {
    func compressImage(to maxSize: CGSize) -> UIImage {
        
        let availableRect = AVFoundation.AVMakeRect(aspectRatio: self.size, insideRect: .init(origin: .zero, size: maxSize))
        let targetSize = availableRect.size
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        
        let resized = renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return resized
    }
}
