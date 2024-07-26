import SwiftUI
import Combine

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager // Access to CartManager to manage cart and favorites
    @Environment(\.presentationMode) var presentationMode // Access to the presentation mode to dismiss the view

    @State private var couponCode: String = "" // State to store the entered coupon code
    @State private var discount: Double = 0 // State to store the applied discount
    @State private var showPopup: Bool = false // State to show/hide popup messages
    @State private var popupMessage: String = "" // State to store the popup message
    
    // Calculate subtotal of items in the cart
    private var subtotal: Double {
        cartManager.items.reduce(0) { $0 + ($1.item.price * Double($1.quantity)) }
    }

    // Calculate total after applying discount
    private var total: Double {
        subtotal - discount
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    // Navigation bar with back button and title
                    ZStack {
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss() // Dismiss the view
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            Spacer()
                        }
                        Text("Cart")
                            .font(.headline)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)

                    // Display message if cart is empty
                    if cartManager.items.isEmpty {
                        Text("Your cart is empty")
                            .font(.headline)
                            .padding()
                    } else {
                        // Display items in the cart
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(cartManager.items) { cartItem in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(alignment: .top) {
                                        // Display item image
                                        AsyncImage(url: URL(string: cartItem.item.icon ?? "")) { image in
                                            image.resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            ProgressView() // Show loading indicator while image is loading
                                        }
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                        
                                        VStack(alignment: .leading) {
                                            // Display item name and price
                                            Text(cartItem.item.name ?? "Unknown Item")
                                                .font(.headline)
                                            Text("₹\(cartItem.item.price, specifier: "%.2f")")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        VStack(spacing: 4) {
                                            HStack(spacing: 4) {
                                                // Button to decrease item quantity
                                                Button(action: {
                                                    cartManager.removeFromCart(item: cartItem.item)
                                                }) {
                                                    Image(systemName: "minus")
                                                        .frame(width: 24, height: 24)
                                                        .background(Color.orange)
                                                        .foregroundColor(.white)
                                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                                }
                                                
                                                // Display item quantity
                                                Text("\(cartItem.quantity)")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .frame(width: 24, height: 24)
                                                
                                                // Button to increase item quantity
                                                Button(action: {
                                                    cartManager.addToCart(item: cartItem.item)
                                                }) {
                                                    Image(systemName: "plus")
                                                        .frame(width: 24, height: 24)
                                                        .background(Color.orange)
                                                        .foregroundColor(.white)
                                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                                }
                                            }
                                        }
                                    }
                                    // Display total price for the item
                                    Text("Total: ₹\(cartItem.item.price * Double(cartItem.quantity), specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: 2)
                                .padding(.horizontal)
                            }
                        }
                    }

                    // Display subtotal, discount, and total
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Subtotal:")
                                Text("Discount:")
                                Text("Total:")
                            }
                            .font(.headline)
                            .padding(.leading, 16)

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text("₹\(subtotal, specifier: "%.2f")")
                                Text("₹\(discount, specifier: "%.2f")")
                                Text("₹\(total, specifier: "%.2f")")
                            }
                            .font(.headline)
                            .padding(.trailing, 16)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: -2)
                        .padding(.horizontal)
                        .padding(.bottom, 8)

                        // Coupon code input and apply button
                        HStack {
                            TextField("Enter coupon code", text: $couponCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .background(Color.white)
                                .cornerRadius(5)
                            
                            Button(action: {
                                applyCouponCode() // Apply coupon code
                            }) {
                                Text("Apply")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)

                        // Checkout button
                        Button(action: {
                            // Handle checkout action
                        }) {
                            Text("CheckOut")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    }
                }
                .background(Color.white)
                .ignoresSafeArea(edges: .bottom)
                .onAppear {
                    // Handle keyboard appearance and adjust the view
                    NotificationCenter.default.addObserver(
                        forName: UIResponder.keyboardWillShowNotification,
                        object: nil,
                        queue: .main
                    ) { notification in
                        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            let keyboardHeight = keyboardFrame.height
                            DispatchQueue.main.async {
                                withAnimation {
                                    // Adjust the view based on keyboard height
                                }
                            }
                        }
                    }
                    
                    NotificationCenter.default.addObserver(
                        forName: UIResponder.keyboardWillHideNotification,
                        object: nil,
                        queue: .main
                    ) { _ in
                        DispatchQueue.main.async {
                            withAnimation {
                                // Reset view adjustment when keyboard hides
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true) // Hide the navigation bar
    }
    
    // Function to apply the coupon code
    private func applyCouponCode() {
        let validCoupons = ["FIRSTTIME", "SAVE20", "FREESHIP"]
        
        if validCoupons.contains(couponCode.uppercased()) {
            // Apply a discount based on the coupon
            switch couponCode.uppercased() {
            case "FIRSTTIME":
                discount = subtotal * 0.10
            case "SAVE20":
                discount = subtotal * 0.20
            case "FREESHIP":
                discount = subtotal * 0.15
            default:
                discount = 0
            }
            popupMessage = "Coupon applied successfully!"
            showPopup = true
        } else {
            popupMessage = "No such coupon exists"
            showPopup = true
        }
    }
}

