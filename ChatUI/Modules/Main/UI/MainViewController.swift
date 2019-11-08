//
//  MainViewController.swift
//  ChatUI
//
//  Created by Ryan on 11/8/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

class MainViewController: NiblessViewController {
    private let mainViewModel: MainViewModel
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        super.init()
    }
    
    override func viewDidLoad() {
        mainViewModel.checkUserSession()
    }
}
