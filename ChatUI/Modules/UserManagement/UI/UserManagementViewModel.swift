//
//  UserManagementViewModel.swift
//  ChatUI
//
//  Created by Ryan on 11/22/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift

class UserManagementViewModel {
    
    var messages: Observable<Result<String, Error>> {
        return messageSubject.asObserver().share()
    }
    
    private let interactor: SignOutInteractor
    private let navigator: UserManagementNavigator
    private let disposeBag = DisposeBag()
    private let messageSubject = PublishSubject<Result<String, Error>>()
    
    init(interactor: SignOutInteractor,
         navigator: UserManagementNavigator) {
        self.interactor = interactor
        self.navigator = navigator
    }
    
    @objc func signOutButtonTapped() {
        interactor.SignOut()
            .subscribe { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .completed:
                    self.navigator.goToWelcome()
                case .error(let error):
                    self.messageSubject.onNext(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
}
