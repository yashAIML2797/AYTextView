//
//  AYTextView_InputAccessoryView.swift
//  AYTextView
//
//  Created by Yash Uttekar on 06/07/23.
//

import UIKit

class AccessoryView: UIView {
    
    weak var textView: AYTextView?
    
    let seperatorTop: UIView = {
        UIView()
    }()
    
    let seperatorBottom: UIView = {
        UIView()
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let bullet: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        return button
    }()
    
    let number: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "list.number"), for: .normal)
        return button
    }()
    
    let checkbox: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checklist"), for: .normal)
        return button
    }()
    
    let indentLeft: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "lessthan"), for: .normal)
        return button
    }()
    
    let indentRight: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        return button
    }()
    
    let camera: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        return button
    }()
    
    let bold: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bold"), for: .normal)
        return button
    }()
    
    let underline: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "underline"), for: .normal)
        return button
    }()
    
    let strikethrough: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "strikethrough"), for: .normal)
        return button
    }()
    
    let fontSizeSmaller: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "textformat.size.smaller"), for: .normal)
        return button
    }()
    
    let fontSizeLarger: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "textformat.size.larger"), for: .normal)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize.height = frame.height
        scrollView.contentSize.width = Constants.iconWidth * 11
        
        if let textView = textView {
            if textView.frame.width != seperatorTop.frame.width {
                seperatorTop.removeFromSuperview()
                seperatorTop.frame = CGRect(x: 0, y: 0, width: textView.frame.width, height: 1)
                addSubview(seperatorTop)
            }
        }
        
        if let textView = textView {
            if textView.frame.width != seperatorBottom.frame.width {
                seperatorBottom.removeFromSuperview()
                seperatorBottom.frame = CGRect(x: 0, y: 49, width: textView.frame.width, height: 1)
                addSubview(seperatorBottom)
            }
        }
        
        if let textView = textView {
            if textView.frame.width != scrollView.frame.width {
                scrollView.removeFromSuperview()
                scrollView.frame = CGRect(x: 0, y: 0, width: textView.frame.width, height: frame.height)
                addSubview(scrollView)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: frame.origin, size: .init(width: frame.width, height: Constants.height)))
        
        backgroundColor = Colors.shared.background
        tintColor = Colors.shared.tint
        
        scrollView.addSubview(bullet)
        bullet.anchor(
            leading:    scrollView.leadingAnchor,
            width: Constants.iconWidth,
            height: Constants.height
        )
        bullet.addTarget(self, action: #selector(handleBullets), for: .touchUpInside)
        
        scrollView.addSubview(number)
        number.anchor(
            leading:    bullet.trailingAnchor,
            width: Constants.iconWidth,
            height: Constants.height
        )
        number.addTarget(self, action: #selector(handleNumbers), for: .touchUpInside)
        
        scrollView.addSubview(checkbox)
        checkbox.anchor(
            leading:    number.trailingAnchor,
            width: Constants.iconWidth,
            height: Constants.height
        )
        checkbox.addTarget(self, action: #selector(handleCheckbox), for: .touchUpInside)
        
        scrollView.addSubview(indentLeft)
        indentLeft.anchor(
            leading:    checkbox.trailingAnchor,
            width: Constants.iconWidth,
            height: Constants.height
        )
        indentLeft.addTarget(self, action: #selector(handleIndentLeft), for: .touchUpInside)
        
        scrollView.addSubview(indentRight)
        indentRight.anchor(
            leading:    indentLeft.trailingAnchor,
            width: Constants.iconWidth,
            height: Constants.height
        )
        indentRight.addTarget(self, action: #selector(handleIndentRight), for: .touchUpInside)
        
        scrollView.addSubview(camera)
        camera.anchor(
            leading:    indentRight.trailingAnchor,
            width: Constants.iconWidth,
            height: Constants.height
        )
        
        scrollView.addSubview(bold)
        bold.anchor(
            leading:    camera.trailingAnchor,
            width: Constants.iconWidth,
            height: Constants.height
        )
        bold.addTarget(self, action: #selector(handleBold), for: .touchUpInside)
        
        scrollView.addSubview(underline)
        underline.anchor(
            leading:    bold.trailingAnchor,
            width: Constants.iconWidth,
            height: Constants.height
        )
        underline.addTarget(self, action: #selector(handleUnderline), for: .touchUpInside)
        
        scrollView.addSubview(strikethrough)
        strikethrough.anchor(
            leading:    underline.trailingAnchor,
            width: Constants.iconWidth,
            height: Constants.height
        )
        strikethrough.addTarget(self, action: #selector(handleStrikethrough), for: .touchUpInside)
        
        scrollView.addSubview(fontSizeSmaller)
        fontSizeSmaller.anchor(
            leading:    strikethrough.trailingAnchor,
            width: Constants.iconWidth,
            height: Constants.height
        )
        fontSizeSmaller.addTarget(self, action: #selector(handleFontSizeSmaller), for: .touchUpInside)
        
        scrollView.addSubview(fontSizeLarger)
        fontSizeLarger.anchor(
            leading:    fontSizeSmaller.trailingAnchor,
            width: Constants.iconWidth,
            height: Constants.height
        )
        fontSizeLarger.addTarget(self, action: #selector(handleFontSizeLarger), for: .touchUpInside)
        
        seperatorTop.backgroundColor = .lightGray
        seperatorBottom.backgroundColor = .lightGray
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleBullets(button: UIButton) {
        guard let textView = textView else {
            return
        }
        
        textView.handleBullets()
        triggerHaptic()
    }
    
    @objc func handleNumbers(button: UIButton) {
        guard let textView = textView else {
            return
        }
        
        textView.handleNumbers()
        triggerHaptic()
    }
    
    @objc func handleCheckbox(button: UIButton) {
        guard let textView = textView else {
            return
        }
        
        textView.handleCheckbox()
        triggerHaptic()
    }
    
    @objc func handleIndentLeft(button: UIButton) {
        guard let textView = textView else {
            return
        }
        
        textView.indentLeft()
        triggerHaptic()
    }
    
    @objc func handleIndentRight(button: UIButton) {
        guard let textView = textView else {
            return
        }
        
        textView.indentRight()
        triggerHaptic()
    }
    
    @objc func handleBold(button: UIButton) {
        guard let textView = textView else {
            return
        }
        
        textView.bold()
        triggerHaptic()
    }
    
    @objc func handleUnderline(button: UIButton) {
        guard let textView = textView else {
            return
        }
        
        textView.underline()
        triggerHaptic()
    }
    
    @objc func handleStrikethrough(button: UIButton) {
        guard let textView = textView else {
            return
        }
        
        textView.strikethrough()
        triggerHaptic()
    }
    
    @objc func handleFontSizeSmaller(button: UIButton) {
        guard let textView = textView else {
            return
        }
        
        textView.reduceFontSize()
        triggerHaptic()
    }
    
    @objc func handleFontSizeLarger(button: UIButton) {
        guard let textView = textView else {
            return
        }
        
        textView.increaseFontSize()
        triggerHaptic()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let transform = CGAffineTransform(translationX: scrollView.contentOffset.x, y: .zero)
        seperatorTop.transform = transform
        seperatorBottom.transform = transform
    }
    
    struct Constants {
        static let height: CGFloat = 50
        static let iconWidth: CGFloat = 55
    }
    
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
}

extension AYTextView {
    func setUpInputAccessoryView() {
        let view = AccessoryView()
        view.textView = self
        inputAccessoryView = view
        view.camera.addTarget(self, action: #selector(showPhotoPickerOptions), for: .touchUpInside)
    }
}
