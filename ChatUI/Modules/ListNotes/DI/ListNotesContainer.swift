//
//  ListNotesContainer.swift
//  ChatUI
//
//  Created by Ryan on 11/19/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import UIKit

class ListNotesContainer {
    private let appDependencyContainer: AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func constructListNotesViewController() -> ListNotesViewController {
        let storyboard = UIStoryboard(name: "ListNotes", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? ListNotesViewController else {
            fatalError("Failed to initialize List Notes from storyboard")
        }
        
        let notesRealmProvider = RealmProvider(
            pathProvider: appDependencyContainer.pathProvider,
            configType: .libraryNotes)
        guard let notesRealm = notesRealmProvider.realm else {
            fatalError("Could not load note realm file in library")
        }
        
        let repository = ListNotesRepositoryImp(realm: notesRealm)
        let viewModel = ListNotesViewModel(
            userSessionSubject: appDependencyContainer.userSessionSubject,
            listNotesRepository: repository,
            navigator: self)
        viewController.viewModel = viewModel
        
        return viewController
    }
}

extension ListNotesContainer: ListNotesNavigator {
    func goToWelcome() {
        appDependencyContainer.navigationController.popViewController(animated: true)
    }
    
    func goToEditNote(note: Note) {
        let editNoteContainer = EditNoteContainer(appDependencyContainer: appDependencyContainer)
        let editNoteVC = editNoteContainer.constructEditNoteViewController(note: note)
        appDependencyContainer
            .navigationController
            .pushViewController(editNoteVC, animated: true)
    }
    
    func goToAddNote() {
        let addNoteContainer = AddNoteContainer(appDependencyContainer: appDependencyContainer)
        let addNoteVC = addNoteContainer.constructAddNoteViewController()
        appDependencyContainer
            .navigationController
            .pushViewController(addNoteVC, animated: true)
    }
}
