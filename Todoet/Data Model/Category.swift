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
    @objc dynamic var bgColor: String = ""
    let items = List<TodoItem>()
}
