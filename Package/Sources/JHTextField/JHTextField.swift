//
//  JHTextField_Style.swift
//  JHTextField
//
//  Created by Junhong on 2022/8/23.
//  Copyright © 2022 JHTextField. All rights reserved.
//

import UIKit
import SnapKit

@objc public enum ActionPolicyType: NSInteger {
    case Success
    case Fail
}

@objc public protocol JHTextFieldDelegate: NSObjectProtocol {
    
    /// 在此进行获取验证码操作
    /// - Parameters:
    ///   - textField: 响应对象
    ///   - actionPolicy: 操作策略，如果为true则开始倒计时，time必须大于0
    func didClickGetVerifyCode(_ textField: JHTextField, actionPolicy: ( @escaping (_ action: ActionPolicyType, _ time: Int) -> ()))
    
    /// 在此进行重置获取验证码操作
    /// - Parameters:
    ///   - textField: 响应对象
    ///   - actionProlicy: 操作策略，如果为true则为重置成功，textField会自动进入可获取验证码状态
    func resetVerifyCode(_ textField: JHTextField, actionProlicy: ( @escaping (_ action: ActionPolicyType) -> (Void)))
    
    /// 重置获取验证码完成
    /// - Parameter textField: 响应对象
    func resetVerifyCodeDidFinished(_ textField: JHTextField)
}

@objc public class JHTextField: UIView {
    
    // MARK: - Public
    
    /// 代理
    @objc public var delegate: JHTextFieldDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    /// 间隔
    @objc public var padding: Double {
        get {
            return _padding
        }
        set {
            _padding = newValue
            self.updateConstraints()
        }
    }
    
    /// 左侧未选中图片
    @objc public var leftUnSelectedImage: UIImage? {
        get {
            return self.leftImageView.image
        }
        set {
            self.leftImageView.image = newValue
        }
    }
    
    /// 左侧选中图片
    @objc public var leftSelectedImage: UIImage? {
        get {
            return self.leftImageView.highlightedImage
        }
        set {
            self.leftImageView.highlightedImage = newValue
        }
    }
    
    /// 输入文本字体
    @objc public var font: UIFont? {
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
    @objc public var nextTextField: JHTextField? {
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
    
    /// 占位符
    @objc public var placeholder: String? {
        get {
            return self.textField.placeholder
        }
        set {
            self.textField.placeholder = newValue
        }
    }
    
    /// 清除按钮模式
    @objc public var clearButtonMode: UITextField.ViewMode {
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
    @objc public var isSecureTextEntry: Bool {
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
    @objc public var isAddEyeImage: Bool {
        get {
            return _isAddEyeImage
        }
        set {
            _isAddEyeImage = newValue
            self.updateConstraints()
        }
    }
    
    /// 键盘样式
    @objc public var keyboardType: UIKeyboardType {
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
    @objc public var isVerifyTextField: Bool {
        get {
            return _isVerifyTextField
        }
        set {
            _isVerifyTextField = newValue
            self.updateConstraints()
        }
    }
    
    /// 获取验证码文字
    @objc public var getVerifyCodeText: String {
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
    @objc public var reGetVerifyCodeText: String {
        get {
            return _reGetVerifyText
        }
        set {
            _reGetVerifyText = newValue
            self.updateConstraints()
        }
    }
    
    /// 获取验证码字体
    @objc public var getVerifyCodeFont: UIFont {
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
    @objc public var verifyCodeCountDownFormat: String {
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
    @objc public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    /// 边框颜色
    @objc public var borderColor: CGColor? {
        get {
            return self.layer.borderColor
        }
        set {
            self.layer.borderColor = newValue
        }
    }
    
    /// 圆倒角半径
    @objc public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    /// 重置验证码状态
    /// 必须实现JHTextFieldDelegate.resetVerifyCode方法
    @objc public func resetVerifyCode() {
        guard let delegate = self.delegate else {
            return
        }
        delegate.resetVerifyCode(self) { action in
            switch action {
            case .Success:
                self.cancelTimer(isReset: true)
                self.resetVerifyCodeFinished()
            case .Fail:
                return
            }
        }
    }
    
    /// 更新UI
    public override func updateConstraints() {
        super.updateConstraints()
        self.configUI()
    }
    
    public init() {
        super.init(frame: CGRect())
        self.setParameter()
    }
    
    public override init(frame: CGRect) {
        super .init(frame: frame)
        self.setParameter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    func resetVerifyCodeFinished() {
        guard let delegate = self.delegate,
              delegate.responds(to: NSSelectorFromString("resetVerifyCodeDidFinished:")) == true
        else {
            return
        }
        delegate.resetVerifyCodeDidFinished(self)
    }
    
    @objc func didClickEye() {
        self.eyeImageView.isHighlighted = !self.eyeImageView.isHighlighted
        self.textField.isSecureTextEntry = self.eyeImageView.isHighlighted
    }
    
    @objc func didClickBackground() {
        print("didClickTextFieldBackground")
    }
    
    @objc func didClickGetVerifyCode() {
        guard let delegate = self.delegate else {
            return
        }
        delegate.didClickGetVerifyCode(self) { action, time in
            guard action == .Success, // 行为为true
                  time > 0 // 持续时间不为0
            else {
                return
            }
            // 不可二次点击
            self.getVerifyCodeLabel.isUserInteractionEnabled = false
            // 先清空上一次的倒计时行为
            self.timer?.invalidate()
            self.timer = nil

            // 开始倒计时
            self.time = time
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.time -= 1
                guard self.time > 0 else {
                    self.cancelTimer(isReset: false)
                    return
                }
                self.getVerifyCodeLabel.text = self.verifyCodeCountDownFormat.replacingOccurrences(of: "%d", with: String(self.time))
            }
        }
    }
    
    
    func cancelTimer(isReset: Bool) {
        self.timer?.invalidate()
        self.timer = nil
        self.getVerifyCodeLabel.isUserInteractionEnabled = true
        self.getVerifyCodeLabel.text = isReset ? self.getVerifyCodeText : self.reGetVerifyCodeText
    }
    
    // MARK: - UI
    
    func configUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClickBackground))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
        self.leftImageView.removeFromSuperview()
        self.textField.removeFromSuperview()
        self.getVerifyCodeLabel.removeFromSuperview()
        self.eyeImageView.removeFromSuperview()
        self.addSubview(self.leftImageView)
        self.addSubview(self.textField)
        self.addSubview(self.getVerifyCodeLabel)
        self.addSubview(self.eyeImageView)
        
        self.leftImageView.snp.remakeConstraints { make in
            make.top.equalTo(self).offset(self.padding)
            make.left.equalTo(self).offset(self.padding)
            make.bottom.equalTo(self).offset(-self.padding)
            make.height.equalTo(self.leftImageView.snp.width)
        }
        
        var verifyCodeLabelWidth = 0.0
        if self.isVerifyTextField == true {
            // 设置获取验证码框长度
            // 获取样式、倒计时样式、重新获取样式 三者取最大值
            let text1Width = getTextWidth(self.getVerifyCodeText, font: self.getVerifyCodeFont)
            let text2Width = getTextWidth(self.verifyCodeCountDownFormat, font: self.getVerifyCodeFont)
            let text3Width = getTextWidth(self.reGetVerifyCodeText, font: self.getVerifyCodeFont)
            verifyCodeLabelWidth = Double.maximum(text1Width, text2Width)
            verifyCodeLabelWidth = Double.maximum(verifyCodeLabelWidth, text3Width)
        }
        self.getVerifyCodeLabel.snp.remakeConstraints { make in
            make.top.equalTo(self).offset(self.padding)
            make.right.equalTo(self).offset(-self.padding)
            make.bottom.equalTo(self).offset(-self.padding)
            make.width.equalTo(verifyCodeLabelWidth)
        }
        
        var eyeImageWidth: ConstraintRelatableTarget = 0
        if self.isAddEyeImage == true {
            eyeImageWidth = self.eyeImageView.snp.height
        }
        self.eyeImageView.snp.remakeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self.getVerifyCodeLabel.snp.left).offset(-self.padding/2)
            make.height.equalTo(self).multipliedBy(0.3)
            make.width.equalTo(eyeImageWidth).multipliedBy(5/3.0)
        }
        
        self.textField.snp.remakeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self.leftImageView.snp.right).offset(self.padding)
            make.right.equalTo(self.eyeImageView.snp.left).offset(-self.padding/2)
            make.bottom.equalTo(self)
        }
    }
    
    // MARK: - Lazy load
    
    /// 左侧图片ImageView
    lazy var leftImageView: UIImageView = {
        leftImageView = UIImageView()
        leftImageView.contentMode = .scaleAspectFit
        return leftImageView
    }()
    
    /// 输入框
    lazy var textField: UITextField = {
        textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .default
        return textField
    }()
    
    /// 获取验证码Label
    public lazy var getVerifyCodeLabel: UILabel = {
        getVerifyCodeLabel = UILabel()
        getVerifyCodeLabel.textAlignment = .center
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClickGetVerifyCode))
        getVerifyCodeLabel.isUserInteractionEnabled = true
        getVerifyCodeLabel.addGestureRecognizer(tap)
        return getVerifyCodeLabel
    }()
    
    /// 眼睛ImageView
    lazy var eyeImageView: UIImageView = {
        eyeImageView = UIImageView()
        eyeImageView.image = UIImage(named: "eyes_open")
        eyeImageView.highlightedImage = UIImage(named: "eyes_close")
        eyeImageView.contentMode = .scaleAspectFit
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClickEye))
        eyeImageView.addGestureRecognizer(tap)
        eyeImageView.isUserInteractionEnabled = true
        return eyeImageView
    }()
    
    /// 代理
    var _delegate: JHTextFieldDelegate?
    
    /// 计时器
    var timer: Timer? = Timer()
    
    /// 倒计时时间
    var time: Int = 0
    
    /// 间距
    var _padding: Double = 0
    
    /// 下一个输入框
    var _nextTextField: JHTextField?
    
    /// 判断是否为验证码输入框
    var _isVerifyTextField: Bool = false
    
    /// 获取验证码字符
    var _getVerifyText: String = ""
    
    /// 重新获取验证码字符
    var _reGetVerifyText: String = ""
    
    /// 倒计时格式
    var _verifyCodeCountDownFormat: String = ""
    
    /// 是否显示眼睛👀
    var _isAddEyeImage: Bool = false
    
    /// 获取文本长度
    /// - Parameters:
    ///   - str: 文本
    ///   - font: 字体
    /// - Returns: 文本长度
    func getTextWidth(_ str: String?, font: UIFont) ->CGFloat {
        let size = CGSize(width: 20000, height: 100)
        let attributes = [NSAttributedString.Key.font: font]
        let labelSize: CGRect = NSString(string: str ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return labelSize.width + 1
    }
    
    func setParameter() {
        self.padding = JHTextField.padding
        self.borderColor = JHTextField.borderColor
        self.cornerRadius = JHTextField.cornerRadius
        self.borderWidth = JHTextField.borderWidth
        self.textField.clearButtonMode = JHTextField.clearButtonMode
        self.getVerifyCodeFont = JHTextField.getVerifyCodeFont
        self.leftSelectedImage = JHTextField.leftSelectedImage
        self.leftUnSelectedImage = JHTextField.leftUnSelectedImage
        self.getVerifyCodeText = JHTextField.getVerifyCodeText
        self.reGetVerifyCodeText = JHTextField.reGetVerifyCodeText
        self.verifyCodeCountDownFormat = JHTextField.verifyCodeCountDownFormat
        self.isVerifyTextField = false
        self.isAddEyeImage = false
        self.isSecureTextEntry = false
        self.nextTextField = nil
    }
    
    // MARK: - Init
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
}
