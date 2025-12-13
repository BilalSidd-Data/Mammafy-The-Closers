import SwiftUI

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
