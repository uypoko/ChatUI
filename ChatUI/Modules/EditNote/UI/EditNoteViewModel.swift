//
//  EditNoteViewModel.swift
//  ChatUI
//
//  Created by Ryan on 11/20/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class EditNoteViewModel {
    // MARK: Public properties
    let title: BehaviorSubject<String?>
    let content: BehaviorSubject<String>
    // MARK: Input
    let titleInput = PublishSubject<String?>()
    let contentInput = PublishSubject<String>()
    // MARK: Private properties
    private let note: Note
    private let navigator: EditNoteNavigator
    private let repository: EditNoteRepository
    private var token: NotificationToken?
    private let disposeBag = DisposeBag()
    
    init(note: Note,
         navigator: EditNoteNavigator,
         repository: EditNoteRepository) {
        self.note = note
        self.navigator = navigator
        self.repository = repository
        
        title = BehaviorSubject(value: note.title)
        content = BehaviorSubject(value: note.text)
        
        bindFromDB()
        bindToDB()
    }
    
    // Bind data from Realm
    private func bindFromDB() {
        token = note.observe { [weak self] change in
            guard let self = self else { return }
            
            switch change {
            case .change(let properties):
                for prop in properties {
                    switch prop.name {
                    case "title":
                        self.title.onNext(prop.newValue as? String)
                    case "text":
                        if let text = prop.newValue as? String {
                            self.content.onNext(text)
                        }
                    default:
                        break
                    }
                }
              break
            case .error(let error):
              print("Error occurred: \(error)")
            case .deleted:
                self.navigator.popToListNotes()
            }
        }
    }
    
    // Bind data from input to Realm
    private func bindToDB() {
        titleInput.subscribe(
            onNext: { [weak self] title in
                guard let self = self else { return }
                self.repository.changeTitle(to: title, id: self.note.id)
            })
            .disposed(by: disposeBag)
        
        contentInput.subscribe(
            onNext: { [weak self] content in
                guard let self = self else { return }
                self.repository.changeContent(to: content, id: self.note.id)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteNote() {
        repository.deleteNote(id: note.id)
        navigator.popToListNotes()
    }
    
    deinit {
        token?.invalidate()
    }
}
