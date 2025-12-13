import SwiftUI

struct NextVisitHeader: View {
    var body: some View {
        HStack {
            Text("Next Visit")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.darkText)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
