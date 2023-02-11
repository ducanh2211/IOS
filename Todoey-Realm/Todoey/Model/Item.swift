//
//  Item.swift
//  Todoey
//
//  Created by Đức Anh Trần on 20/12/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    // invert relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}

