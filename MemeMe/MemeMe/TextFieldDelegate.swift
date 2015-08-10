//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Jakub on 03.08.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var textField: UITextField
    var type: String
    var defaultText: String
    var isActive: Bool
    
    init(textFieldType: String, textField: UITextField) {
        self.isActive = false;
        
        self.textField = textField;
        
        self.type = (textFieldType == "top") ? "top" : "bottom"
        
        self.defaultText = (self.type == "top") ? "TOP" : "BOTTOM"
        
        
        let textAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1.0
        ]
        
        self.textField.defaultTextAttributes = textAttributes
        
        self.textField.textAlignment = NSTextAlignment.Center
        
        self.textField.text = self.defaultText
    }
    
    func resetText() {
        self.textField.text = self.defaultText
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.isActive = true;
        
        if (textField.text == self.defaultText) {
            textField.text = "";
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.isActive = false;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}