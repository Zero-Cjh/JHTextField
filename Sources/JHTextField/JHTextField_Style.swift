//
//  JHTextField_Style.swift
//  JHTextField
//
//  Created by Junhong on 2022/8/23.
//  Copyright © 2022 JHTextField. All rights reserved.
//

import Foundation
import UIKit

extension JHTextField {
    
    /// 代理
    public var delegate: JHTextFieldDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    /// 间隔
    public var padding: Double {
        get {
            return _padding
        }
        set {
            _padding = newValue
            self.updateConstraints()
        }
    }
    
    /// 左侧未选中图片
    public var leftUnSelectedImage: UIImage? {
        get {
            return self.leftImageView.image
        }
        set {
            self.leftImageView.image = newValue
        }
    }
    
    /// 左侧选中图片
    public var leftSelectedImage: UIImage? {
        get {
            return self.leftImageView.highlightedImage
        }
        set {
            self.leftImageView.highlightedImage = newValue
        }
    }
    
    /// 输入文本字体
    public var font: UIFont? {
        get {
            return self.textField.font
        }
        set {
            self.textField.font = newValue
        }
    }
    
    /// 下一个输入框
    ///
    /// Default: nil
    public var nextTextField: JHTextField? {
        get {
            return _nextTextField
        }
        set {
            _nextTextField = newValue
            if newValue != nil {
                self.textField.returnKeyType = .next
            } else {
                self.textField.returnKeyType = .done
            }
        }
    }
    
    /// 展位符
    public var placeholder: String? {
        get {
            return self.textField.placeholder
        }
        set {
            self.textField.placeholder = newValue
        }
    }
    
    /// 清除按钮模式
    public var clearButtonMode: UITextField.ViewMode {
        get {
            return self.textField.clearButtonMode
        }
        set {
            self.textField.clearButtonMode = newValue
        }
    }
    
    /// 是否设置为安全文本
    ///
    /// Default: false
    public var isSecureTextEntry: Bool {
        get {
            return self.textField.isSecureTextEntry
        }
        set {
            self.textField.isSecureTextEntry = newValue
            self.eyeImageView.isHighlighted = newValue
        }
    }
    
    /// 是否显示眼睛👀
    ///
    /// Default: false
    public var isAddEyeImage: Bool {
        get {
            return _isAddEyeImage
        }
        set {
            _isAddEyeImage = newValue
            self.updateConstraints()
        }
    }
    
    /// 键盘样式
    public var keyboardType: UIKeyboardType {
        get {
            return self.textField.keyboardType
        }
        set {
            self.textField.keyboardType = newValue
        }
    }
    
    /// 是否为验证码输入框
    ///
    /// Default: false
    public var isVerifyTextField: Bool {
        get {
            return _isVerifyTextField
        }
        set {
            _isVerifyTextField = newValue
            self.updateConstraints()
        }
    }
    
    /// 获取验证码文字
    public var getVerifyCodeText: String {
        get {
            return _getVerifyText
        }
        set {
            _getVerifyText = newValue
            self.timer?.invalidate()
            self.timer = nil
            self.getVerifyCodeLabel.text = newValue
            self.updateConstraints()
        }
    }
    
    /// 重发字样
    public var reGetVerifyCodeText: String {
        get {
            return _reGetVerifyText
        }
        set {
            _reGetVerifyText = newValue
            self.updateConstraints()
        }
    }
    
    /// 获取验证码字体
    public var getVerifyCodeFont: UIFont {
        get {
            return self.getVerifyCodeLabel.font
        }
        set {
            self.getVerifyCodeLabel.font = newValue
            self.updateConstraints()
        }
    }
    
    /// 倒计时样式
    ///
    /// 例如: "%d秒后重发"
    public var verifyCodeCountDownFormat: String {
        get {
            return _verifyCodeCountDownFormat
        }
        set {
            guard newValue.contains("%d") else {
                print("verifyCodeDownFormat格式错误")
                return
            }
            _verifyCodeCountDownFormat = newValue
            self.updateConstraints()
        }
    }
    
    /// 边框宽度
    public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    /// 边框颜色
    public var borderColor: CGColor? {
        get {
            return self.layer.borderColor
        }
        set {
            self.layer.borderColor = newValue
        }
    }
    
    /// 圆倒角半径
    public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
