//
//  AppDependencyContainer.swift
//  ChatUI
//
//  Created by Ryan on 11/8/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import UIKit

class AppDependencyContainer {
    var navigationController: UINavigationController?
    
    func makeMainViewController() -> MainViewController {
        let mainLocalRepository = MainLocalRepositoryImp()
        let readUserSession = ReadUserSession(mainLocalRepository: mainLocalRepository)
        let mainViewModel = MainViewModel(readUserSession: readUserSession, mainNavigator: self)
        let mainViewController = MainViewController(mainViewModel: mainViewModel)
        return mainViewController
    }
}

extension AppDependencyContainer: MainNavigator {
    func navigateToWelcome() {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let welcomeVC = storyboard.instantiateInitialViewController()
        if let welcomeVC = welcomeVC {
            navigationController?.present(welcomeVC, animated: true)
        }
    }
    
    func navigateToListMessages() {
        print("navigateToListMessages")
    }
}
