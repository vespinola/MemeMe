//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by administrator on 12/6/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sent Memes View"
    
        memes = Session.sharedInstance.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard memes.count != Session.sharedInstance.memes.count else { return }
        memes = Session.sharedInstance.memes
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath)
        let meme = memes[indexPath.row]

        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        cell.detailTextLabel?.text = meme.bottomText

        return cell
    }
 
    @IBAction func generateMeme(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MemeGeneratorViewControllerID") as! MemeGeneratorViewController
        present(vc, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MemeDetailViewControllerID") as! MemeDetailViewController
        vc.memedImage = memes[indexPath.row].memedImage
        navigationController?.pushViewController(vc, animated: true)
    }
}
