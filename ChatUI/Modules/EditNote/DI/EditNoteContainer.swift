//
//  EditNoteContainer.swift
//  ChatUI
//
//  Created by Ryan on 11/20/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

class EditNoteContainer {
    private let appDependencyContainer: AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func constructEditNoteViewController(note: Note) -> EditNoteViewController {
        let storyboard = UIStoryboard(name: "EditNote", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? EditNoteViewController else {
            fatalError("Failed to initialize Edit Note from storyboard")
        }
        
        let realmProvider = RealmProvider(
            pathProvider: appDependencyContainer.pathProvider,
            configType: .libraryNotes)
        guard let realm = realmProvider.realm else {
            fatalError("Could not initialize Realm form EditNote")
        }
        let repository = EditNoteRepositoryImp(realm: realm)
        
        let viewModel = EditNoteViewModel(
            note: note,
            navigator: self,
            repository: repository)
        
        viewController.viewModel = viewModel
        return viewController
    }
}

extension EditNoteContainer: EditNoteNavigator {
    func popToListNotes() {
        appDependencyContainer.navigationController.popViewController(animated: true)
    }
    
}
