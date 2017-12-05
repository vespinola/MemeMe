//
//  Util.swift
//  MemeMe
//
//  Created by administrator on 12/4/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import UIKit

class Util {
    class func showActivityView(for items: [AnyObject], in viewController: UIViewController, onCompletion: (() -> Void)? = nil) {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController.present(controller, animated: true, completion: onCompletion)
    }
}
