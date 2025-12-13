import SwiftUI

struct PregnancyInfoCard: View {
    @ObservedObject var manager = PregnancyManager.shared
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Week \(manager.currentWeek)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.sageGreen)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Baby is the size of a")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(manager.currentBabySize)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.darkText)
                }
                
                Text(dateString)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                    .padding(.top, 4)
                
                Text("Next dose in: Check your schedule!")
                    .font(.caption)
                    .foregroundColor(.sageGreen)
                    .padding(.top, 4)
            }
            
            Spacer()
            
            Image(systemName: manager.currentBabySymbol)
                .font(.system(size: 50))
                .foregroundColor(.sageGreen)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}
