//
//  AppDependencyContainer.swift
//  ChatUI
//
//  Created by Ryan on 11/8/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Firebase

class AppDependencyContainer {
    // MARK: Long-lived dependencies
    var remoteDatabase: Firestore { Firestore.firestore() }
    var remoteStorage: StorageReference { Storage.storage().reference() }
    var auth: Auth { Auth.auth() }
    let userSessionRepository = UserSessionRepositoryImp()
    let userSessionSubject: BehaviorSubject<UserSession?> = BehaviorSubject<UserSession?>(value: nil)
    let pathProvider = PathProvider()
    
    weak var window: UIWindow?
    var rootNavigationController = UINavigationController() {
        didSet {
            window?.rootViewController = rootNavigationController
            window?.makeKeyAndVisible()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    func loadUserSession() {
        userSessionRepository.fetchUserSession()
            .subscribe(
                onSuccess: { userSession in
                    self.userSessionSubject.onNext(userSession)
                    if userSession != nil {
                        self.rootNavigationController = self.constructSignedInTabBarRootView()
                    } else {
                        self.rootNavigationController = self.constructWelcomeRootView()
                    }
                },
                onError: { error in
                    self.userSessionSubject.onNext(nil)
                })
            .disposed(by: self.disposeBag)
        
    }
    
    func constructWelcomeRootView() -> UINavigationController {
        let welcomeContainer = WelcomeContainer(appDependencyContainer: self)
        let welcomeVC = welcomeContainer.makeWelcomeViewController()
        
        return UINavigationController(rootViewController: welcomeVC)
    }
    
    func constructSignedInTabBarRootView() -> UINavigationController {
        let tabBarController = UITabBarController()
        
        let listNotesContainer = ListNotesContainer(appDependencyContainer: self)
        let listNotesVC = listNotesContainer.constructListNotesViewController()
        let listNotesIcon = UIImage(named: "baseline_list_black_36pt")
        listNotesVC.tabBarItem = UITabBarItem(title: nil, image: listNotesIcon, tag: 0)
        
        let userManagementContainer = UserManagementContainer(appDependencyContainer: self)
        let userManagementVC = userManagementContainer.constructUserManagementViewController()
        let userManagementIcon = UIImage(named: "baseline_account_circle_black_36pt")
        userManagementVC.tabBarItem = UITabBarItem(title: nil, image: userManagementIcon, tag: 1)
        
        tabBarController.viewControllers = [listNotesVC, userManagementVC]
        
        return UINavigationController(rootViewController: tabBarController)
    }
    
}
