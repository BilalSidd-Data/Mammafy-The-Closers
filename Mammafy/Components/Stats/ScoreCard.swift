import SwiftUI

struct ScoreCard: View {
    let score: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.sageGreen)
                Text("Score")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            
            ZStack {
                Circle()
                    .stroke(Color.sageGreen.opacity(0.1), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100.0)
                    .stroke(Color.sageGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                Text("\(score)%")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.darkText)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
