import SwiftUI

struct ProgressSection: View {
    var takenCount: Int = 0
    var totalCount: Int = 0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Your Progress")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text("\(takenCount)/\(totalCount) Taken")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.darkText)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.sageGreen.opacity(0.3), lineWidth: 8)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: totalCount > 0 ? CGFloat(takenCount) / CGFloat(totalCount) : 0)
                    .stroke(Color.sageGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
