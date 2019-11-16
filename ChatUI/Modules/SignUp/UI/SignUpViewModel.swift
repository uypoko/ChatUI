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

    var messages: Observable<Result<String, Error>> {
      return messagesSubject.asObservable()
    }
    var activityIndicatorAnimating: Observable<Bool> {
      return activityIndicatorAnimatingSubject.asObservable()
    }
    // MARK: Private properties
    private let signUpInteractor: SignUpInteractor
    private let signUpNavigator: SignUpNavigator
    private weak var validatorProvider: ValidatorProvider?
    private let messagesSubject = PublishSubject<Result<String, Error>>()
    private let activityIndicatorAnimatingSubject = BehaviorSubject<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    init(signUpInteractor: SignUpInteractor,
         signUpNavigator: SignUpNavigator,
         validator: ValidatorProvider) {
        self.signUpInteractor = signUpInteractor
        self.signUpNavigator = signUpNavigator
        self.validatorProvider = validator
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
                        self.messagesSubject.onNext(.success("Signed up successfully."))
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
        messagesSubject.onNext(.failure(error))
    }
    
    private func validateFields(email: String, password: String, name: String, mobileNumber: String) -> Bool {
        var isValid = true
        guard let validatorProvider = validatorProvider else { return false }
        
        do {
            try validatorProvider.emailValidator.validated(email)
            try validatorProvider.passwordValidator.validated(password)
            try validatorProvider.requiredFieldValidator(fieldName: "Name").validated(name)
            try validatorProvider.phoneValidator.validated(mobileNumber)
        } catch {
            messagesSubject.onNext(.failure(error))
            isValid = false
        }
        return isValid
    }
}
