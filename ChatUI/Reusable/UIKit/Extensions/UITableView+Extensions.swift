//
//  UITableView+Extensions.swift
//  ChatUI
//
//  Created by Ryan on 11/19/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit
import RxRealm

extension UITableView {
    func applyChangeset(_ changes: RealmChangeset) {
        beginUpdates()
        deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        reloadRows(at: changes.updated.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        endUpdates()
    }
}
