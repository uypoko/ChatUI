//
//  AddNoteContainer.swift
//  ChatUI
//
//  Created by Ryan on 11/21/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

class AddNoteContainer {
    private let appDependencyContainer: AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func constructAddNoteViewController() -> AddNoteViewController {
        let storyboard = UIStoryboard(name: "AddNote", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? AddNoteViewController else {
            fatalError("Failed to initialize AddNote from storyboard")
        }
        
        let realmProvider = RealmProvider(
            pathProvider: appDependencyContainer.pathProvider,
            configType: .libraryNotes)
        guard let realm = realmProvider.realm else {
            fatalError("Could not initialize Realm form AddNote")
        }
        let repository = AddNoteRepositoryImp(realm: realm)
        
        let validatorProvider = ValidatorProvider()
        let viewModel = AddNoteViewModel(
            repository: repository,
            validatorProvider: validatorProvider,
            navigator: self)
        
        viewController.viewModel = viewModel
        return viewController
    }
}

extension AddNoteContainer: AddNoteNavigator {
    func goToListNotes() {
        appDependencyContainer
            .navigationController
            .popViewController(animated: true)
    }
}
