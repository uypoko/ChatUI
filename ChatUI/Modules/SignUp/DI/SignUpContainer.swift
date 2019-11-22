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
    private let validatorProvider = ValidatorProvider()
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func constructSignUpViewController() -> SignUpViewController {
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
            validator: validatorProvider)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
}

extension SignUpContainer: SignUpNavigator {
    func goToSignIn(email: String, password: String) {
        let signInContainer = SignInContainer(appDependencyContainer: appDependencyContainer)
        let signInVC = signInContainer.constructSignInViewController(email: email, password: password)
        appDependencyContainer.rootNavigationController.present(signInVC, animated: true, completion: nil)
    }
    
}
