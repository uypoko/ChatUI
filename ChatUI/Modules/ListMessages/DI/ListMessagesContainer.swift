//
//  ListMessagesContainer.swift
//  ChatUI
//
//  Created by Ryan on 11/10/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

class ListMessagesContainer {
    let appDependencyContainer: AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func makeListMessagesViewController() -> ListMessagesViewController? {
        let storyboard = UIStoryboard(name: "ListMessages", bundle: nil)
        let listMessagesVC = storyboard.instantiateInitialViewController() as? ListMessagesViewController
        return listMessagesVC
    }
}
