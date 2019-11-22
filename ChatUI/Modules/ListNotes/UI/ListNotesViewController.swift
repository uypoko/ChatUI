//
//  TimelineViewController.swift
//  ChatUI
//
//  Created by Ryan on 11/16/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit
import RxSwift
import RxRealm
import RxCocoa

class ListNotesViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var addNoteBarButton: UIBarButtonItem!
    
    var viewModel: ListNotesViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        
        addNoteBarButton.target = viewModel
        addNoteBarButton.action = #selector(viewModel.addNoteButtonTapped)
        
        setupTableView()
        bindToTableView()
        bindViews()
        bindActions()
    }
    
    private func setupTableView() {
        notesTableView.rowHeight = UITableView.automaticDimension
        notesTableView.estimatedRowHeight = 40
    }
    
    private func bindToTableView() {
        guard let viewModel = viewModel else { return }
        
        Observable.collection(from: viewModel.notes)
            .bind(to: notesTableView.rx.items(cellIdentifier: "NoteCell", cellType: ListNotesCell.self)) { index, note, cell in
                cell.bind(title: note.title, date: note.created, content: note.text)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViews() {
        guard let viewModel = viewModel else { return }
        
        viewModel.messages
            .asDriver(onErrorJustReturn: "")
            .drive(messageLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindActions() {
        guard let viewModel = viewModel else { return }
        
        notesTableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.notesTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        notesTableView.rx.modelSelected(Note.self)
            .subscribe(onNext: { note in
                viewModel.goToEditNote(note: note)
            })
            .disposed(by: disposeBag)
    }

}
