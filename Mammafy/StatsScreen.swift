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

// MARK: - Components

struct StatsCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let subtitle: String?
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 40, weight: .medium, design: .rounded))
                .foregroundColor(.darkText)
            
            if let sub = subtitle {
                Text(sub)
                    .font(.caption)
                    .foregroundColor(.gray)
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

struct Last7DaysCard: View {
    @ObservedObject var manager = SupplementManager.shared
    
    var days: [Date] {
        let calendar = Calendar.current
        let today = Date()
        var dates: [Date] = []
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -6 + i, to: today) {
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Last 7 Days")
                .font(.headline)
                .foregroundColor(.darkText)
            
            // Legend
            HStack(spacing: 16) {
                LegendItem(color: .sageGreen, text: "Taken")
                LegendItem(color: .yellow, text: "Late")
                LegendItem(color: .red, text: "Missed")
            }
            
            // Days Chart
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { date in
                    VStack(spacing: 12) {
                        Text(dateFormatter.string(from: date))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        StatusDot(date: date)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(text)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct StatusDot: View {
    let date: Date
    @ObservedObject var manager = SupplementManager.shared
    
    var statusColor: Color {
        let status = manager.getDayStatus(date: date)
        switch status {
        case .taken: return .sageGreen
        case .late: return .yellow
        case .missed: return .red
        case .pending: return .clear // Or gray for future
        }
    }
    
    var body: some View {
        Circle()
            .fill(statusColor)
            .frame(width: 12, height: 12)
    }
}

struct Last30DaysCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Last 30 Days")
                    .font(.headline)
                    .foregroundColor(.darkText)
                
                Spacer()
                
                Image(systemName: "calendar")
                    .foregroundColor(.sageGreen)
            }
            
            Last30DaysGrid()
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct Last30DaysGrid: View {
    @ObservedObject var manager = SupplementManager.shared
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var days: [Date] {
        let calendar = Calendar.current
        let today = Date()
        var dates: [Date] = []
        // Show last 30 days
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -29 + i, to: today) {
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(days, id: \.self) { date in
                StatusDot30(date: date)
            }
        }
    }
}

struct StatusDot30: View {
    let date: Date
    @ObservedObject var manager = SupplementManager.shared
    
    var statusColor: Color {
        let status = manager.getDayStatus(date: date)
        switch status {
        case .taken: return .sageGreen
        case .late: return .yellow
        case .missed: return .red
        case .pending: return .gray.opacity(0.2) // Dotted or light gray
        }
    }
    
    var body: some View {
        Circle()
            .fill(statusColor)
            .frame(width: 10, height: 10)
    }
}

#Preview {
    StatsScreen()
}
