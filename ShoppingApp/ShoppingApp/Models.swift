import Foundation

// Represents the main data structure for the shopping data
struct ShoppingData: Codable {
    // Indicates whether the data retrieval was successful
    let status: Bool
    
    // Message associated with the data retrieval
    let message: String
    
    // Optional error message if something went wrong
    let error: String?
    
    // List of categories in the shopping data
    let categories: [CategoryData]
}

// Represents a single category in the shopping data
struct CategoryData: Codable {
    // Unique identifier for the category
    let id: Int64
    
    // Name of the category
    let name: String
    
    // List of items within this category
    let items: [ItemData]
}

// Represents a single item within a category
struct ItemData: Codable {
    // Unique identifier for the item
    let id: Int64
    
    // Name of the item
    let name: String
    
    // Icon associated with the item
    let icon: String
    
    // Price of the item
    let price: Double
}

// Represents an item in the cart with its quantity
struct CartItem: Identifiable {
    var id: UUID = UUID() // Unique identifier for CartItem
    var item: Item // The item being represented
    var quantity: Int // Quantity of the item in the cart
}
