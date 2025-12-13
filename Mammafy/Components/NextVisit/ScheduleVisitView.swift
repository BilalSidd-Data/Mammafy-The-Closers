import SwiftUI

struct ScheduleVisitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager = VisitManager.shared
    
    @State private var doctorName: String = ""
    @State private var location: String = ""
    @State private var date: Date = Date()
    
    init() {
        if let existing = VisitManager.shared.appointment {
            _doctorName = State(initialValue: existing.doctorName)
            _location = State(initialValue: existing.location)
            _date = State(initialValue: existing.date)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Local Header for this sheet
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.gray)
                
                Spacer()
                
                Text("Schedule Visit")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Save") {
                    manager.scheduleAppointment(doctor: doctorName, location: location, date: date)
                    dismiss()
                }
                .fontWeight(.bold)
                .foregroundColor(.sageGreen)
            }
            .padding()
            .background(Color.white)
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Details")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                        
                        VStack(spacing: 0) {
                            TextField("Doctor Name", text: $doctorName)
                                .padding()
                            
                            Divider()
                                .padding(.leading)
                            
                            TextField("Location", text: $location)
                                .padding()
                            
                            Divider()
                                .padding(.leading)
                            
                            DatePicker("Date", selection: $date)
                                .padding()
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            
            // Reset Option
            if manager.appointment != nil {
                Button(action: {
                    manager.resetAppointment()
                    dismiss()
                }) {
                    Text("Reset Appointment")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
    }
}
