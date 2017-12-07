//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by User on 12/6/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
    }

}
