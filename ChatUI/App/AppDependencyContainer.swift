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
    var userSession: UserSession?
    var remoteDatabase: Firestore { Firestore.firestore() }
    var remoteStorage: StorageReference { Storage.storage().reference() }
    var auth: Auth { Auth.auth() }
    let navigationController = UINavigationController()
    let validator = Validator()
    let localRepository = LocalRepositoryImp()
    
    private let disposeBag = DisposeBag()
    
    func constructRootViewController() -> UIViewController {
        var rootViewController: UIViewController = WelcomeContainer(appDependencyContainer: self).makeWelcomeViewController()
        
        loadUserSession()
            .subscribe(onCompleted: {
                //rootViewController = self.constructSignedInTabBarViewController()
            })
            .disposed(by: disposeBag)
        
        navigationController.addChild(rootViewController)
        return navigationController
    }
    
    func constructSignedInTabBarViewController() -> UITabBarController {
        let tabBarController = UITabBarController()
        return tabBarController
    }
    
    func loadUserSession() -> Completable {
        return Completable.create(subscribe: { completable in
            let disposables = Disposables.create()
            
            self.localRepository.fetchUserSession()
                .subscribe(
                    onSuccess: { userSession in
                        self.userSession = userSession
                        completable(.completed)
                    },
                    onError: { completable(.error($0)) }
                    )
                .disposed(by: self.disposeBag)
            
            return disposables
        })
    }
}
