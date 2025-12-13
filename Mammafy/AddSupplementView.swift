import SwiftUI

struct AddSupplementView: View {
    @Environment(\.dismiss) var dismiss
    
    var supplementToEdit: Supplement?
    
    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var instructions: String = ""
    @State private var time: Date = Date()
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date()
    
    init(supplementToEdit: Supplement? = nil) {
        self.supplementToEdit = supplementToEdit
        _name = State(initialValue: supplementToEdit?.name ?? "")
        _dosage = State(initialValue: supplementToEdit?.dosage ?? "")
        _instructions = State(initialValue: supplementToEdit?.instructions ?? "")
        _time = State(initialValue: supplementToEdit?.time ?? Date())
        _startDate = State(initialValue: supplementToEdit?.startDate ?? Date())
        _endDate = State(initialValue: supplementToEdit?.endDate ?? Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            AddSupplementHeader(
                title: supplementToEdit != nil ? "Edit Supplement" : "Add Supplement",
                onCancel: {
                    dismiss()
                },
                onSave: {
                    if let existing = supplementToEdit {
                        var updated = existing
                        updated.name = name
                        updated.dosage = dosage
                        updated.instructions = instructions
                        updated.time = time
                        updated.startDate = startDate
                        updated.endDate = endDate
                        SupplementManager.shared.updateFullSupplement(updated)
                    } else {
                        SupplementManager.shared.addSupplement(
                            name: name,
                            dosage: dosage,
                            instructions: instructions,
                            time: time,
                            startDate: startDate,
                            endDate: endDate
                        )
                    }
                    dismiss()
                }
            )
            
            ScrollView {
                VStack(spacing: 25) {
                    MedicationDetailsForm(
                        name: $name,
                        dosage: $dosage,
                        instructions: $instructions
                    )
                    
                    ScheduleForm(time: $time, startDate: $startDate, endDate: $endDate)
                }
                .padding(.top)
            }
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    AddSupplementView()
}
