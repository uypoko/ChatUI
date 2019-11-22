//
//  ListNotesRepositoryImp.swift
//  ChatUI
//
//  Created by Ryan on 11/19/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import RealmSwift
import RxRealm
import RxSwift

struct ListNotesRepositoryImp: ListNotesRepository {
    
    let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func fetchNotes() -> Results<Note> {
        let sortedNotes = realm.objects(Note.self)
            .sorted(byKeyPath: "created", ascending: false)
        return sortedNotes
    }
    
}
