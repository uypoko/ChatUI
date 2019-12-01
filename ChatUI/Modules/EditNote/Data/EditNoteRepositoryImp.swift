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
        guard let note = realm.object(ofType: Note.self, forPrimaryKey: id) else { return }
        try? realm.write {
            note.title = title
        }
    }
    
    func changeContent(to content: String, id: String) {
        guard let note = realm.object(ofType: Note.self, forPrimaryKey: id) else { return }
        try? realm.write {
            note.text = content
        }
    }
    
    func deleteNote(id: String) {
        guard let note = realm.object(ofType: Note.self, forPrimaryKey: id) else { return }
        try? realm.write {
            realm.delete(note)
        }
    }
}
