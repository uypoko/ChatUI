//
//  SignInViewModel.swift
//  ChatUI
//
//  Created by Ryan on 11/13/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import RxSwift

class SignInViewModel {
    // MARK: Public properties
    let emailInput = BehaviorSubject<String>(value: "")
    let passwordInput = BehaviorSubject<String>(value: "")

    var messages: Observable<Result<String, Error>> {
      return messagesSubject.asObservable()
    }
    var activityIndicatorAnimating: Observable<Bool> {
      return activityIndicatorAnimatingSubject.asObservable()
    }
    // MARK: Private properties
    private let signInInteractor: SignInInteractor
    private weak var validatorProvider: ValidatorProvider?
    private let navigator: SignInNavigator
    private let messagesSubject = PublishSubject<Result<String, Error>>()
    private let activityIndicatorAnimatingSubject = BehaviorSubject<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    init(signInInteractor: SignInInteractor,
         validator: ValidatorProvider,
         navigator: SignInNavigator) {
        self.signInInteractor = signInInteractor
        self.validatorProvider = validator
        self.navigator = navigator
    }
    
    @objc func signIn() {
        do {
            let email = try emailInput.value()
            let password = try passwordInput.value()
            
            guard validateFields(email: email, password: password) else { return }
            
            activityIndicatorAnimatingSubject.onNext(true)
            signInInteractor
                .signIn(email: email, password: password)
                .subscribe(
                    onCompleted: { [weak self] in
                        guard let self = self else { return }
                        self.messagesSubject.onNext(.success("Signed in successfully."))
                        self.activityIndicatorAnimatingSubject.onNext(false)
                    },
                    onError: handleError(error:))
                .disposed(by: disposeBag)
        } catch {
            fatalError("Error accessing field values from sign in screen.")
        }
    }
    
    func didShowSuccessMessage() {
        navigator.goToListNotes()
    }
    
    private func handleError(error: Error) {
        activityIndicatorAnimatingSubject.onNext(false)
        messagesSubject.onNext(.failure(error))
    }
    
    private func validateFields(email: String, password: String) -> Bool {
        var isValid = true
        guard let validatorProvider = validatorProvider else { return false }
        
        do {
            try validatorProvider.emailValidator.validated(email)
            try validatorProvider.passwordValidator.validated(password)
        } catch {
            messagesSubject.onNext(.failure(error))
            isValid = false
        }
        return isValid
    }
    
}
