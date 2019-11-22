//
//  AddNoteRepositoryImp.swift
//  ChatUI
//
//  Created by Ryan on 11/21/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

struct AddNoteRepositoryImp: AddNoteRepository {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func addNote(title: String?, content: String) -> Completable {
        let note = Note()
        note.title = title
        note.text = content
        note.created = Date()
        
        return Completable.create(subscribe: { completable in
            do {
                try self.realm.write {
                    self.realm.add(note)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        })
    }
    
    
}
