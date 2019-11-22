//
//  AddNoteViewController.swift
//  ChatUI
//
//  Created by Ryan on 11/21/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddNoteViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var viewModel: AddNoteViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        
        saveButton.addTarget(viewModel, action: #selector(viewModel.addNote), for: .touchUpInside)
        bindToViewModel()
        observeMessages()
    }
    
    private func bindToViewModel() {
        guard let viewModel = viewModel else { return }
        
        titleField.rx.text
            .asDriver()
            .drive(viewModel.titleSubject)
            .disposed(by: disposeBag)
        
        contentTextView.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.contentSubject)
            .disposed(by: disposeBag)
    }
    
    private func observeMessages() {
        guard let viewModel = viewModel else { return }
        
        viewModel.messages
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let message):
                        self.showMessageAlert(
                            message: message,
                            completion: { _ in self.viewModel?.didShowSuccessMessage() })
                    case .failure(let error):
                        self.showMessageAlert(message: error.localizedDescription, completion: nil)
                    }
                }
            )
            .disposed(by: disposeBag)
    }

}
