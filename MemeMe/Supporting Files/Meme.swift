//
//  Meme.swift
//  MemeMe
//
//  Created by administrator on 12/5/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class Meme {
    var topText: String!
    var bottomText: String!
    var originalImage: UIImage!
    var memedImage: UIImage!
    
    init(top: String, bottom: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = top
        self.bottomText = bottom
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}
