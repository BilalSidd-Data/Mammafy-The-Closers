import SwiftUI

struct AddSupplementHeader: View {
    var title: String = "Add Supplement"
    var onCancel: () -> Void
    var onSave: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onCancel) {
                Text("Cancel")
                    .font(.body)
                    .foregroundColor(.sageGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .stroke(Color.sageGreen.opacity(0.3), lineWidth: 1)
                    )
            }
            
            Spacer()
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.darkText)
            
            Spacer()
            
            Button(action: onSave) {
                Text("Save")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.sageGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.sageGreen.opacity(0.1))
                    )
            }
        }
        .padding()
        .background(Color.white)
    }
}
