//
//  JHTextField_UITextFieldDelegate.swift
//  JHTextField
//
//  Created by Junhong on 2022/8/23.
//  Copyright © 2022 JHTextField. All rights reserved.
//

import UIKit

@objc extension JHTextField: UITextFieldDelegate {
    
    /// 成为第一响应者
    public override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    /// 移除第一响应者身份
    public override func resignFirstResponder() -> Bool {
        return self.textField.resignFirstResponder()
    }
    
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
