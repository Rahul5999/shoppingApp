import Foundation
import CoreData

// DataController class to manage Core Data operations
class DataController: ObservableObject {
    // Persistent container to manage Core Data stack
    let container = NSPersistentContainer(name: "ShoppingApp")
    
    // Initializer to load persistent stores
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                // Handle error if the persistent store fails to load
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    // Function to load JSON data if it hasn't been loaded before
    func loadJsonDataIfNeeded() {
        let defaults = UserDefaults.standard
        // Check if data has already been loaded
        if !defaults.bool(forKey: "isDataLoaded") {
            loadJsonData()
            defaults.set(true, forKey: "isDataLoaded")
        }
    }

    // Private function to load JSON data from the app bundle
    private func loadJsonData() {
        // Get the URL of the JSON file in the app bundle
        if let url = Bundle.main.url(forResource: "shopping", withExtension: "json") {
            do {
                // Read the data from the file
                let data = try Data(contentsOf: url)
                // Create a JSONDecoder to decode the data
                let decoder = JSONDecoder()
                // Decode the data into a ShoppingData object
                let shoppingData = try decoder.decode(ShoppingData.self, from: data)
                // Save the decoded data to Core Data
                saveToCoreData(shoppingData: shoppingData)
            } catch {
                // Handle error if the JSON data fails to load
                print("Failed to load JSON data: \(error)")
            }
        }
    }
    
    // Private function to save the decoded data to Core Data
    private func saveToCoreData(shoppingData: ShoppingData) {
        let context = container.viewContext
        
        // Iterate through categories in the shopping data
        for categoryData in shoppingData.categories {
            // Create a new Category object in the context
            let category = Category(context: context)
            category.id = categoryData.id
            category.name = categoryData.name
            
            // Iterate through items in the category
            for itemData in categoryData.items {
                // Create a new Item object in the context
                let item = Item(context: context)
                item.id = itemData.id
                item.name = itemData.name
                item.icon = itemData.icon
                item.price = itemData.price
                // Set the relationship between item and category
                item.category = category
            }
        }
        
        do {
            // Save the context to persist the data
            try context.save()
        } catch {
            // Handle error if the context fails to save
            print("Failed to save data to Core Data: \(error)")
        }
    }
}

