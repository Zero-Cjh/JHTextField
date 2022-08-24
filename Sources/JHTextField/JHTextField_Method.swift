//
//  JHTextField_Method.swift
//  JHTextField
//
//  Created by Junhong on 2022/8/23.
//  Copyright © 2022 JHTextField. All rights reserved.
//

import UIKit

public protocol JHTextFieldDelegate {
    
    /// 在此进行获取验证码操作
    /// - Parameters:
    ///   - textField: 响应对象
    ///   - ActionPolicy: 操作策略，如果为true则开始倒计时，time必须大于0
    func didClickGetVerifyCode(_ textField: JHTextField, actionPolicy: ((_ action: Bool, _ time: Int?) -> ()))
    
    /// 在此进行重置获取验证码操作
    /// - Parameters:
    ///   - textField: 响应对象
    ///   - actionProlicy: 操作策略，如果为true则为重置成功，textField会自动进入可获取验证码状态
    func resetVerifyCode(_ textField: JHTextField, actionProlicy: ((_ action: Bool) -> ()))
}

extension JHTextField: UITextFieldDelegate {
    
    /// 重置验证码状态
    public func resetVerifyCode() {
        guard let delegate = self.delegate else {
            self.cancelTimer(isReset: true)
            return
        }
        delegate.resetVerifyCode(self) { action in
            guard action == true else {
                return
            }
            self.cancelTimer(isReset: true)
        }
    }
    
    /// 更新UI
    public override func updateConstraints() {
        super.updateConstraints()
        self.configUI()
    }
    
    /// 成为第一响应者
    public override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    /// 移除第一响应者身份
    public override func resignFirstResponder() -> Bool {
        return self.textField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    /// 即将开始编辑
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.leftImageView.isHighlighted = true
        return true
    }
    
    /// 即将编辑完成
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.leftImageView.isHighlighted = false
        return true
    }
    
    /// 将要执行返回动作
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.nextTextField {
            return nextTextField.becomeFirstResponder()
        } else {
            return textField.resignFirstResponder()
        }
    }
    
}
