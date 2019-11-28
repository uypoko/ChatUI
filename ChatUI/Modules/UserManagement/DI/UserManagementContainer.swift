//
//  UserManagementContainer.swift
//  ChatUI
//
//  Created by Ryan on 11/22/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import UIKit

class UserManagementContainer {
    private let appDependencyContainer: AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func constructUserManagementViewController() -> UserManagementViewController {
        let storyboard = UIStoryboard(name: "UserManagement", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? UserManagementViewController else {
            fatalError("Failed to initialize UserManagement from storyboard")
        }
        
        let repository = UserManagementRepositoryImp(auth: appDependencyContainer.auth)
        let signOutInteractor = SignOutInteractor(
            userManagementRepo: repository,
            localRepo: appDependencyContainer.userSessionRepository)
        
        let viewModel = UserManagementViewModel(interactor: signOutInteractor, navigator: self)
        
        viewController.viewModel = viewModel
        return viewController
    }
}

extension UserManagementContainer: UserManagementNavigator {
    func goToWelcome() {
        appDependencyContainer.loadUserSession()
    }
}
