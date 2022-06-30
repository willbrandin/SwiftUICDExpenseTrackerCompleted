//
//  World.swift
//  ExpenseTracker
//
//  Created by Will Brandin on 6/30/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation

/// How to Control the World
///
/// https://www.pointfree.co/blog/posts/21-how-to-control-the-world
let Current = World()

struct World {
    var calendar: () -> Calendar = { Calendar.current }
}
