import Foundation
import SwiftUI
import Combine

struct Appointment: Codable, Equatable {
    var doctorName: String
    var location: String
    var date: Date
}

struct ChecklistItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
}

class VisitManager: ObservableObject {
    static let shared = VisitManager()
    
    @Published var appointment: Appointment? {
        didSet {
            saveAppointment()
        }
    }
    
    @Published var checklist: [ChecklistItem] = [] {
        didSet {
            saveChecklist()
        }
    }
    
    @Published var questionsForDoctor: String = "" {
        didSet {
            saveQuestions()
        }
    }
    
    init() {
        loadData()
    }
    
    // MARK: - Appointment Logic
    func scheduleAppointment(doctor: String, location: String, date: Date) {
        appointment = Appointment(doctorName: doctor, location: location, date: date)
        
        // 1. One day before
        if let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: date) {
            NotificationManager.shared.scheduleNotification(
                id: "NextVisit_DayBefore",
                title: "✨ Exciting day tomorrow! 🤰",
                body: "Get ready to see Dr. \(doctor)! Baby says hello! 💕",
                date: dayBefore
            )
        }
        
        // 2. Three hours before
        if let threeHoursBefore = Calendar.current.date(byAdding: .hour, value: -3, to: date) {
            NotificationManager.shared.scheduleNotification(
                id: "NextVisit_3HoursBefore",
                title: "🌟 Almost time, Mama! ⏰",
                body: "Just 3 hours until your visit at \(location). Don't forget your checklist! 📝",
                date: threeHoursBefore
            )
        }
        
        // 3. Exact time
        NotificationManager.shared.scheduleNotification(
            id: "NextVisit_ExactTime",
            title: "It's time! 💖",
            body: "Your appointment with Dr. \(doctor) is starting. Wishing you a wonderful visit! 🌸",
            date: date
        )
    }
    
    func resetAppointment() {
        appointment = nil
        checklist.removeAll()
        questionsForDoctor = ""
        NotificationManager.shared.cancelNotification(id: "NextVisit_DayBefore")
        NotificationManager.shared.cancelNotification(id: "NextVisit_3HoursBefore")
        NotificationManager.shared.cancelNotification(id: "NextVisit_ExactTime")
    }
    
    // MARK: - Checklist Logic
    func addChecklistItem(_ title: String) {
        checklist.append(ChecklistItem(title: title, isCompleted: false))
    }
    
    func toggleChecklistItem(id: UUID) {
        if let index = checklist.firstIndex(where: { $0.id == id }) {
            checklist[index].isCompleted.toggle()
        }
    }
    
    func deleteChecklistItem(at offsets: IndexSet) {
        checklist.remove(atOffsets: offsets)
    }
    
    // MARK: - Persistence
    // MARK: - Persistence
    private var appointmentKey: String {
        if let name = UserDefaults.standard.string(forKey: "currentUserName"), !name.isEmpty {
            return "\(name)_savedAppointment"
        }
        return "savedAppointment"
    }
    
    private var checklistKey: String {
        if let name = UserDefaults.standard.string(forKey: "currentUserName"), !name.isEmpty {
            return "\(name)_savedChecklist"
        }
        return "savedChecklist"
    }
    
    private var questionsKey: String {
        if let name = UserDefaults.standard.string(forKey: "currentUserName"), !name.isEmpty {
            return "\(name)_savedQuestions"
        }
        return "savedQuestions"
    }
    
    func reloadForUser() {
        // Reset current loaded data to empty/nil before loading new user's data
        appointment = nil
        checklist = []
        questionsForDoctor = ""
        loadData()
    }
    
    private func saveAppointment() {
        if let encoded = try? JSONEncoder().encode(appointment) {
            UserDefaults.standard.set(encoded, forKey: appointmentKey)
        } else {
            UserDefaults.standard.removeObject(forKey: appointmentKey)
        }
    }
    
    private func saveChecklist() {
        if let encoded = try? JSONEncoder().encode(checklist) {
            UserDefaults.standard.set(encoded, forKey: checklistKey)
        }
    }
    
    private func saveQuestions() {
        UserDefaults.standard.set(questionsForDoctor, forKey: questionsKey)
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: appointmentKey),
           let decoded = try? JSONDecoder().decode(Appointment.self, from: data) {
            appointment = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: checklistKey),
           let decoded = try? JSONDecoder().decode([ChecklistItem].self, from: data) {
            checklist = decoded
        }
        
        if let savedQuestions = UserDefaults.standard.string(forKey: questionsKey) {
            questionsForDoctor = savedQuestions
        }
    }
}
