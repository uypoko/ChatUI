//
//  SignUpViewController.swift
//  ChatUI
//
//  Created by Ryan on 11/12/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: SignUpViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindFieldsToViewModel()
        observeErrorMessages()
        observeStateChanges()
        
        guard let viewModel = viewModel else { return }
        signUpButton.addTarget(viewModel, action: #selector(viewModel.SignUp), for: .touchUpInside)
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
        
        viewModel.errorMessages
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                self?.showAlert(message: errorMessage, completion: nil)
            })
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
        
        nameField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.nameInput)
            .disposed(by: disposeBag)
        
        phoneNumberField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.mobileNumberInput)
            .disposed(by: disposeBag)
    }

}

// MARK: Handle keyboard
extension SignUpViewController {
  
  private func registerForKeyboardNotifications() {
      NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func removeObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func onKeyboardAppear(_ notification: NSNotification) {
      let info = notification.userInfo!
      let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
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
