//
//  WelcomeViewController.swift
//  ChatUI
//
//  Created by Ryan on 11/10/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WelcomeViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: WelcomeViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        addSubscriptions()
        bindActions()
    }
    
    private func addSubscriptions() {
        
        viewModel?.logoData
            .observeOn(MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] data in
                    guard let self = self else { return }
                    self.logoImageView.image = UIImage(data: data)
                    self.activityIndicator.removeFromSuperview()
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.activityIndicator.removeFromSuperview()
                    self.showAlert(message: error.localizedDescription, completion: nil)
                })
            .disposed(by: disposeBag)
    }
    
    private func bindActions() {
        guard let viewModel = viewModel else { return }
        signInButton.addTarget(viewModel, action: #selector(viewModel.showSignInView), for: .touchUpInside)
        signUpButton.addTarget(viewModel, action: #selector(viewModel.showSignUpView), for: .touchUpInside)
    }

}
