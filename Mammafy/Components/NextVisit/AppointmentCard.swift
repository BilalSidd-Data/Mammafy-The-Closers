import SwiftUI
import Combine

struct AppointmentCard: View {
    let appointment: Appointment
    
    @State private var timeRemaining: String = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Custom formatted date string
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy 'at' h:mm"
        return formatter.string(from: appointment.date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("NEXT VISIT")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray.opacity(0.8))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
                Spacer()
            }
            
            Text(timeRemaining)
                .font(.system(size: 36, weight: .bold, design: .monospaced))
                .foregroundColor(.sageGreen)
            
            Divider()
            
            HStack(spacing: 12) {
                Image(systemName: "stethoscope")
                    .foregroundColor(.gray)
                Text(appointment.doctorName)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
            }
            
            HStack(spacing: 12) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.gray)
                Text(appointment.location)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
            }
            
            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text(dateString)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .onReceive(timer) { _ in
            updateTimer()
        }
        .onAppear {
            updateTimer()
        }
    }
    
    func updateTimer() {
        let now = Date()
        
        // If date is passed
        if appointment.date < now {
            timeRemaining = "00:00:00"
            return
        }
        
        let totalSeconds = Int(appointment.date.timeIntervalSince(now))
        let h = totalSeconds / 3600
        let m = (totalSeconds % 3600) / 60
        let s = totalSeconds % 60
        
        timeRemaining = String(format: "%02d:%02d:%02d", h, m, s)
    }
}
