import SwiftUI

struct FavoritesView: View {
    // Access CartManager from the environment to manage cart and favorites
    @EnvironmentObject var cartManager: CartManager
    // Environment variable to dismiss the view
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                // Header for the Favorites view
                ZStack {
                    HStack {
                        // Back button to dismiss the view
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .bold)) // Set font size and weight
                                .foregroundColor(.black)  // Set icon color to black
                                .padding() // Add padding around the icon
                        }
                        Spacer() // Push back button to the left
                    }
                    // Title of the view
                    Text("Favorites")
                        .font(.headline) // Set font to headline for emphasis
                        .padding(.horizontal)  // Add horizontal padding to avoid touching edges
                }
                .frame(maxWidth: .infinity)  // Ensure the header takes up the full width

                // Content based on the presence of favorite items
                if cartManager.favorites.isEmpty {
                    // Message shown when there are no favorites
                    Text("No favorites yet")
                        .font(.headline) // Set font to headline for emphasis
                        .padding() // Add padding around the text
                } else {
                    // Scrollable list of favorite items
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(cartManager.favorites) { item in
                                // Display each favorite item
                                HStack(alignment: .top, spacing: 10) {
                                    // Item icon
                                    AsyncImage(url: URL(string: item.icon ?? "")) { image in
                                        image.resizable() // Make image resizable
                                            .scaledToFit() // Scale image to fit the frame
                                    } placeholder: {
                                        ProgressView() // Show progress view while loading
                                    }
                                    .frame(width: 80, height: 80) // Set size of the image
                                    .cornerRadius(8) // Round the corners of the image

                                    // Item details
                                    VStack(alignment: .leading) {
                                        Text(item.name ?? "Unknown Item")
                                            .font(.headline) // Set font to headline
                                        Text("₹\(item.price, specifier: "%.2f")")
                                            .font(.subheadline) // Set font to subheadline
                                            .foregroundColor(.gray) // Set text color to gray
                                    }
                                    
                                    Spacer() // Push content to the left

                                    // Actions for each item
                                    VStack {
                                        // Remove from favorites button
                                        Button(action: {
                                            if let index = cartManager.favorites.firstIndex(where: { $0.id == item.id }) {
                                                cartManager.favorites.remove(at: index)
                                            }
                                        }) {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.red) // Set heart icon color to red
                                                .padding(.bottom, 8) // Add padding at the bottom
                                        }
                                        
                                        // Cart management buttons
                                        if let cartItem = cartManager.items.first(where: { $0.item.id == item.id }) {
                                            HStack(spacing: 4) {
                                                // Decrease quantity button
                                                Button(action: {
                                                    if cartItem.quantity > 1 {
                                                        cartManager.removeFromCart(item: item)
                                                    }
                                                }) {
                                                    Image(systemName: "minus")
                                                        .frame(width: 32, height: 32) // Set button size
                                                        .background(Color.orange) // Set background color
                                                        .foregroundColor(.white) // Set text color to white
                                                        .clipShape(RoundedRectangle(cornerRadius: 4)) // Round corners
                                                }

                                                // Quantity display
                                                Text("\(cartItem.quantity)")
                                                    .font(.system(size: 16, weight: .bold)) // Set font size and weight
                                                    .frame(width: 32, height: 32) // Set button size

                                                // Increase quantity button
                                                Button(action: {
                                                    cartManager.addToCart(item: item)
                                                }) {
                                                    Image(systemName: "plus")
                                                        .frame(width: 32, height: 32) // Set button size
                                                        .background(Color.orange) // Set background color
                                                        .foregroundColor(.white) // Set text color to white
                                                        .clipShape(RoundedRectangle(cornerRadius: 4)) // Round corners
                                                }
                                            }
                                        } else {
                                            // Add to cart button if not in cart
                                            Button(action: {
                                                cartManager.addToCart(item: item)
                                            }) {
                                                Text("Add")
                                                    .font(.system(size: 16, weight: .bold)) // Set font size and weight
                                                    .padding(8) // Add padding around the text
                                                    .background(Color.orange) // Set background color
                                                    .foregroundColor(.white) // Set text color to white
                                                    .cornerRadius(4) // Round corners
                                            }
                                        }
                                    }
                                }
                                .padding() // Add padding around each item
                                .background(Color.white) // Set background color to white
                                .cornerRadius(10) // Round corners of the item view
                                .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: 2) // Add shadow effect
                                .padding(.horizontal) // Add horizontal padding around the item view
                            }
                        }
                    }
                }
            }
            .background(Color.white) // Set background color to white
            .ignoresSafeArea(edges: .bottom) // Ignore safe area at the bottom
            .navigationBarHidden(true) // Hide navigation bar
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use stack navigation view style
    }
}

