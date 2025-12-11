import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // Content
            Group {
                switch selectedTab {
                case 0:
                    DailyDoseScreen()
                case 1:
                    NextVisitView()
                case 2:
                    ChecklistScreen()
                case 3:
                    StatsScreen()
                default:
                    EmptyView()
                }
            }
            
            // Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            TabBarItem(icon: "pills.fill", title: "Daily Dose", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            
            Spacer()
            
            TabBarItem(icon: "calendar", title: "Next Visit", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            
            Spacer()
            
            TabBarItem(icon: "list.clipboard", title: "Checklist", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            
            Spacer()
            
            TabBarItem(icon: "chart.bar.fill", title: "Stats", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? .sageGreen : .gray)
        }
    }
}

#Preview {
    HomeView()
}
