//
//  ViewController.swift
//  CompassExample
//
//  Created by Liu Chuan on 2018/3/10.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    /// Turn on the compass button
    ///
    /// - Parameter sender: UIButton
    @IBAction func openCompassBtn(_ sender: UIButton) {
        let compassVC = CompassController()
        self.present(compassVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
