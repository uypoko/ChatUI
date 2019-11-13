//
//  SignInContainer.swift
//  ChatUI
//
//  Created by Ryan on 11/13/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

class SignInContainer {
    private let appDependencyContainer: AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func constructSignInViewController() -> SignInViewController {
        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        guard let signInViewController = storyboard.instantiateInitialViewController() as? SignInViewController else {
            fatalError("Failed to initialize Sign In from storyboard")
        }
        
        let signInRepository = SignInRepositoryImp(
            auth: appDependencyContainer.auth,
            remoteDatabase: appDependencyContainer.remoteDatabase)
        let signInInteractor = SignInInteractor(
            signInRepository: signInRepository,
            localRepository: appDependencyContainer.localRepository)
        let viewModel = SignInViewModel(
            signInInteractor: signInInteractor,
            validator: appDependencyContainer.validator)
        
        signInViewController.viewModel = viewModel
        
        return signInViewController
    }
    
    func constructSignInViewController(email: String, password: String) -> SignInViewController {
        let signInViewController = constructSignInViewController()
        signInViewController.initialEmail = email
        signInViewController.initialPassword = password
        return signInViewController
    }
}