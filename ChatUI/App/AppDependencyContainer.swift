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
    let navigationController = UINavigationController()
    let localRepository = LocalRepositoryImp()
    let userSessionSubject: BehaviorSubject<UserSession?> = BehaviorSubject<UserSession?>(value: nil)
    let pathProvider = PathProvider()
    
    private let disposeBag = DisposeBag()
    
    func constructRootViewController() -> UIViewController {
        var rootViewController: UIViewController = WelcomeContainer(appDependencyContainer: self).makeWelcomeViewController()
        
        loadUserSession()
            .subscribe(onCompleted: {
                rootViewController = self.constructSignedInTabBarViewController()
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(rootViewController, animated: false)
        return navigationController
    }
    
    func constructSignedInTabBarViewController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let listNotesContainer = ListNotesContainer(appDependencyContainer: self)
        let listNotesVC = listNotesContainer.constructListNotesViewController()
        
        tabBarController.viewControllers = [listNotesVC]
        return tabBarController
    }
    
    func loadUserSession() -> Completable {
        return Completable.create(subscribe: { completable in
            let disposables = Disposables.create()
            
            self.localRepository.fetchUserSession()
                .subscribe(
                    onSuccess: { userSession in
                        self.userSessionSubject.onNext(userSession)
                        completable(.completed)
                    },
                    onError: { error in
                        self.userSessionSubject.onNext(nil)
                        completable(.error(error))
                    })
                .disposed(by: self.disposeBag)
            
            return disposables
        })
    }
}
