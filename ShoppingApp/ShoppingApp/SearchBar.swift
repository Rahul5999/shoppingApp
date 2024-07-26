import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String // Binding to hold the text entered in the search bar
    
    // Coordinator class to handle UISearchBarDelegate methods
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text // Initialize the binding
        }
        
        // Update the text binding when the search bar text changes
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        // Dismiss the keyboard when the return key is tapped
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
        
        // Clear the search text and dismiss the keyboard when the cancel button is tapped
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
            searchBar.resignFirstResponder()
        }
    }
    
    // Create and return the coordinator
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    // Create and configure the UISearchBar
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none // Disable autocapitalization
        searchBar.searchBarStyle = .minimal // Use minimal style to avoid borders
        searchBar.backgroundImage = UIImage() // Remove background image
        searchBar.layer.borderWidth = 0 // Remove border width
        return searchBar
    }
    
    // Update the UISearchBar with the current text value
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

