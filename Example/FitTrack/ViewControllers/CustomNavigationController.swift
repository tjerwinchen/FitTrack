//
//  CustomNavigationController.swift
//  YALFitnessConcept
//
//  Created by Roman Scherbakov on 22.03.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    static let navControllerIdentifier = "navigationController"
    
    // MARK - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    // MARK - Private methods
    private func configureNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        isNavigationBarHidden = true
    }
    
}
