import SwiftUI

struct AddSupplementButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Supplement")
            }
            .font(.headline)
            .foregroundColor(.sageGreen)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.sageGreen.opacity(0.2))
            .cornerRadius(16)
        }
        .padding(.horizontal)
    }
}
 
