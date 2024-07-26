import SwiftUI

struct ContentView: View {
    // Access the Core Data context from the environment
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch categories from Core Data, sorted by name in ascending order
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>

    // State variables for managing search text, popup visibility, and cart visibility
    @State private var searchText: String = ""
    @State private var showPopup: Bool = false
    @State private var showCart: Bool = false
    @StateObject private var cartManager = CartManager()
    @State private var filteredCategories: [Category] = []

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient view
                BackgroundGradientView()
                
                VStack {
                    // Custom toolbar with search and cart functionality
                    CustomToolbarView(showCart: $showCart, searchText: $searchText)
                        .environmentObject(cartManager)
                    
                    VStack {
                        ScrollView {
                            // Display each category in a vertical scroll view
                            ForEach(filteredCategories, id: \.id) { category in
                                CategoryView(category: category)
                                    .padding(.top, 10)
                            }
                        }
                        .background(Color.white)
                    }
                }
                
                // Display a semi-transparent overlay when the popup is shown
                if showPopup {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    Spacer()
                    
                    // Display the popup view with animation
                    if showPopup {
                        PopupView(showPopup: $showPopup, categories: categories)
                            .transition(.move(edge: .bottom))
                            .padding(.bottom, 50)
                    }
                    
                    HStack {
                        Spacer()
                        // Button to toggle the visibility of the popup
                        Button(action: {
                            withAnimation {
                                showPopup.toggle()
                            }
                        }) {
                            if showPopup {
                                // Button to close the popup
                                Image(systemName: "xmark")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            } else {
                                // Button to show the popup
                                Text("Categories")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .frame(width: 150)
                            }
                        }
                        .padding()
                        Spacer()
                    }
                }
            }
            // Hide the default navigation bar
            .navigationBarHidden(true)
            // Navigate to the CartView when showCart is true
            .background(
                NavigationLink(destination: CartView().environmentObject(cartManager), isActive: $showCart) {
                    EmptyView()
                }
            )
            // Initialize filtered categories when the view appears
            .onAppear {
                filteredCategories = Array(categories)
            }
            // Filter categories based on the search text
            .onChange(of: searchText) { newValue in
                filterCategories()
            }
        }
        .environmentObject(cartManager)
    }
    
    // Function to filter categories based on the search text
    private func filterCategories() {
        if searchText.isEmpty {
            filteredCategories = Array(categories)
        } else {
            filteredCategories = categories.filter { category in
                // Check if the category name or any item's name matches the search text
                let matchesCategoryName = category.name?.localizedCaseInsensitiveContains(searchText) ?? false
                let matchesItemName = category.items?.contains { item in
                    (item as? Item)?.name?.localizedCaseInsensitiveContains(searchText) ?? false
                } ?? false
                return matchesCategoryName || matchesItemName
            }
        }
    }
}

