import SwiftUI

struct CategoryView: View {
    // Access the Core Data context from the environment
    @Environment(\.managedObjectContext) private var viewContext
    
    // The category to display in this view
    var category: Category
    
    // State variable to track if the category is expanded or not
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Button to toggle expansion of the category
            Button(action: {
                withAnimation {
                    isExpanded.toggle() // Toggle the expanded state with animation
                }
            }) {
                HStack {
                    // Display the category name
                    Text(category.name ?? "Unknown Category")
                        .font(.headline) // Set font to headline for emphasis
                        .foregroundColor(.black) // Set text color to black
                    Spacer()
                    // Display a chevron icon indicating expansion state
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray) // Set icon color to gray
                }
                .padding() // Add padding around the button content
                .background(Color.white) // Set background color of the button to white
                .cornerRadius(10) // Round the corners of the button
                .shadow(radius: 2) // Add a subtle shadow for visual depth
            }
            
            // Display items in the category if expanded
            if isExpanded {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        // Display each item in a horizontal stack
                        ForEach(category.itemsArray, id: \.id) { item in
                            ItemView(item: item)
                                .padding(.horizontal, 8) // Add horizontal padding around each item
                        }
                    }
                    .padding(.horizontal, 8) // Add horizontal padding around the HStack
                }
                .transition(.slide) // Animate the appearance of the scroll view with a slide transition
            }
        }
        .padding(.horizontal) // Add horizontal padding around the VStack
        .background(Color.white) // Ensure the background color is white
    }
}

