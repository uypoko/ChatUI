//
//  SignUpContainer.swift
//  ChatUI
//
//  Created by Ryan on 11/12/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

class SignUpContainer {
    private let appDependencyContainer: AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func makeSignUpViewController() -> SignUpViewController {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? SignUpViewController else {
            fatalError("Failed to initialize Sign Up from storyboard")
        }
        
        let repository = SignUpRepositoryImp(
            auth: appDependencyContainer.auth,
            remoteDatabase: appDependencyContainer.remoteDatabase)
        let signUpInteractor = SignUpInteractor(signUpRepository: repository)
        let viewModel = SignUpViewModel(
            signUpInteractor: signUpInteractor,
            signUpNavigator: self,
            validator: appDependencyContainer.validator)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}

extension SignUpContainer: SignUpNavigator {
    func goToSignIn(email: String, password: String) {
        
    }
    
}
