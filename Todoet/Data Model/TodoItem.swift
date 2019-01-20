//
//  TodoItem.swift
//  Todoet
//
//  Created by KirillGladkov on 1/16/19.
//  Copyright © 2019 KirillGladkov. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
