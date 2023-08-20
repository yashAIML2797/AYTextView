//
//  AYTextView.swift
//  AYTextView
//
//  Created by Yash Uttekar on 06/07/23.
//

import UIKit

public class AYTextView: UITextView {
    var listAttachmentType: ListAttachmentType? = nil
    var shouldRemoveListAttachment = false
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        let textStorage = NSTextStorage()
        let layoutManager = LayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let tc = NSTextContainer(size: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude))
        layoutManager.addTextContainer(tc)
        super.init(frame: frame, textContainer: tc)
        
        setUpTextView()
        loadSampleText()
        setUpInputAccessoryView()
        addTapGestureForCheckbox()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = UIEdgeInsets(
            top: 20,
            left: frame.width * 0.05,
            bottom: frame.height * 0.5,
            right: frame.width * 0.05
        )
    }
    
    func setUpTextView() {
        delegate = self
        alwaysBounceVertical = true
        keyboardDismissMode = .interactiveWithAccessory
        backgroundColor = Colors.shared.background
        tintColor = Colors.shared.tint
    }
    
    func loadSampleText() {
        let font = Fonts.shared.sfRounded
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = font.pointSize * 0.15
        paragraphStyle.paragraphSpacing = font.pointSize * 0.5
        
        let color = Colors.shared.text
        
        typingAttributes = [
            .font: font,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: color
        ]
        
        let string = "Hello World!"
        
        let attributedString = NSMutableAttributedString(
            string: string,
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: color
            ]
        )
        
        attributedText = attributedString
        self.maintainListNewLineChar()
        self.configure()
    }
    
    func configure() {
        configurePhotos()
    }
    
    struct Constants {
        static let minIndent: CGFloat = 40
        static let maxIndent: CGFloat = 240
        
        static let minFontSize: CGFloat = 19
        static let maxFontSize: CGFloat = 33
        
        static let listIndentSize: CGFloat = 40
    }
}
