import Foundation
import SwiftUI
import Combine

struct PregnancyWeekData {
    let week: Int
    let babySize: String
    let symbol: String
}

class PregnancyManager: ObservableObject {
    static let shared = PregnancyManager()
    
    @Published var startDate: Date = Date()
    
    private let weeklyData: [Int: (name: String, symbol: String)] = [
        1: ("Poppy Seed", "circle.fill"), // Too small for specific icon
        2: ("Poppy Seed", "circle.fill"),
        3: ("Poppy Seed", "circle.fill"),
        4: ("Poppy Seed", "circle.dotted"),
        5: ("Sesame Seed", "smallcircle.filled.circle"),
        6: ("Lentil", "oval.fill"),
        7: ("Blueberry", "circle.grid.2x2.fill"),
        8: ("Kidney Bean", "capsule.fill"),
        9: ("Grape", "circle.fill"),
        10: ("Kumquat", "oval.portrait.fill"),
        11: ("Fig", "leaf.fill"),
        12: ("Lime", "circle.fill"),
        13: ("Peapod", "leaf.arrow.circlepath"),
        14: ("Lemon", "lemon.fill"),
        15: ("Apple", "apple.logo"),
        16: ("Avocado", "oval.fill"),
        17: ("Turnip", "leaf.fill"),
        18: ("Bell Pepper", "bell.fill"),
        19: ("Heirloom Tomato", "circle.fill"),
        20: ("Banana", "moon.fill"),
        21: ("Carrot", "cone.fill"),
        22: ("Spaghetti Squash", "oval.fill"),
        23: ("Large Mango", "oval.fill"),
        24: ("Ear of Corn", "leaf.fill"),
        25: ("Rutabaga", "circle.fill"),
        26: ("Scallion", "arrow.up"),
        27: ("Cauliflower", "cloud.fill"),
        28: ("Eggplant", "oval.portrait.fill"),
        29: ("Butternut Squash", "capsule.fill"),
        30: ("Cabbage", "rosette"),
        31: ("Coconut", "circle.fill"),
        32: ("Kale", "leaf.fill"),
        33: ("Pineapple", "oval.portrait.fill"),
        34: ("Cantaloupe", "circle.fill"),
        35: ("Honeydew Melon", "circle.fill"),
        36: ("Romaine Lettuce", "leaf.fill"),
        37: ("Swiss Chard", "leaf.fill"),
        38: ("Leek", "arrow.up"),
        39: ("Mini Watermelon", "circle.fill"),
        40: ("Small Pumpkin", "pumpkin.fill") 
    ]
    
    private var saveKey: String {
        if let name = UserDefaults.standard.string(forKey: "currentUserName"), !name.isEmpty {
            return "\(name)_pregnancyStartDate"
        }
        return "pregnancyStartDate"
    }

    func setStartDate(_ date: Date) {
        self.startDate = date
        UserDefaults.standard.set(date, forKey: saveKey)
    }
    
    init() {
        reloadForUser()
    }
    
    func reloadForUser() {
        if let savedDate = UserDefaults.standard.object(forKey: saveKey) as? Date {
            self.startDate = savedDate
        } else {
            self.startDate = Date()
        }
    }
    
    var currentWeek: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear], from: startDate, to: Date())
        return max(1, (components.weekOfYear ?? 0) + 1)
    }
    
    var currentBabySize: String {
        return weeklyData[currentWeek]?.name ?? "Pumpkin"
    }
    
    var currentBabySymbol: String {
        return weeklyData[currentWeek]?.symbol ?? "heart.fill"
    }
}
