//
//  MemeGeneratorViewController.swift
//  MemeMe
//
//  Created by administrator on 12/4/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class MemeGeneratorViewController: UIViewController {
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var memedImage: UIImage!
    var bottomTextFieldIsFocused = false
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide navigation Bar
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //Set imagePicker delegate
        imagePicker.delegate = self
        
        //Setup ImagePickerView content with Aspect Fit
        imagePickerView.contentMode = .scaleAspectFit
        imagePickerView.backgroundColor = UIColor.black
        
        let memeTextAttributes: [String : Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -3
        ]
        
        [topTextfield, bottomTextfield].forEach {
            $0?.defaultTextAttributes = memeTextAttributes
            $0?.textAlignment = .center
            $0?.adjustsFontSizeToFitWidth = true
            $0?.delegate = self
        }
        
        [topToolbar, bottomToolbar].forEach {
            $0?.alpha = 0.8
        }
        
        topTextfield.text = Constants.meme.topText
        bottomTextfield.text = Constants.meme.bottomText
        
        //Disable share button when the app is launched
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //verify camera
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotification()
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        showImagePicker(for: .camera)
    }
    
    @IBAction func pickAnImageFromLibray(_ sender: Any) {
        showImagePicker(for: .photoLibrary)
    }
    
    @IBAction func shareButtonOnTap(_ sender: Any) {
        memedImage = generateMemedImage()
        
        Util.showActivityView(for: [memedImage], in: self, onCompletion: {
            self.save()
        })
    }
    
    @IBAction func cancelButtonOnTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension MemeGeneratorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension MemeGeneratorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text?.lowercased(), text == Constants.meme.topText.lowercased() || text == Constants.meme.bottomText.lowercased()  {
            textField.text = ""
        }
        
        bottomTextFieldIsFocused = bottomTextfield == textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text?.lowercased(), textField == topTextfield, text.isEmpty   {
            textField.text =  Constants.meme.topText
        } else if let text = textField.text?.lowercased(), textField == bottomTextfield, text.isEmpty   {
            textField.text =  Constants.meme.bottomText
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = NSString(string: textField.text!).replacingCharacters(in: range, with: string).uppercased()
        return false
    }
}

extension MemeGeneratorViewController {
    //MARK: Helpers
    func showImagePicker(for sourceType: UIImagePickerControllerSourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    @objc func keyboardWillShow(notification: Notification) {
        //only the bottom textfield needs that keyboard changes its origin y
        guard bottomTextFieldIsFocused else { return }
        self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard bottomTextFieldIsFocused else { return }
        self.view.frame.origin.y = 0
    }
    
    //MARK: Keyboard Observers
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Meme Generator
    func generateMemedImage() -> UIImage {
    
        hideToolbars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbars(false)
        
        return memedImage
    }

    func hideToolbars(_ value: Bool) {
        [bottomToolbar, topToolbar].forEach {
            $0?.isHidden = value
        }
    }
    
    //MARK: Meme Saver
    func save(){
        let meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
}





