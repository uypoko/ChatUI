//
//  EditNoteRepository.swift
//  ChatUI
//
//  Created by Ryan on 11/20/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

protocol EditNoteRepository {
    func changeTitle(to title: String?, id: String)
    func changeContent(to content: String, id: String)
    func deleteNote(id: String)
}
