//
//  ListNotesRepository.swift
//  ChatUI
//
//  Created by Ryan on 11/19/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import RealmSwift
import RxSwift

protocol ListNotesRepository {
    func fetchNotes() -> Results<Note>
}
