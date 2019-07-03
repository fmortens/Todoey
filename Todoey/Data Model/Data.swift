//
//  Data.swift
//  Todoey
//
//  Created by Frank Mortensen on 03/07/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}
