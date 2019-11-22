//
//  UserManagementViewController.swift
//  ChatUI
//
//  Created by Ryan on 11/10/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit
import RxSwift

class UserManagementViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    
    var viewModel: UserManagementViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }

        signOutButton.addTarget(viewModel, action: #selector(viewModel.signOutButtonTapped), for: .touchUpInside)
        observeMessages()
    }
    
    private func observeMessages() {
        guard let viewModel = viewModel else { return }
        
        viewModel.messages
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let message):
                    self.showMessageAlert(message: message, completion: nil)
                case .failure(let error):
                    self.showMessageAlert(message: error.localizedDescription, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }

}
