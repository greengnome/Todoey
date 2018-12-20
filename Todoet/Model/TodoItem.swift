//
//  TodoItem.swift
//  Todoet
//
//  Created by KirillGladkov on 12/20/18.
//  Copyright © 2018 KirillGladkov. All rights reserved.
//

import Foundation

class TodoItem {
    var done: Bool = false
    var title: String? = nil
    
    init(text: String) {
        self.done = false
        self.title = text
    }
    
    init(text: String, isDone: Bool) {
        self.done = isDone
        self.title = text
    }
}
