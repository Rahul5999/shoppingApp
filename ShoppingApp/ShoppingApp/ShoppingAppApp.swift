import SwiftUI

@main
struct ShoppingApp: App {
    // Create a single instance of DataController to manage Core Data operations
    @StateObject private var dataController = DataController()
    
    // Create a single instance of CartManager to handle cart operations
    @StateObject private var cartManager = CartManager()
    
    var body: some Scene {
        WindowGroup {
            // The main content view of the app
            ContentView()
                // Provide the Core Data context to the ContentView and its descendants
                .environment(\.managedObjectContext, dataController.container.viewContext)
                // Provide the CartManager instance to the ContentView and its descendants
                .environmentObject(cartManager)
                .onAppear {
                    // Load JSON data into Core Data if it hasn't been loaded before
                    dataController.loadJsonDataIfNeeded()
                }
        }
    }
}

