//
//  Task.swift
//  TaskList
//
//  Created by Jigisha Patel on 2019-09-26.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation
class Task {
    var title: String
    var subtitle: String
    var done: Bool
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.done = false
    }
}

