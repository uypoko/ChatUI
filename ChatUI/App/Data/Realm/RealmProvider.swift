//
//  RealmProvider.swift
//  ChatUI
//
//  Created by Ryan on 11/18/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RealmSwift

enum ConfigType {
    case bundleNotes
    case libraryNotes
}

class RealmProvider {
    private let pathProvider: PathProvider
    private let configType: ConfigType
    
    init(pathProvider: PathProvider, configType: ConfigType) {
        self.pathProvider = pathProvider
        self.configType = configType
    }
    
    private var libraryConfig: Realm.Configuration? {
        guard let fileURL = try? pathProvider.inLibrary("notes.realm") else { return nil }
        return Realm.Configuration(
            fileURL: fileURL,
            schemaVersion: 1,
            deleteRealmIfMigrationNeeded: true,
            objectTypes: [Note.self])
    }
    
    private var bundledConfig: Realm.Configuration? {
        return Realm.Configuration(
            fileURL: try? pathProvider.inBundle("bundledNotes.realm"),
            readOnly: true,
            objectTypes: [Note.self])
    }
    
    var realm: Realm? {
        switch configType {
        case .libraryNotes:
            guard let libraryConfig = libraryConfig else { return nil }
            return try? Realm(configuration: libraryConfig)
        case .bundleNotes:
            guard let bundledConfig = bundledConfig else { return nil }
            return try? Realm(configuration: bundledConfig)
        }
    }
}
