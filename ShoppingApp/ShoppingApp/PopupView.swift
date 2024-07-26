import SwiftUI

struct PopupView: View {
    // Binding to control the visibility of the popup
    @Binding var showPopup: Bool
    
    // List of categories to display in the popup
    var categories: FetchedResults<Category>
    
    var body: some View {
        VStack(alignment: .center) {
            // Display each category's name
            ForEach(categories, id: \.id) { category in
                Text(category.name ?? "Unknown Category")
                    .font(.caption) // Set text size to small
                    .fontWeight(.bold) // Make text bold
                    .foregroundColor(.black) // Set text color to black
                    .padding(5) // Add padding around the text
            }
        }
        .padding() // Add padding around the VStack
        .background(Color.white) // Set the background color of the popup to white
        .cornerRadius(10) // Round the corners of the popup
        .shadow(radius: 5) // Add shadow for a subtle 3D effect
        .padding(.horizontal) // Add horizontal padding around the popup
    }
}

