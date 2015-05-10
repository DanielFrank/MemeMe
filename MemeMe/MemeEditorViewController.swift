//
//  MemeEditor.swift
//  MemeMe
//
//  Created by Daniel Frank on 5/5/15.
//  Copyright (c) 2015 Daniel Frank. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var topToolbar: UIToolbar!
   
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var editedMeme: Meme?
    
    let defaultTop = "TOP"
    let defaultBottom = "BOTTOM"
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        prepTextField(topTextField, defaultValue: defaultTop)
        prepTextField(bottomTextField, defaultValue: defaultBottom)
        if let meme = self.editedMeme {
            self.topTextField.text = meme.topString
            self.bottomTextField.text = meme.bottomString
            self.imagePickerView.image = meme.originalImage
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        actionButton.enabled = (imagePickerView.image != nil)
        cancelButton.enabled = (Meme.getMemeCopy().count > 0)
        
        self.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    func prepTextField(textField: UITextField, defaultValue: String) {
        textField.text = defaultValue
        textField.delegate = self
        textField.textAlignment = NSTextAlignment.Center
        textField.defaultTextAttributes = memeTextAttributes
        textField.backgroundColor = UIColor.clearColor()
    }

    
    @IBAction func share(sender: UIBarButtonItem) {
        let memedImage = self.generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            self.save(memedImage)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        self.genImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        self.genImagePicker(UIImagePickerControllerSourceType.Camera)
        
    }
    
    
    func genImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    
    //meme-gen activities
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.bottomToolbar.hidden = true
        self.topToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        self.bottomToolbar.hidden = false
        self.topToolbar.hidden = false
        
        return memedImage
    }
    
    func save(memedImage : UIImage) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate

        if let meme = self.editedMeme {
            meme.topString = self.topTextField.text
            meme.bottomString = self.bottomTextField.text
            meme.originalImage = self.imagePickerView.image!
            meme.memedImage = memedImage
        } else {
            var meme = Meme(topString: self.topTextField.text, bottomString: self.bottomTextField.text, image: self.imagePickerView.image!, memedImage: memedImage)
            appDelegate.memes.append(meme)
        }

        
    }
    
    //keyboard-related stuff
    //Want to move up view if editing bottom text field
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.editing {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.editing {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //ImagePickerDelegate stuff
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //TextEditorDelegate Stuff
    
    //Clear text field if default
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == defaultTop) || (textField.text == defaultBottom) {
            textField.text = ""
        }
    }
    
    //If return, done editing
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}