//
//  Task.swift
//  TaskList
//
//  Created by Kevin Grzela on 2019-10-12.
//  Copyright © 2019 KG. All rights reserved.
//

import Foundation

public class Task {
    var title: String!
    var subtitle: String!
    var done: Bool
    
    init?(title:String, subtitle:String){
        self.title = title
        self.subtitle = subtitle
        self.done = false
    }
}
