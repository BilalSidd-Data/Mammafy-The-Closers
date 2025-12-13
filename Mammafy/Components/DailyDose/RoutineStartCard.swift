import SwiftUI

struct RoutineStartCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "list.clipboard.fill")
                .font(.system(size: 40))
                .foregroundColor(.sageGreen)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.sageGreen, lineWidth: 2)
                )
            
            Text("Start Your Routine")
                .font(.headline)
                .foregroundColor(.darkText)
            
            Text("Add your prenatal vitamins and\nsupplements to get reminder and\ntrack your progress")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}
