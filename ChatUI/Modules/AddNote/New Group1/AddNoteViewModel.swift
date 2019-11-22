//
//  AddNoteViewModel.swift
//  ChatUI
//
//  Created by Ryan on 11/21/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift

class AddNoteViewModel {
    // MARK: Public properties
    let titleSubject = BehaviorSubject<String?>(value: nil)
    let contentSubject = BehaviorSubject<String>(value: "")
    var messages: Observable<Result<String, Error>> {
      return messagesSubject.asObservable()
    }
    
    // MARK: Private properties
    private let repository: AddNoteRepository
    private let validatorProvider: ValidatorProvider
    private let navigator: AddNoteNavigator
    private let messagesSubject = PublishSubject<Result<String, Error>>()
    private let disposeBag = DisposeBag()
    
    init(repository: AddNoteRepository,
         validatorProvider: ValidatorProvider,
         navigator: AddNoteNavigator) {
        self.repository = repository
        self.validatorProvider = validatorProvider
        self.navigator = navigator
    }
    
    @objc func addNote() {
        do {
            let title = try titleSubject.value()
            let content = try contentSubject.value()
            
            guard validateFields(content: content) else { return }
            
            repository
                .addNote(title: title, content: content)
                .subscribe(
                    onCompleted: { [weak self] in
                        guard let self = self else { return }
                        self.messagesSubject.onNext(.success("Added note successfully"))
                    },
                    onError: { [weak self] error in
                        guard let self = self else { return }
                        self.messagesSubject.onNext(.failure(error))
                    })
                .disposed(by: disposeBag)
        } catch {
            fatalError("Error accessing field values from sign in screen.")
        }
    }
    
    func didShowSuccessMessage() {
        navigator.goToListNotes()
    }
    
    private func validateFields(content: String) -> Bool {
        var isValid = true
        
        do {
            try validatorProvider
                .requiredFieldValidator(fieldName: "Note content")
                .validated(content)
        } catch {
            messagesSubject.onNext(.failure(error))
            isValid = false
        }
        return isValid
    }
}
