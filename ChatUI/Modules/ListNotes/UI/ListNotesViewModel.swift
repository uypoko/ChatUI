//
//  ListNotesViewModel.swift
//  ChatUI
//
//  Created by Ryan on 11/19/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class ListNotesViewModel {
    // MARK: Public properties
    var messages: Observable<String> {
        return messagesSubject.asObserver()
    }
    let notes: Results<Note>
    
    // MARK: Private properties
    private let hasUserSession: Observable<Bool>
    private let messagesSubject = BehaviorSubject<String>(value: "")
    private let listNotesRepository: ListNotesRepository
    private let navigator: ListNotesNavigator
    private let disposeBag = DisposeBag()
    
    init(userSessionSubject: BehaviorSubject<UserSession?>,
         listNotesRepository: ListNotesRepository,
         navigator: ListNotesNavigator) {
        self.hasUserSession = userSessionSubject.map{ $0 != nil }
        self.listNotesRepository = listNotesRepository
        self.navigator = navigator
        notes = listNotesRepository.fetchNotes()
    }
    
    func goToEditNote(note: Note) {
        navigator.goToEditNote(note: note)
    }
    
    @objc func addNoteButtonTapped() {
        navigator.goToAddNote()
    }
}
