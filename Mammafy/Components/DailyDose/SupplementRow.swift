import SwiftUI

struct SupplementRow: View {
    let supplement: Supplement
    @ObservedObject var manager = SupplementManager.shared
    
    // Gesture State
    @State private var offset: CGSize = .zero
    @State private var isDragging = false
    @State private var dragDirection: DragDirection? = nil
    
    enum DragDirection {
        case right // Taken
        case left // Missed
        case up // Late
        case down // Reset
        
        var color: Color {
            switch self {
            case .right: return .sageGreen
            case .left: return .red.opacity(0.8)
            case .up: return .orange // Late
            case .down: return .white // Reset
            }
        }
        
        var icon: String {
            switch self {
            case .right: return "checkmark"
            case .left: return "xmark"
            case .up: return "clock.badge.exclamationmark"
            case .down: return "arrow.counterclockwise"
            }
        }
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: supplement.time)
    }
    
    var backgroundColor: Color {
        // If dragging, show gesture color
        if let dir = dragDirection, isDragging {
            return dir.color
        }
        
        // Otherwise show status color
        switch supplement.status {
        case .taken: return .sageGreen
        case .late: return .yellow.opacity(0.6)
        case .missed: return .red.opacity(0.6)
        case .pending: return .sageGreen.opacity(0.2) // Default background
        }
    }
    
    var contentColor: Color {
        if isDragging && dragDirection != nil { return .white }
        
        switch supplement.status {
        case .taken, .missed: return .white
        case .late: return .darkText
        case .pending: return .darkText
        }
    }
    
    var body: some View {
        ZStack {
            // Background Layer with Icons for Thresholds
            GeometryReader { geo in
                ZStack {
                    // Right Icon (Taken)
                    Image(systemName: "checkmark")
                        .font(.title)
                        .foregroundColor(.sageGreen)
                        .opacity(offset.width > 50 ? 1 : 0)
                        .position(x: 40, y: geo.size.height / 2)
                    
                    // Left Icon (Missed)
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.red)
                        .opacity(offset.width < -50 ? 1 : 0)
                        .position(x: geo.size.width - 40, y: geo.size.height / 2)
                    
                    // Up Icon (Late)
                    Image(systemName: "clock")
                        .font(.title)
                        .foregroundColor(.orange)
                        .opacity(offset.height < -40 ? 1 : 0)
                        .position(x: geo.size.width / 2, y: geo.size.height - 40)
                        
                    // Down Icon (Reset)
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title)
                        .foregroundColor(.gray)
                        .opacity(offset.height > 40 ? 1 : 0)
                        .position(x: geo.size.width / 2, y: 40)
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            
            // The Card Content
            HStack(spacing: 16) {
                // Info Section
                VStack(alignment: .leading, spacing: 6) {
                    Text("VITAMIN") // Static or Category?
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(contentColor.opacity(0.6))
                        .textCase(.uppercase)
                    
                    Text(supplement.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(contentColor)
                    
                    if !supplement.instructions.isEmpty {
                        Text(supplement.instructions)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(contentColor.opacity(0.8))
                            .textCase(.uppercase)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(timeString)
                    }
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(contentColor)
                    .padding(.top, 4)
                }
                
                Spacer()
                
                // Dosage/Status Indicator
                VStack(alignment: .trailing) {
                    Text(supplement.dosage)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(contentColor.opacity(0.8))
                        .textCase(.uppercase)
                    
                    Spacer()
                    
                    // Visual Cue for Interaction
                    if supplement.status == .pending {
                        ZStack {
                            Capsule()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 80, height: 40)
                            
                            HStack(spacing: 0) {
                                Image(systemName: "xmark")
                                    .font(.caption)
                                    .foregroundColor(contentColor.opacity(0.5))
                                    .padding(.leading, 8)
                                Spacer()
                                Image(systemName: "checkmark")
                                    .font(.caption)
                                    .foregroundColor(contentColor.opacity(0.5))
                                    .padding(.trailing, 8)
                            }
                            
                            Circle()
                                .fill(Color.white)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "chevron.right.2")
                                        .font(.caption2)
                                        .foregroundColor(.sageGreen)
                                )
                                .shadow(radius: 2)
                        }
                        .frame(width: 80, height: 40)
                    } else {
                        // Status Icon when done
                        Image(systemName: supplement.status == .taken ? "checkmark.circle.fill" :
                                        supplement.status == .missed ? "xmark.circle.fill" :
                                        supplement.status == .late ? "clock.badge.checkmark.fill" : "circle")
                            .font(.largeTitle)
                            .foregroundColor(contentColor)
                    }
                }
            }
            .padding(20)
            .background(backgroundColor)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        isDragging = true
                        
                        // Limit movement for resistance
                        let width = gesture.translation.width
                        let height = gesture.translation.height
                        
                        // Determine predominant direction
                        if abs(width) > abs(height) {
                            // Horizontal
                            offset = CGSize(width: width, height: 0)
                            dragDirection = width > 0 ? .right : .left
                        } else {
                            // Vertical
                            offset = CGSize(width: 0, height: height)
                            dragDirection = height > 0 ? .down : .up
                        }
                    }
                    .onEnded { gesture in
                        let width = gesture.translation.width
                        let height = gesture.translation.height
                        let threshold: CGFloat = 80
                        
                        withAnimation(.spring()) {
                            if abs(width) > abs(height) {
                                // Horizontal End
                                if width > threshold {
                                    // Taken
                                    manager.updateStatus(for: supplement.id, status: .taken)
                                } else if width < -threshold {
                                    // Missed
                                    manager.updateStatus(for: supplement.id, status: .missed)
                                }
                            } else {
                                // Vertical End
                                if height < -threshold { // Swipe Up
                                    // Taken Late
                                    manager.updateStatus(for: supplement.id, status: .late)
                                } else if height > threshold { // Swipe Down
                                    // Reset
                                    manager.updateStatus(for: supplement.id, status: .pending)
                                }
                            }
                            
                            offset = .zero
                            isDragging = false
                            dragDirection = nil
                        }
                    }
            )
        }
        .padding(.horizontal)
    }
}
