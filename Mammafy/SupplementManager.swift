import Foundation
import SwiftUI
import Combine
import UserNotifications

enum SupplementStatus: String, Codable {
    case pending
    case taken
    case late
    case missed
}

struct Supplement: Identifiable, Codable {
    var id = UUID()
    var name: String
    var dosage: String
    var instructions: String
    var time: Date
    var status: SupplementStatus = .pending
    var dateAdded: Date = Date()
    
    // New fields for date range
    var startDate: Date?
    var endDate: Date?
}

struct DoseLog: Codable, Identifiable {
    var id = UUID()
    var supplementId: UUID
    var date: Date // Normalized to start of day
    var status: SupplementStatus
}

class SupplementManager: ObservableObject {
    static let shared = SupplementManager()
    
    @Published var supplements: [Supplement] = [] {
        didSet {
            saveSupplements()
        }
    }
    
    // Computed property for Today's display
    var activeSupplements: [Supplement] {
        let calendar = Calendar.current
        let today = Date() // Or start of today
        
        return supplements.filter { supplement in
            // Default to true if no dates set (legacy support)
            guard let start = supplement.startDate, let end = supplement.endDate else {
                return true
            }
            // Check if today is within range [start, end]
            // We strip time components for accurate "Day" comparison
            let startDay = calendar.startOfDay(for: start)
            let endDay = calendar.startOfDay(for: end)
            let todayDay = calendar.startOfDay(for: today)
            
            return todayDay >= startDay && todayDay <= endDay
        }
    }
    
    init() {
        loadSupplements()
        loadHistory()
        checkDateAndReset()
        setupDayChangeObserver()
    }
    
    private func setupDayChangeObserver() {
        // Check for date change when app comes to foreground
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.checkDateAndReset()
        }
    }
    
    func addSupplement(name: String, dosage: String, instructions: String, time: Date, startDate: Date, endDate: Date) {
        let newSupplement = Supplement(
            name: name,
            dosage: dosage,
            instructions: instructions,
            time: time,
            startDate: startDate,
            endDate: endDate
        )
        supplements.append(newSupplement)
        
        scheduleNotifications(for: newSupplement)
    }
    
    func updateFullSupplement(_ updatedSupplement: Supplement) {
        if let index = supplements.firstIndex(where: { $0.id == updatedSupplement.id }) {
            // Cancel old notifications first
            cancelNotifications(for: supplements[index])
            
            supplements[index] = updatedSupplement
            
            // Schedule new
            scheduleNotifications(for: updatedSupplement)
        }
    }
    
    func updateStatus(for id: UUID, status: SupplementStatus) {
        if let index = supplements.firstIndex(where: { $0.id == id }) {
            supplements[index].status = status
            
            // Log to history
            logDose(supplementId: id, status: status, date: Date())
        }
    }
    
    private func logDose(supplementId: UUID, status: SupplementStatus, date: Date) {
        let calendar = Calendar.current
        let checkDay = calendar.startOfDay(for: date)
        
        // Remove existing log for this day/log
        history.removeAll { log in
            log.supplementId == supplementId && calendar.isDate(log.date, inSameDayAs: checkDay)
        }
        
        // Add new log
        let newLog = DoseLog(supplementId: supplementId, date: checkDay, status: status)
        history.append(newLog)
    }
    
    func deleteSupplement(at offsets: IndexSet) {
        offsets.forEach { index in
            let supplement = supplements[index]
            cancelNotifications(for: supplement)
        }
        supplements.remove(atOffsets: offsets)
    }
    
    // MARK: - Notification Logic
    private func scheduleNotifications(for supplement: Supplement) {
        // Creative titles
        let motivatingTitles = [
            "💚 Nourishing you and baby!",
            "✨ Time for your daily dose of love!",
            "🌟 Your wellness moment is here!",
            "💪 Building a healthy future together!",
            "🤱 Taking care of you both!",
            "❤️ Love for you and little one!",
            "🌸 Mama's health time!",
            "⭐ You're doing amazing, mama!"
        ]
        
        // Encouraging messages
        let encouragingMessages = [
            "Remember: \(supplement.name) - \(supplement.dosage). You're giving your baby the best start! 🌱",
            "\(supplement.name) - \(supplement.dosage). Every dose is an act of love for your little one! 💕",
            "Time for \(supplement.name) - \(supplement.dosage). You're such a caring mama! 🤗",
            "\(supplement.name) - \(supplement.dosage). Building strong and healthy, one day at a time! 💪",
            "Don't forget: \(supplement.name) - \(supplement.dosage). Your baby appreciates you! 👶",
            "\(supplement.name) - \(supplement.dosage). Small steps, big impact for your baby! ✨"
        ]
        
        let content = UNMutableNotificationContent()
        content.title = motivatingTitles.randomElement() ?? "💚 Time for your supplement!"
        content.body = encouragingMessages.randomElement() ?? "\(supplement.name) - \(supplement.dosage)"
        content.sound = .default
        content.categoryIdentifier = "SUPPLEMENT_REMINDER"
        
        // Extract hour and minute
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: supplement.time)
        
        // Repeating trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        // Unique ID per supplement
        let identifier = "supplement_\(supplement.id.uuidString)"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling supplement notification: \(error.localizedDescription)")
            } else {
                print("✅ Scheduled repeating supplement notification: \(supplement.name)")
            }
        }
    }
    
    private func cancelNotifications(for supplement: Supplement) {
        let identifier = "supplement_\(supplement.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("❌ Cancelled supplement notification: \(identifier)")
    }
    
    // Check pending logs before reset?
    // Actually checkDateAndReset just wipes 'status' on the object.
    // If we didn't log it, it remains 'pending'.
    // We should probably auto-log 'missed' for yesterday if it was pending?
    // Let's implement that in checkDateAndReset.
    

    // MARK: - Persistence
    private var saveKey: String {
        if let name = UserDefaults.standard.string(forKey: "currentUserName"), !name.isEmpty {
            return "\(name)_savedSupplements"
        }
        return "savedSupplements"
    }
    
    private let lastOpenedDateKey = "lastOpenedDate"
    
    func reloadForUser() {
        loadSupplements()
        loadHistory()
    }
    
    private func saveSupplements() {
        if let encoded = try? JSONEncoder().encode(supplements) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadSupplements() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Supplement].self, from: data) {
            supplements = decoded
        }
    }
    
    private func checkDateAndReset() {
        let calendar = Calendar.current
        let lastDate = UserDefaults.standard.object(forKey: lastOpenedDateKey) as? Date ?? Date.distantPast
        
        if !calendar.isDateInToday(lastDate) {
            // It's a new day. Check if we missed anything yesterday (or previous days)
             // We can iterate from lastDate to yesterday and log 'missed' if no log exists
             
            // Reset today's statuses
            for i in 0..<supplements.count {
                supplements[i].status = .pending
            }
            // Save the new state
            saveSupplements()
        }
        
        // Update last opened date to now
        UserDefaults.standard.set(Date(), forKey: lastOpenedDateKey)
    }
    
    // Helper for progress
    var progress: (taken: Int, total: Int) {
        let active = activeSupplements
        let taken = active.filter { $0.status == .taken || $0.status == .late }.count
        let total = active.count
        return (taken, total)
    }
    
    // MARK: - History & Stats
    
    @Published var history: [DoseLog] = [] {
        didSet {
            saveHistory()
        }
    }
    
    private var historySaveKey: String {
        if let name = UserDefaults.standard.string(forKey: "currentUserName"), !name.isEmpty {
            return "\(name)_supplementHistory"
        }
        return "supplementHistory"
    }
    
    // Calculate current streak
    var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        var checkDate = calendar.date(byAdding: .day, value: -1, to: Date())! // Start from yesterday
        
        // If today is fully complete, include it
        if isDayComplete(date: Date()) {
            streak += 1
            // Do NOT change checkDate; loop should starts checking from yesterday
        }
        
        // Loop backwards
        while true {
            if isDayComplete(date: checkDate) {
                streak += 1
                guard let prev = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = prev
            } else {
                break
            }
        }
        
        return streak
    }
    
    // Calculate adherence score (Last 30 days)
    var adherenceScore: Int {
        let calendar = Calendar.current
        let today = Date()
        guard let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: today) else { return 0 }
        
        var totalScheduled = 0
        var totalTaken = 0
        
        var checkDate = thirtyDaysAgo
        while checkDate <= today {
            let activeOnDate = getSupplements(for: checkDate)
            if !activeOnDate.isEmpty {
                totalScheduled += activeOnDate.count
                
                // Count taken for this date
                for supp in activeOnDate {
                    let status = getStatus(for: supp.id, date: checkDate)
                    if status == .taken || status == .late {
                        totalTaken += 1
                    }
                }
            }
            guard let next = calendar.date(byAdding: .day, value: 1, to: checkDate) else { break }
            checkDate = activeOnDate.isEmpty ? next : next
        }
        
        guard totalScheduled > 0 else { return 0 }
        return Int((Double(totalTaken) / Double(totalScheduled)) * 100)
    }
    
    func getSupplements(for date: Date) -> [Supplement] {
        let calendar = Calendar.current
        let checkDay = calendar.startOfDay(for: date)
        
        return supplements.filter { supplement in
            // Logic similar to activeSupplements but for specific date
            guard let start = supplement.startDate, let end = supplement.endDate else {
                // If no dates, assume active forever (legacy)
                return calendar.startOfDay(for: supplement.dateAdded) <= checkDay
            }
            let startDay = calendar.startOfDay(for: start)
            let endDay = calendar.startOfDay(for: end)
            
            return checkDay >= startDay && checkDay <= endDay
        }
    }
    
    func getStatus(for supplementId: UUID, date: Date) -> SupplementStatus {
        let calendar = Calendar.current
        let checkDay = calendar.startOfDay(for: date)
        
        // Check if it's today
        if calendar.isDateInToday(date) {
            if let supp = supplements.first(where: { $0.id == supplementId }) {
                return supp.status
            }
        }
        
        // Check history
        if let log = history.first(where: { $0.supplementId == supplementId && calendar.isDate($0.date, inSameDayAs: checkDay) }) {
            return log.status
        }
        
        return .missed // Default to missed for past dates if no log
    }
    
    func getDayStatus(date: Date) -> SupplementStatus {
         let calendar = Calendar.current
         let active = getSupplements(for: date)
         if active.isEmpty { return .pending } 
         
         var anyLate = false
         for supp in active {
             let status = getStatus(for: supp.id, date: date)
             
             if status == .missed { return .missed }
             if status == .late { anyLate = true }
             
             // If it is pending AND it is in the past, treat as Missed
             if status == .pending {
                 if date < calendar.startOfDay(for: Date()) {
                     return .missed // Strict! Past pending = Missed
                 }
                 return .pending
             }
         }
         
         if anyLate { return .late }
         return .taken
    }

    private func isDayComplete(date: Date) -> Bool {
        let active = getSupplements(for: date)
        guard !active.isEmpty else { return false }
        
        for supp in active {
            let status = getStatus(for: supp.id, date: date)
            if status != .taken && status != .late {
                return false
            }
        }
        return true
    }

    // Persistence Methods
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: historySaveKey)
        }
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historySaveKey),
           let decoded = try? JSONDecoder().decode([DoseLog].self, from: data) {
            history = decoded
        } else {
             history = []
        }
    }
}
