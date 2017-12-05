//
//  ActivityViewController.swift
//  MemeMe
//
//  Created by administrator on 12/4/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
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
        
        topTextfield.text = "TOP"
        bottomTextfield.text = "BOTTOM"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        Util.showActivityView(for: [generateMemedImage()], in: self, onCompletion: {
            self.save()
        })
    }
    
    @IBAction func cancelButtonOnTap(_ sender: Any) {
        
    }
}

extension ActivityViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ActivityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text?.lowercased(), text == "top" || text == "bottom"  {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text?.lowercased(), text == "", textField == topTextfield   {
            textField.text = "TOP"
        } else if let text = textField.text?.lowercased(), text == "", textField == bottomTextfield   {
            textField.text = "BOTTOM"
        }
    }
}

extension ActivityViewController {
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
        self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    //MARK: Keyboard Observers
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Meme Generator
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        toolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        toolbar.isHidden = false
        
        return memedImage
    }
    
    //MARK: Meme Saver
    func save(){
        let memedImage = generateMemedImage()
//        let meme = Meme(top: topTextfield.text!, bottom: bottomTextfield.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
    
}





