//
//  ViewController.swift
//  IOSStudentManagement
//
//  Created by Harry Kay on 21/10/18.
//  Copyright © 2018 Harry Kay. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func touchExamButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func touchStudentButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    
    @IBAction func touchMapButton(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
    }
}

