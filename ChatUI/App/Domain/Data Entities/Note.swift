//
//  Note.swift
//  ChatUI
//
//  Created by Ryan on 11/18/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import RealmSwift

@objcMembers class Note: Object {
    dynamic var id = UUID().uuidString
    dynamic var userId = ""
    dynamic var title: String?
    dynamic var text = ""
    dynamic var created = Date(timeIntervalSince1970: 0)
    
    override static func primaryKey() -> String? { return "id" }
}
