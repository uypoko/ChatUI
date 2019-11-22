//
//  EditNoteViewController.swift
//  ChatUI
//
//  Created by Ryan on 11/20/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditNoteViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var viewModel: EditNoteViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        bindViews()
        bindToViewModel()
    }
    
    private func bindViews() {
        guard let viewModel = viewModel else { return }
        viewModel.title
            .asDriver(onErrorJustReturn: nil)
            .drive(titleField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.content
            .asDriver(onErrorJustReturn: "")
            .drive(contentField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindToViewModel() {
        guard let viewModel = viewModel else { return }
        
        titleField.rx.text
            .asDriver()
            .drive(viewModel.titleInput)
            .disposed(by: disposeBag)
        
        contentField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.contentInput)
            .disposed(by: disposeBag)
    }
    
    @objc private func deleteButtonTapped() {
        showConfirmAlert(
            title: "Are you sure?",
            message: nil,
            completion: { [weak self] _ in
                guard let self = self,
                    let viewModel = self.viewModel else { return }
                viewModel.deleteNote()
        })
    }

}
