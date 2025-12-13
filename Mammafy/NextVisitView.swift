import SwiftUI
import Combine

struct NextVisitView: View {
    @ObservedObject var manager = VisitManager.shared
    @State private var showScheduleSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                NextVisitHeader()
                
                Button(action: {
                    showScheduleSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text(manager.appointment == nil ? "Schedule Appointment" : "Edit Appointment")
                    }
                    .font(.headline)
                    .foregroundColor(.sageGreen)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.sageGreen.opacity(0.2))
                    .cornerRadius(16)
                }
                .padding(.horizontal)
                
                if let appointment = manager.appointment {
                    AppointmentCard(appointment: appointment)
                } else {
                    // Empty state or placeholder
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 50))
                            .foregroundColor(.sageGreen)
                        Text("No upcoming visit")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Schedule your next doctor's appointment to verify baby's health.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                }
                
                QuestionsForDoctorView()
                
                Spacer().frame(height: 100)
            }
            .padding(.top)
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showScheduleSheet) {
            ScheduleVisitView()
        }
    }
}

#Preview {
    NextVisitView()
}
