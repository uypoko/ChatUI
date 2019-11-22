//
//  AddNoteRepository.swift
//  ChatUI
//
//  Created by Ryan on 11/21/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//
import RxSwift

protocol AddNoteRepository {
    func addNote(title: String?, content: String) -> Completable
}
