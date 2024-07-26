import SwiftUI

struct BackgroundGradientView: View {
    var body: some View {
        // Create a linear gradient background
        LinearGradient(
            gradient: Gradient(colors: [Color.yellow, Color.orange]), // Define the gradient colors from yellow to orange
            startPoint: .top, // Start gradient from the top
            endPoint: .bottom // End gradient at the bottom
        )
        .ignoresSafeArea(edges: .top) // Extend the gradient to the top edge of the screen, ignoring safe area insets
    }
}

