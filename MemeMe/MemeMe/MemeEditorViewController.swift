//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Jakub on 02.08.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var autoLayoutContainer: UIView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageViewContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var topTextFieldDelegate: TextFieldDelegate!
    var bottomTextFieldDelegate: TextFieldDelegate!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        self.topTextFieldDelegate = TextFieldDelegate(textFieldType: "top", textField: topTextField)
        self.bottomTextFieldDelegate = TextFieldDelegate(textFieldType: "bottom", textField: bottomTextField)
        
        self.topTextField.delegate = self.topTextFieldDelegate
        self.bottomTextField.delegate = self.bottomTextFieldDelegate

        self.subscribeToKeyboardNotifications()
        
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.Black;
        
        if let imageViewHasImage = self.imageView.image {
            shareButton.enabled = true
        } else {
            shareButton.enabled = false
        }
        
        //self.imageViewContainer.frame = CGRectMake(0, 0, 40, 30)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateImageContainerSize()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        self.pickAnImage(pickFromCamera: true)
    }
    
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        self.pickAnImage()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.topTextFieldDelegate.resetText()
        self.bottomTextFieldDelegate.resetText()
        self.imageView.image = nil
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        let memedImage = self.generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    func saveMeme() {
        let memedImage = self.generateMemedImage()
        var meme = Meme(texts: (top: topTextField.text, bottom: bottomTextField.text), image: self.imageView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        println(self.imageViewContainer.frame)
        var multiplier = CGFloat(0)
        
        if let image = self.imageView.image {
            let oldImageSize = self.imageViewContainerWidth.constant;
            let temporarySize = (image.size.width > image.size.height) ? image.size.height : image.size.width;
        
            multiplier = (temporarySize / oldImageSize) * 2;
        }
        
        
        //self.imageViewContainerWidth.
        
        println(self.imageViewContainer.frame)
        
        UIGraphicsBeginImageContextWithOptions(self.imageViewContainer.bounds.size, false, multiplier)
        //UIGraphicsBeginImageContext(self.imageViewContainer.bounds.size)
        
        self.imageViewContainer.drawViewHierarchyInRect(self.imageViewContainer.bounds, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        //self.topTextFieldDelegate.applyFontSizeMultiplier(multiplier: 1)
        //self.bottomTextFieldDelegate.applyFontSizeMultiplier(multiplier: 1)
        //self.updateImageContainerSize()
        
        return memedImage;
    }
    
    
    func pickAnImage(pickFromCamera:Bool = false) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        if (pickFromCamera) {
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        }
        
        self.presentViewController(pickerController, animated: true, completion: nil);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.imageView.image = image;
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardSlideActivity:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardSlideActivity:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardSlideActivity(notification: NSNotification) {
        if (!bottomTextFieldDelegate.isActive) {
            return;
        }
        
        var keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        var keyboardSizeAsFloat = Float(keyboardSize.CGRectValue().height)
        
        var margin = Float(self.autoLayoutContainer.frame.height - self.imageViewContainer.frame.height);
        margin /= 2;
        
        keyboardSizeAsFloat -= margin;
        
        if (notification.name == "UIKeyboardWillHideNotification") {
            let multiplier: Float = -1.0
            keyboardSizeAsFloat = keyboardSizeAsFloat * multiplier;
            
        }

        
        self.imageViewContainer.frame.origin.y -= CGFloat(keyboardSizeAsFloat);
    }
    
    func updateImageContainerSize() {
        let size = (self.autoLayoutContainer.frame.width > self.autoLayoutContainer.frame.height) ? self.autoLayoutContainer.frame.height : self.autoLayoutContainer.frame.width;
        
        self.imageViewContainerWidth.constant = size
        self.imageViewContainerHeight.constant = size
        
        //println(self.imageViewContainer.frame.origin.y)
    }
    
}
