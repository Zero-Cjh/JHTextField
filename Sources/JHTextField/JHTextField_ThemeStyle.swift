//
//  JHTextField_ThemeStyle.swift
//  JHTextField
//
//  Created by Junhong on 2022/8/23.
//  Copyright © 2022 JHTextField. All rights reserved.
//

import Foundation
import UIKit

@objc public extension JHTextField {
    
    /// 全局间隔
    ///
    /// Default: 10
    static var padding: Double {
        get {
            return JHTextField_Padding
        }
        set {
            JHTextField_Padding = newValue
        }
    }
    
    /// 左侧Icon大小
    ///
    /// Deafult: 25, 25
    static var leftImageSize: CGSize {
        get {
            return JHTextField_LeftImageSize
        }
        set {
            JHTextField_LeftImageSize = newValue
        }
    }
    
    /// 全局左侧未选中图片
    ///
    /// Default: pencil
    static var leftUnSelectedImage: UIImage? {
        get {
            return JHTextField_LeftUnSelectedImage
        }
        set {
            JHTextField_LeftUnSelectedImage = newValue
        }
    }
    
    /// 全局左侧选中图片
    ///
    /// Default: pencil.fill
    static var leftSelectedImage: UIImage? {
        get {
            return JHTextField_LeftSelectedImage
        }
        set {
            JHTextField_LeftSelectedImage = newValue
        }
    }
    
    /// 全局输入文本字体
    ///
    /// Default: system
    static var font: UIFont? {
        get {
            return JHTextField_Font
        }
        set {
            JHTextField_Font = newValue
        }
    }
    
    /// 全局占位符
    ///
    /// Default: nil
    static var placeholder: String? {
        get {
            return JHTextField_Placeholder
        }
        set {
            JHTextField_Placeholder = newValue
        }
    }
    
    /// 全局清除按钮模式
    ///
    /// Default: whileEditing
    static var clearButtonMode: UITextField.ViewMode {
        get {
            return JHTextField_ClearButtonMode
        }
        set {
            JHTextField_ClearButtonMode = newValue
        }
    }
    
    /// 全局键盘样式
    ///
    /// Default: .default
    static var keyboardType: UIKeyboardType {
        get {
            return JHTextField_KeyBoardType
        }
        set {
            JHTextField_KeyBoardType = newValue
        }
    }
    
    /// 全局获取验证码文字
    ///
    /// Default: 获取验证码
    static var getVerifyCodeText: String {
        get {
            return JHTextField_GetVerifyCodeText
        }
        set {
            JHTextField_GetVerifyCodeText = newValue
        }
    }
    
    /// 全局重发字样
    ///
    /// Default: 重新获取验证码
    static var reGetVerifyCodeText: String {
        get {
            return JHTextField_ReGetVerifyCodeText
        }
        set {
            JHTextField_ReGetVerifyCodeText = newValue
        }
    }
    
    /// 全局获取验证码字体
    ///
    /// Default:
    ///     ofSize: 14
    ///     weight: .regular
    static var getVerifyCodeFont: UIFont {
        get {
            return JHTextField_GetVerifyCodeFont
        }
        set {
            JHTextField_GetVerifyCodeFont = newValue
        }
    }
    
    /// 全局倒计时样式
    ///
    /// %d为时间
    /// 例如: "%d秒后重发
    static var verifyCodeCountDownFormat: String {
        get {
            return JHTextField_VerifyCodeCountDownFormat
        }
        set {
            JHTextField_VerifyCodeCountDownFormat = newValue
        }
    }
    
    /// 全局边框宽度
    ///
    /// Default: 1
    static var borderWidth: CGFloat {
        get {
            return JHTextField_BorderWidth
        }
        set {
            JHTextField_BorderWidth = newValue
        }
    }
    
    /// 全局边框颜色
    ///
    /// Default: UIColor.black.cgColor
    static var borderColor: CGColor {
        get {
            return JHTextField_borderColor
        }
        set {
            JHTextField_borderColor = newValue
        }
    }
    
    /// 全局圆倒角半径
    ///
    /// Default: 5
    static var cornerRadius: CGFloat {
        get {
            return JHTextField_CornerRadius
        }
        set {
            JHTextField_CornerRadius = newValue
        }
    }
    
    /// 文本长度限制
    ///
    /// Deafult: 0
    static var maxCount: Int {
        get {
            return JHTextField_MaxCount
        }
        set {
            JHTextField_MaxCount = newValue
        }
    }
}

private var JHTextField_LeftImageSize = CGSize(width: 25, height: 25)
private var JHTextField_Padding: Double = 10
private var JHTextField_LeftUnSelectedImage: UIImage? = .init(systemName: "pencil.circle")
private var JHTextField_LeftSelectedImage: UIImage? = .init(systemName: "pencil.circle.fill")
private var JHTextField_Font: UIFont?
private var JHTextField_Placeholder: String?
private var JHTextField_ClearButtonMode: UITextField.ViewMode = .whileEditing
private var JHTextField_KeyBoardType: UIKeyboardType = .default
private var JHTextField_GetVerifyCodeText: String = "获取验证码"
private var JHTextField_ReGetVerifyCodeText: String = "重新获取验证码"
private var JHTextField_VerifyCodeCountDownFormat: String = "%ds"
private var JHTextField_GetVerifyCodeFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
private var JHTextField_BorderWidth: CGFloat = 1
private var JHTextField_borderColor: CGColor = UIColor.black.cgColor
private var JHTextField_CornerRadius: CGFloat = 5
private var JHTextField_MaxCount: Int = 0
