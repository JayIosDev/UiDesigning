
//
//  SampleViewController.swift
//  UiDesigning
//
//  Created by Jayaram G on 07/01/19.
//  Copyright © 2019 Jayaram G. All rights reserved.
//

import UIKit
import Crashlytics
class SampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }


   
}
