import SwiftUI

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
