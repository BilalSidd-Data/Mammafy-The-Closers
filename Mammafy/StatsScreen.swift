import SwiftUI

struct StatsScreen: View {
    @ObservedObject var manager = SupplementManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Progress")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.darkText)
                    Spacer()
                    // Battery/Network icons are status bar, not needed here
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Top Cards (Streak & Score)
                HStack(spacing: 16) {
                    StatsCard(
                        icon: "flame.fill",
                        iconColor: .orange,
                        title: "Streak",
                        value: "\(manager.currentStreak)",
                        subtitle: "Days"
                    )
                    .id(UUID()) // Hack to force redraw if manager updates aren't caught deep down
                    
                    ScoreCard(score: manager.adherenceScore)
                }
                .padding(.horizontal)
                
                // Last 7 Days
                Last7DaysCard()
                
                // Last 30 Days
                Last30DaysCard()
                
                Spacer().frame(height: 100)
            }
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    StatsScreen()
}
