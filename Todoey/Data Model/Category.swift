//
//  Category.swift
//  Todoey
//
//  Created by Frank Mortensen on 04/07/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
