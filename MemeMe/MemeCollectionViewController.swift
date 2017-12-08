//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by administrator on 12/6/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sent Memes View"
        
        memes = Session.sharedInstance.memes
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard memes.count != Session.sharedInstance.memes.count else { return }
        memes = Session.sharedInstance.memes
        collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        cell.memeImageView.image = memes[indexPath.row].memedImage
        return cell
    }
    
    @IBAction func generateMeme(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MemeGeneratorViewControllerID") as! MemeGeneratorViewController
        present(vc, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MemeDetailViewControllerID") as! MemeDetailViewController
        vc.memedImage = memes[indexPath.row].memedImage
        navigationController?.pushViewController(vc, animated: true)
    }

}
