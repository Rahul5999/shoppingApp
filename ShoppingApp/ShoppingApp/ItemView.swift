import SwiftUI

struct ItemView: View {
    var item: Item // The item to be displayed
    @State private var isLoved: Bool = false // Track if the item is marked as favorite (not used in this code but could be for future use)
    @State private var quantity: Int = 0 // Track the quantity of the item in the cart
    @EnvironmentObject var cartManager: CartManager // Access to CartManager to manage cart and favorites

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Main content of the item view
            VStack(alignment: .leading, spacing: 4) {
                // Display item image
                AsyncImage(url: URL(string: item.icon ?? "")) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView() // Show a loading indicator while the image is loading
                }
                .frame(height: 80) // Set fixed height for the image
                .cornerRadius(8) // Round the corners of the image

                // Display item name
                Text(item.name ?? "Unknown Item")
                    .font(.system(size: 14, weight: .bold)) // Set font size and weight
                    .lineLimit(2) // Limit the text to 2 lines
                    .frame(height: 40, alignment: .leading) // Set fixed height and align text to leading
                    .fixedSize(horizontal: false, vertical: true) // Prevent truncation

                HStack {
                    // Display item price
                    Text("₹\(item.price, specifier: "%.2f")")
                        .font(.system(size: 12)) // Set font size
                        .foregroundColor(.gray) // Set text color to gray

                    Spacer() // Push content to the right

                    // Show quantity controls if quantity is greater than 0
                    if quantity > 0 {
                        HStack(spacing: 4) {
                            // Decrease quantity button
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    if quantity > 0 {
                                        quantity -= 1 // Decrease quantity
                                        cartManager.removeFromCart(item: item) // Remove from cart
                                    }
                                }
                            }) {
                                Image(systemName: "minus") // Minus symbol
                                    .frame(width: 24, height: 24) // Set button size
                                    .background(Color.orange) // Set background color
                                    .foregroundColor(.white) // Set text color
                                    .clipShape(RoundedRectangle(cornerRadius: 4)) // Round corners
                            }

                            // Display current quantity
                            Text("\(quantity)")
                                .font(.system(size: 14, weight: .bold)) // Set font size and weight
                                .frame(width: 24, height: 24) // Set button size

                            // Increase quantity button
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    quantity += 1 // Increase quantity
                                    cartManager.addToCart(item: item) // Add to cart
                                }
                            }) {
                                Image(systemName: "plus") // Plus symbol
                                    .frame(width: 24, height: 24) // Set button size
                                    .background(Color.orange) // Set background color
                                    .foregroundColor(.white) // Set text color
                                    .clipShape(RoundedRectangle(cornerRadius: 4)) // Round corners
                            }
                        }
                    } else {
                        // Add button if item is not in the cart
                        Button(action: {
                            withAnimation(.easeInOut) {
                                quantity = 1 // Set initial quantity
                                cartManager.addToCart(item: item) // Add to cart
                            }
                        }) {
                            Text("Add")
                                .font(.system(size: 14, weight: .bold)) // Set font size and weight
                                .padding(4) // Add padding
                                .background(Color.orange) // Set background color
                                .foregroundColor(.white) // Set text color
                                .cornerRadius(4) // Round corners
                        }
                    }
                }
            }
            .padding(8) // Add padding around the content
            .background(Color.white) // Set background color
            .cornerRadius(10) // Round corners
            .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: 2) // Add shadow
            .frame(width: 160, height: 180) // Set fixed width and height

            // Favorite button
            Button(action: {
                withAnimation(.spring()) {
                    cartManager.toggleFavorite(item: item) // Toggle favorite status
                }
            }) {
                Image(systemName: cartManager.isFavorite(item: item) ? "heart.fill" : "heart") // Show filled or empty heart
                    .foregroundColor(cartManager.isFavorite(item: item) ? .red : .gray) // Set color based on favorite status
                    .padding(8) // Add padding around the icon
                    .scaleEffect(cartManager.isFavorite(item: item) ? 1.2 : 1.0) // Animate scaling effect
                    .rotationEffect(Angle(degrees: cartManager.isFavorite(item: item) ? 360 : 0)) // Optional rotation effect
            }
            .buttonStyle(PlainButtonStyle()) // Use plain button style for the button
        }
        .onAppear {
            quantity = cartManager.quantityForItem(item) // Initialize quantity when the view appears
        }
    }
}

