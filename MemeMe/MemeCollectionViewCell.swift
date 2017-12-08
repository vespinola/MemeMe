//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by administrator on 12/6/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        memeImageView.contentMode = .scaleAspectFit
    }
    
}
