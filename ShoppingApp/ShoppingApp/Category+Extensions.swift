//
//  Category+Extensions.swift
//  ShoppingApp
//
//  Created by user261757 on 7/24/24.
//

import Foundation
import CoreData

extension Category {
    // Computed property to convert the 'items' relationship (NSSet) to a sorted array of 'Item' objects
    var itemsArray: [Item] {
        // Convert the 'items' NSSet to a Set of 'Item' objects, or an empty set if nil
        let set = items as? Set<Item> ?? []
        // Sort the items by their 'id' attribute and return the array
        return set.sorted { $0.id < $1.id }
    }
}

