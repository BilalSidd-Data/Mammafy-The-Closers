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

// MARK: - Components

struct NextVisitHeader: View {
    var body: some View {
        HStack {
            Text("Next Visit")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.darkText)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

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
        let calendar = Calendar.current
        
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

struct QuestionsForDoctorView: View {
    @ObservedObject var manager = VisitManager.shared
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Questions for Doctor")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.darkText)
                
                Spacer()
                
                Button(action: {
                    isEditing.toggle()
                    if isEditing {
                        isFocused = true
                    } else {
                        isFocused = false
                    }
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 2)
                        .foregroundColor(.sageGreen)
                }
            }
            .padding(.horizontal)
            
            ZStack(alignment: .topLeading) {
                if manager.questionsForDoctor.isEmpty && !isFocused {
                    Text("Type your questions here...")
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }
                
                TextEditor(text: $manager.questionsForDoctor)
                    .focused($isFocused)
                    .frame(height: 150)
                    .disabled(!isEditing)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.sageGreen.opacity(0.8), lineWidth: 1)
            )
            .padding(.horizontal)
        }
    }
}

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


#Preview {
    NextVisitView()
}
