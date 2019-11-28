//
//  SignInContainer.swift
//  ChatUI
//
//  Created by Ryan on 11/13/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit
import RxSwift

class SignInContainer {
    private let appDependencyContainer: AppDependencyContainer
    private let validatorProvider = ValidatorProvider()
    private let disposeBag = DisposeBag()
    
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
            userSessionRepository: appDependencyContainer.userSessionRepository)
        let viewModel = SignInViewModel(
            signInInteractor: signInInteractor,
            validator: validatorProvider,
            navigator: self)
        
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

extension SignInContainer: SignInNavigator {
    func goToListNotes() {
        appDependencyContainer.loadUserSession()
        
    }
}
