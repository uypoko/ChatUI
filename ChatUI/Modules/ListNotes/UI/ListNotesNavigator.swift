//
//  ListNotesNavigator.swift
//  ChatUI
//
//  Created by Ryan on 11/19/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

protocol ListNotesNavigator {
    func goToWelcome()
    func goToEditNote(note: Note)
    func goToAddNote()
}
