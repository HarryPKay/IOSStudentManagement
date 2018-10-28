//
//  ViewController.swift
//  IOSStudentManagement
//
//  Created by Harry Kay on 21/10/18.
//  Copyright © 2018 Harry Kay. All rights reserved.
//

import Foundation
import UIKit

// Changes which tab is viewed based on which button is pressed.
class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
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
    
    func setGradientBackground() {
        
        let top =  UIColor(red: 22.0/255.0, green: 114.0/255.0, blue: 245.0/255.0, alpha: 1.0).cgColor
        let bottom = UIColor(red: 150.0/255.0, green: 210.0/255.0, blue: 253.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [top, bottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
