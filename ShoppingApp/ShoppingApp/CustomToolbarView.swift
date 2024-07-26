import SwiftUI

struct CustomToolbarView: View {
    // Access CartManager from the environment for managing cart operations
    @EnvironmentObject var cartManager: CartManager
    
    // Bindings for controlling the visibility of the cart and search text
    @Binding var showCart: Bool
    @Binding var searchText: String
    
    // State variable to manage the visibility of the favorites view
    @State private var showFavorites: Bool = false

    var body: some View {
        HStack {
            // Menu button (currently without action)
            Button(action: {
                // Menu action
            }) {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(.black) // Set menu icon color to black
            }
            
            // Title of the store
            Text("My store")
                .font(.headline) // Set font to headline for emphasis
                .foregroundColor(.black) // Set text color to black
                .padding(.leading, 10) // Add padding to the leading side
            
            Spacer() // Push elements to the edges
            
            // Search bar for filtering content
            SearchBar(text: $searchText)
                .frame(width: 150) // Adjust the width of the search bar
                .padding(.horizontal, 10) // Adjust horizontal padding around the search bar

            HStack(spacing: 20) {
                // Favorites button to toggle the display of the FavoritesView
                Button(action: {
                    showFavorites.toggle() // Toggle visibility of FavoritesView
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(.black) // Set heart icon color to black
                }
                .fullScreenCover(isPresented: $showFavorites) {
                    FavoritesView()
                        .environmentObject(cartManager) // Pass CartManager to FavoritesView
                }

                // Cart button to toggle the display of the cart
                Button(action: {
                    showCart.toggle() // Toggle visibility of the cart
                }) {
                    ZStack(alignment: .topTrailing) {
                        // Cart icon
                        Image(systemName: "cart")
                            .foregroundColor(.black) // Set cart icon color to black

                        // Display item count badge if there are items in the cart
                        if cartManager.items.count > 0 {
                            Text("\(cartManager.items.count)")
                                .font(.caption2) // Set font size to caption2
                                .foregroundColor(.white) // Set text color to white
                                .padding(5) // Add padding around the text
                                .background(Color.red) // Set badge background color to red
                                .clipShape(Circle()) // Clip the badge into a circle shape
                                .offset(x: 10, y: -10) // Position the badge at the top-right corner
                        }
                    }
                }
            }
        }
        .padding() // Add padding around the entire HStack
        .background(Color.clear) // Set background color to clear (transparent)
    }
}

