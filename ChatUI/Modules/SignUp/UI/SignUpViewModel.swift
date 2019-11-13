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
    
    let emailInput = BehaviorSubject<String>(value: "")
    let passwordInput = BehaviorSubject<String>(value: "")
    let nameInput = BehaviorSubject<String>(value: "")
    let mobileNumberInput = BehaviorSubject<String>(value: "")

    var errorMessages: Observable<String> {
      return errorMessagesSubject.asObservable()
    }
    var activityIndicatorAnimating: Observable<Bool> {
      return activityIndicatorAnimatingSubject.asObservable()
    }
    
    private let signUpInteractor: SignUpInteractor
    private let signUpNavigator: SignUpNavigator
    private let validator: Validator
    private let errorMessagesSubject = PublishSubject<String>()
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
                        self.signUpNavigator.goToSignIn(email: email, password: password)
                        self.activityIndicatorAnimatingSubject.onNext(false)
                    },
                    onError: (handleError(error:))
                )
                .disposed(by: disposeBag)
        } catch {
            fatalError("Error accessing field values from sign up screen.")
        }
    }
    
    private func handleError(error: Error) {
        activityIndicatorAnimatingSubject.onNext(false)
        errorMessagesSubject.onNext("Sign up failed, please try again.")
    }
    
    private func validateFields(email: String, password: String, name: String, mobileNumber: String) -> Bool {
        var isValid = true
        do {
            try validator.emailValidator.validated(email)
            try validator.passwordValidator.validated(password)
            try validator.requiredFieldValidator(fieldName: "Name").validated(name)
            try validator.phoneValidator.validated(mobileNumber)
        } catch let error as ValidationError {
            isValid = false
            errorMessagesSubject.onNext(error.message)
        } catch {
            isValid = false
        }
        return isValid
    }
}
