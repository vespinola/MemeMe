//
//  ViewController.swift
//  MemeMe
//
//  Created by administrator on 12/4/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        imagePickerView.contentMode = .scaleAspectFit
        imagePickerView.backgroundColor = UIColor.black
        
        let memeTextAttributes: [String : Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.white/* TODO: fill in appropriate UIColor */,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white/* TODO: fill in appropriate UIColor */,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: 2/* TODO: fill in appropriate Float */
        ]
        
        [topTextfield, bottomTextfield].forEach {
            $0?.defaultTextAttributes = memeTextAttributes
            $0?.textAlignment = .center
            $0?.delegate = self
        }
        
        topTextfield.text = "TOP"
        bottomTextfield.text = "BOTTOM"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        showImagePicker(for: .camera)
    }
    
    @IBAction func pickAnImageFromLibray(_ sender: Any) {
        showImagePicker(for: .photoLibrary)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension ViewController: UITextFieldDelegate {
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

extension ViewController {
    //Mark: Helpers
    func showImagePicker(for sourceType: UIImagePickerControllerSourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
}

