//
//  EditorVC.swift
//  Meme
//
//  Created by Gary Wang on 3/28/15.
//  Copyright (c) 2015 self. All rights reserved.
//

import UIKit
import AssetsLibrary

class EditorVC: UIViewController ,
    UIImagePickerControllerDelegate ,
    UINavigationControllerDelegate ,
    UITextFieldDelegate {
   //define global variable
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButtom: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var albumButtom: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 50.0
    var keyboardFrame: CGRect = CGRect.nullRect
    var keyboardIsShowing: Bool = false
    @IBOutlet weak var activeTextField: UITextField?
 var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup background color to black
        self.view.backgroundColor = UIColor.blackColor()
    
        imagePicker.delegate = self
        for subview in self.view.subviews
        {
            if (subview.isKindOfClass(UITextField))
            {
                var textField = subview as UITextField
                textField.addTarget(self, action: "textFieldDidReturn:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
                textField.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingDidBegin)
            }
        }

        /**********************/
        //setup textfield frame
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.whiteColor(),
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 25)!,
            NSStrokeWidthAttributeName : 8.0,
            ]
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.text = "TOP"
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        topTextField.borderStyle = UITextBorderStyle.Line
        topTextField.leftViewMode = UITextFieldViewMode.Always
        topTextField.font = UIFont.boldSystemFontOfSize(25)
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.text = "BOTTOM"
        bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        bottomTextField.borderStyle = UITextBorderStyle.Line
        bottomTextField.font = UIFont.boldSystemFontOfSize(25)
        /************************/
        
        //setup image frame
        imagePicker.delegate = self
        self.view.sendSubviewToBack(ImagePickerView)
        ImagePickerView.contentMode = .ScaleAspectFill
        
        
        /***********************/
   
        //setup navigation bar
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareImage:"), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "CancelButton:"), animated: true)
        self.navigationItem.leftBarButtonItem?.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        //setup to pickup image
        var chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage
        ImagePickerView.contentMode = .ScaleAspectFill
        ImagePickerView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    //get image from photo album
    @IBAction func ImageFromAlbum(sender: UIBarButtonItem) {
        imagePicker.allowsEditing = false //2
        imagePicker.sourceType = .PhotoLibrary //3
        imagePicker.modalPresentationStyle = .Popover
        presentViewController(imagePicker, animated: true, completion: nil)
        imagePicker.popoverPresentationController?.barButtonItem = sender
    }
    
    //get image from camera
    @IBAction func ImageFromCamera(sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraCaptureMode = .Photo
            presentViewController(imagePicker, animated: true, completion: nil)
       
        }
        
    }
    
    //when generate image the toolbar and navigation bar need hide
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        toolBar.hidden = true
       self.navigationController?.navigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        //Show toolbar and navibar
        toolBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        return memedImage
    }
    
    //save image
    func saveMemeImage(image :UIImage) -> Bool  {
        //Create the meme image and text together
        if  let  img = ImagePickerView.image? {
            var meme = Meme( topT: topTextField.text!, bottomT: bottomTextField.text!, img:
                ImagePickerView.image!, memeimage: generateMemedImage())
            appDelegate.memes.append(meme)
            return true
        }
        return false
    }

    //when click shared icon it save image and push to table view
    @IBAction func shareImage(sender: UIBarButtonItem) {
        //generate meme image

        
        var image : UIImage = generateMemedImage()
        //save image
        if (self.saveMemeImage(image)) {
            let activityViewController = UIActivityViewController(
                activityItems: [image],
                applicationActivities: nil)
            
            activityViewController.completionWithItemsHandler = {
                (activityType, success, items, error) in
                if(success)
                {
                      println("activityViewController success")
                }
                else
                {
                     println("Error: \(error) Items: \(items)")
                }
                
            let viewController:UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MemesEntry") as UITabBarController
           self.presentViewController(viewController, animated: false, completion: nil)
            }
        self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
   
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //add Observer to get notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)

        // if camera is not available the hide camera and disable it
        if (UIImagePickerController.isSourceTypeAvailable    (UIImagePickerControllerSourceType.Camera)) == false {
            cameraButtom.enabled = UIImagePickerController.isSourceTypeAvailable    (UIImagePickerControllerSourceType.Camera)
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        //when keyboard is showing the keyboard needs shift
        self.keyboardIsShowing = true
        if let info = notification.userInfo {
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            self.arrangeViewOffsetFromKeyboard()
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        //after hide keyboard the screen needs to reset to init condition
        self.keyboardIsShowing = false
        self.returnViewToInitialFrame()
    }

    func arrangeViewOffsetFromKeyboard()
    {   //shift keyboard
        var theApp: UIApplication = UIApplication.sharedApplication()
        var windowView: UIView? = theApp.delegate!.window!
        var textFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.activeTextField!.frame.origin.y + self.activeTextField!.frame.size.height)
        var convertedTextFieldLowerPoint: CGPoint = self.view.convertPoint(textFieldLowerPoint, toView: windowView)
        var targetTextFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset)
        var targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - convertedTextFieldLowerPoint.y
        var adjustedViewFrameCenter: CGPoint = CGPointMake(self.view.center.x, self.view.center.y + targetPointOffset)
        UIView.animateWithDuration(0.2, animations:  {
            self.view.center = adjustedViewFrameCenter
        })
    }
    
    
    //reset to init
    func returnViewToInitialFrame()
    {
        var initialViewRect: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        
        if (!CGRectEqualToRect(initialViewRect, self.view.frame))
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame = initialViewRect
            });
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {   //setup when textfield is tapped
        if (self.activeTextField != nil)
        {
            self.activeTextField?.resignFirstResponder()
            self.activeTextField = nil
        }
    }
    
    //after return key hit screen need to reset to init
    @IBAction func textFieldDidReturn(textField: UITextField!)
    {
        textField.resignFirstResponder()
        self.activeTextField = nil
        self.navigationItem.leftBarButtonItem?.enabled = true
        returnViewToInitialFrame()
    }
    
    //begin to edit the keyboard needs to shift and clear defulat text on the textfield
    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.activeTextField = textField
        if (self.activeTextField?.text == "TOP" || self.activeTextField?.text == "BOTTOM") {
            self.activeTextField?.text = ""
        }
        if(self.keyboardIsShowing)
        {
            self.arrangeViewOffsetFromKeyboard()
        }
    }
    
    //hit calcel button the textfield need to reset to init
    @IBAction func CancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    // pick the image to show on screen
    @IBAction func pickImage(sender: AnyObject) {
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true , completion: nil)
    }

    
    deinit {
        println("deinit EditorVC")
    }
    
    
}

