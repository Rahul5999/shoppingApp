import SwiftUI
import Combine

// Manages the cart and favorites for the shopping application
class CartManager: ObservableObject {
    // Published properties to notify views about changes
    @Published var items: [CartItem] = [] // List of items in the cart
    @Published var favorites: [Item] = [] // List of favorite items

    // Helper function to get the quantity of a specific item in the cart
    func quantityForItem(_ item: Item) -> Int {
        // Find the item in the cart and return its quantity, defaulting to 0 if not found
        items.first(where: { $0.item.id == item.id })?.quantity ?? 0
    }

    // Method to add an item to the cart
    func addToCart(item: Item) {
        if let index = items.firstIndex(where: { $0.item.id == item.id }) {
            // If the item is already in the cart, increase its quantity
            items[index].quantity += 1
        } else {
            // If the item is not in the cart, add it with quantity 1
            items.append(CartItem(item: item, quantity: 1))
        }
        updateFavorites() // Update favorites list (if necessary)
    }

    // Method to remove an item from the cart
    func removeFromCart(item: Item) {
        if let index = items.firstIndex(where: { $0.item.id == item.id }) {
            if items[index].quantity > 1 {
                // If more than one, decrease the quantity
                items[index].quantity -= 1
            } else {
                // Otherwise, remove the item from the cart
                items.remove(at: index)
            }
        }
        updateFavorites() // Update favorites list (if necessary)
    }

    // Toggle the favorite status of an item
    func toggleFavorite(item: Item) {
        if favorites.contains(where: { $0.id == item.id }) {
            // If the item is already a favorite, remove it
            favorites.removeAll(where: { $0.id == item.id })
        } else {
            // Otherwise, add it to favorites
            favorites.append(item)
        }
    }

    // Check if an item is marked as favorite
    func isFavorite(item: Item) -> Bool {
        // Return true if the item is in the favorites list
        favorites.contains(where: { $0.id == item.id })
    }

    // Notify observers about changes (used to force update the view)
    private func updateFavorites() {
        objectWillChange.send()
    }
}



