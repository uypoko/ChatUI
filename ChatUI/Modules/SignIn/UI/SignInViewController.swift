//
//  SignInViewController.swift
//  ChatUI
//
//  Created by Ryan on 11/12/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: SignInViewModel?
    var initialEmail: String?
    var initialPassword: String?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindFieldsToViewModel()
        observeErrorMessages()
        observeStateChanges()
        
        if let initialEmail = initialEmail, let initialPassword = initialPassword {
            emailField.text = initialEmail
            passwordField.text = initialPassword
        }
        
        guard let viewModel = viewModel else { return }
        signInButton.addTarget(viewModel, action: #selector(viewModel.signIn), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    private func observeErrorMessages() {
        guard let viewModel = viewModel else { return }
        
        viewModel.messages
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] message in
                    guard let self = self else { return }
                    self.showAlert(
                        message: message,
                        completion: { _ in self.viewModel?.didShowSuccessMessage() })
                },
                onError: { [weak self] error in
                    self?.showAlert(message: error.localizedDescription, completion: nil)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func observeStateChanges() {
        guard let viewModel = viewModel else { return }
        let activityIndicatorAnimating = viewModel.activityIndicatorAnimating
            .asDriver(onErrorJustReturn: false)
        
        activityIndicatorAnimating
            .map { !$0 }
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        activityIndicatorAnimating
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func bindFieldsToViewModel() {
        guard let viewModel = viewModel else { return }
        
        emailField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.emailInput)
            .disposed(by: disposeBag)
        
        passwordField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.passwordInput)
            .disposed(by: disposeBag)
    }

}

extension SignInViewController {
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
  
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
  
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        guard let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
        let kbSize = rect.size
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
  
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
