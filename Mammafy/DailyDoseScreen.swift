import SwiftUI

struct DailyDoseScreen: View {
    @State private var showAddSupplement = false
    @State private var supplementToEdit: Supplement?
    @ObservedObject var supplementManager = SupplementManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HomeHeader()
                
                PregnancyInfoCard()
                
                ProgressSection(
                    takenCount: supplementManager.progress.taken,
                    totalCount: supplementManager.progress.total
                )
                
                AddSupplementButton(action: {
                    showAddSupplement = true
                })
                
                if supplementManager.activeSupplements.isEmpty {
                    RoutineStartCard()
                } else {
                    VStack(spacing: 15) {
                        ForEach(supplementManager.activeSupplements) { supplement in
                            SupplementRow(supplement: supplement)
                                .onTapGesture {
                                    supplementToEdit = supplement
                                }
                        }
                    }
                }
                
                Spacer().frame(height: 100) // Space for tab bar
            }
            .padding(.top)
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showAddSupplement) {
            AddSupplementView(supplementToEdit: nil)
        }
        .sheet(item: $supplementToEdit) { supplement in
            AddSupplementView(supplementToEdit: supplement)
        }
    }
}

#Preview {
    DailyDoseScreen()
}
