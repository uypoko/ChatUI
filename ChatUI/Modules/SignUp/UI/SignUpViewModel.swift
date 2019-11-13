//
//  SignUpViewModel.swift
//  ChatUI
//
//  Created by Ryan on 11/12/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    // MARK: Public properties
    let emailInput = BehaviorSubject<String>(value: "")
    let passwordInput = BehaviorSubject<String>(value: "")
    let nameInput = BehaviorSubject<String>(value: "")
    let mobileNumberInput = BehaviorSubject<String>(value: "")

    var messages: Observable<String> {
      return messagesSubject.asObservable()
    }
    var activityIndicatorAnimating: Observable<Bool> {
      return activityIndicatorAnimatingSubject.asObservable()
    }
    // MARK: Private properties
    private let signUpInteractor: SignUpInteractor
    private let signUpNavigator: SignUpNavigator
    private let validator: Validator
    private let messagesSubject = PublishSubject<String>()
    private let activityIndicatorAnimatingSubject = BehaviorSubject<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    init(signUpInteractor: SignUpInteractor,
         signUpNavigator: SignUpNavigator,
         validator: Validator) {
        self.signUpInteractor = signUpInteractor
        self.signUpNavigator = signUpNavigator
        self.validator = validator
    }
    
    @objc func SignUp() {
        do {
            let email = try emailInput.value()
            let password = try passwordInput.value()
            let name = try nameInput.value()
            let mobileNumber = try mobileNumberInput.value()
            
            guard validateFields(email: email, password: password, name: name, mobileNumber: mobileNumber) else { return }
            
            activityIndicatorAnimatingSubject.onNext(true)
            signUpInteractor
                .signUp(email: email, password: password, name: name, mobileNumber: mobileNumber)
                .subscribe(
                    onCompleted: { [weak self] in
                        guard let self = self else { return }
                        self.messagesSubject.onNext("Signed up successfully.")
                        self.activityIndicatorAnimatingSubject.onNext(false)
                    },
                    onError: (handleError(error:))
                )
                .disposed(by: disposeBag)
        } catch {
            fatalError("Error accessing field values from sign up screen.")
        }
    }
    
    func didShowSuccessMessage() {
        guard let email = try? emailInput.value(),
            let password = try? passwordInput.value() else { return }
        signUpNavigator.goToSignIn(email: email, password: password)
    }
    
    private func handleError(error: Error) {
        activityIndicatorAnimatingSubject.onNext(false)
        messagesSubject.onError(error)
    }
    
    private func validateFields(email: String, password: String, name: String, mobileNumber: String) -> Bool {
        var isValid = true
        do {
            try validator.emailValidator.validated(email)
            try validator.passwordValidator.validated(password)
            try validator.requiredFieldValidator(fieldName: "Name").validated(name)
            try validator.phoneValidator.validated(mobileNumber)
        } catch {
            messagesSubject.onError(error)
            isValid = false
        }
        return isValid
    }
}