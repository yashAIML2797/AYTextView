//
//  AYTextView_Photos.swift
//  NoteStack
//
//  Created by Yash Uttekar on 09/06/23.
//

import UIKit
import PhotosUI
import QuickLook

extension AYTextView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    func configurePhotos() {
        maintainNewLineForPhotoAttachments()
        removeListAttachmentsAndIndentsForPhotos()
    }
    
    func getAttachmentSize(for imageSize: CGSize) -> CGSize {
        //Configure size maintaining aspect ratio.
        let width = (frame.width * 0.9) - 10
        
        guard imageSize.width > width else {
            return imageSize
        }
        
        let height = (imageSize.height * width) / imageSize.width
        
        return CGSize(width: width, height: height)
    }
    
    func addImageAttachment(image: UIImage) {
        
        let attachmentSize = getAttachmentSize(for: image.size)
        let compressedImage = image.compressImage(to: attachmentSize)
        
        let textAttachment  = NSTextAttachment(image: compressedImage)
        textAttachment.bounds = CGRect(origin: .zero, size: attachmentSize)
        
        let attachmentString = NSMutableAttributedString(attachment: textAttachment)
        attachmentString.addAttributes(typingAttributes, range: attachmentString.maxRange)
        
        textStorage.insert(attachmentString, at: selectedRange.location)
    }

    @objc func showPhotoPickerOptions(button: UIButton) {
        let alert = UIAlertController(
            title: "Pick a Photo",
            message: "Choose a picture from Library or Camera.",
            preferredStyle: .actionSheet
        )
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()

        let cameraAction = UIAlertAction(title: "Take a Photo", style: .default) { action in
            self.showCamera()
        }

        let libraryAction = UIAlertAction(title: "Choose a Photo", style: .default) { action in
            self.showPhotoLibrary()
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancel)
        
        if let rootController = self.window?.rootViewController {
            
            if let controller = alert.popoverPresentationController {
                controller.sourceView = rootController.view
                controller.sourceRect = rootController.view.bounds
                controller.permittedArrowDirections = UIPopoverArrowDirection()
            }
            
            rootController.present(alert, animated: true)
        }
    }

    //MARK: - UIImagePickerController
    func showCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera

        if let rootController = self.window?.rootViewController {
            rootController.present(picker, animated: true)
        }
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.addImageAttachment(image: image)
        self.configure()
        picker.dismiss(animated: true)
    }

    //MARK: - UIImagePickerController
    func showPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen

        if let rootController = self.window?.rootViewController {
            rootController.present(picker, animated: true)
        }
    }

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.addImageAttachment(image: image)
                        self.configure()
                    }
                }
            }
        }

        picker.dismiss(animated: true)
    }
    
    func removeListAttachmentsAndIndentsForPhotos() {
        //Remove lists(bullet) custom attribute and paragraphStyle indents for NSTextAttachment so that image won't go out of textView's frame.
        textStorage.enumerateAttributes(in: textStorage.maxRange) { attributes, range, _ in
            if attributes[.attachment] is NSTextAttachment {
                let paragraphRange = textStorage.mutableString.paragraphRange(for: range)
                if let paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle {
                    let newParagraphStyle = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
                    newParagraphStyle.firstLineHeadIndent = 0
                    newParagraphStyle.headIndent = 0
                    textStorage.addAttribute(.paragraphStyle, value: newParagraphStyle, range: range)
                }
                textStorage.removeAttribute(.listAttachment, range: paragraphRange)
            }
        }
    }
    
    func maintainNewLineForPhotoAttachments() {
        //Maintaining a new line char before and after NSTextAttachments so that they appear as a new paragraph and don't come in line with text.
        textStorage.enumerateAttribute(.attachment, in: textStorage.maxRange) { attribute, range, _ in
            if attribute is NSTextAttachment {
                var plusOne = false
                
                var attributes = textStorage.attributes(at: range.location, effectiveRange: nil)
                attributes.removeValue(forKey: .attachment)
                
                let isNewLineCharBeforeRange = isNewLineCharBeforeRange(range: range)
                let isNewLineCharAfterRange = isNewLineCharAfterRange(range: range)
                let isAttachmentBeforeRange = isAttachmentBeforeRange(range: range)
                let isAttachmentAfterRange = isAttachmentAfterRange(range: range)
                
                if let temp1 = isNewLineCharBeforeRange, let temp2 = isAttachmentBeforeRange, !temp1, !temp2 {
                    let newLine = NSAttributedString(string: "\n", attributes: attributes)
                    textStorage.insert(newLine, at: range.location)
                    plusOne = true
                }
                
                if let temp1 = isNewLineCharAfterRange, let temp2 = isAttachmentAfterRange, !temp1, !temp2 {
                    let newLine = NSAttributedString(string: "\n", attributes: attributes)
                    if plusOne {
                        textStorage.insert(newLine, at: range.upperBound + 1)
                    } else {
                        textStorage.insert(newLine, at: range.upperBound)
                        if range.upperBound == selectedRange.location - 1 {
                            selectedRange = NSRange(location: selectedRange.location + 1, length: 0)
                        }
                    }
                }
            }
        }
    }
    
    func isNewLineCharBeforeRange(range: NSRange) -> Bool? {
        let beforeRange = NSRange(location: range.location - 1, length: 1)
        
        guard beforeRange.isValid(for: textStorage) else {
            return nil
        }
        
        let isAttachment = textStorage.attributedSubstring(from: beforeRange).string == "\n"
        
        return isAttachment
    }
    
    func isNewLineCharAfterRange(range: NSRange) -> Bool? {
        let afterRange = NSRange(location: range.upperBound, length: 1)
        
        guard afterRange.isValid(for: textStorage) else {
            return nil
        }
        
        let isAttachment = textStorage.attributedSubstring(from: afterRange).string == "\n"
        
        return isAttachment
    }
    
    func isAttachmentBeforeRange(range: NSRange) -> Bool? {
        let beforeRange = NSRange(location: range.location - 1, length: 1)
        
        guard beforeRange.isValid(for: textStorage) else {
            return nil
        }
        
        var isAttachment = false
        textStorage.enumerateAttribute(.attachment, in: beforeRange) { attribute, attachmentRange, _ in
            if attribute is NSTextAttachment {
                isAttachment = true
            }
        }
        
        return isAttachment
    }
    
    func isAttachmentAfterRange(range: NSRange) -> Bool? {
        let afterRange = NSRange(location: range.upperBound, length: 1)
        
        guard afterRange.isValid(for: textStorage) else {
            return nil
        }
        
        var isAttachment = false
        textStorage.enumerateAttribute(.attachment, in: afterRange) { attribute, attachmentRange, _ in
            if attribute is NSTextAttachment {
                isAttachment = true
            }
        }
        
        return isAttachment
    }
}
