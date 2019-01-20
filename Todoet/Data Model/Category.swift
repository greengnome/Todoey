//
//  Category.swift
//  Todoet
//
//  Created by KirillGladkov on 1/16/19.
//  Copyright © 2019 KirillGladkov. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<TodoItem>()
}
