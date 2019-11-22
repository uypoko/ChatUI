//
//  EditNoteRepositoryImp.swift
//  ChatUI
//
//  Created by Ryan on 11/20/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import RealmSwift

struct EditNoteRepositoryImp: EditNoteRepository {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func changeTitle(to title: String?, id: String) {
        let predicate = NSPredicate(format: "id = %@", id)
        guard let result = realm.objects(Note.self).filter(predicate).first else { return }
        try? realm.write {
            result.title = title
        }
    }
    
    func changeContent(to content: String, id: String) {
        let predicate = NSPredicate(format: "id = %@", id)
        guard let result = realm.objects(Note.self).filter(predicate).first else { return }
        try? realm.write {
            result.text = content
        }
    }
    
    func deleteNote(id: String) {
        let predicate = NSPredicate(format: "id = %@", id)
        guard let result = realm.objects(Note.self).filter(predicate).first else { return }
        try? realm.write {
            realm.delete(result)
        }
    }
}
