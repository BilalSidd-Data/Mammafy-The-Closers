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

struct AddSupplementHeader: View {
    var title: String = "Add Supplement"
    var onCancel: () -> Void
    var onSave: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onCancel) {
                Text("Cancel")
                    .font(.body)
                    .foregroundColor(.sageGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .stroke(Color.sageGreen.opacity(0.3), lineWidth: 1)
                    )
            }
            
            Spacer()
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.darkText)
            
            Spacer()
            
            Button(action: onSave) {
                Text("Save")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.sageGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.sageGreen.opacity(0.1))
                    )
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct MedicationDetailsForm: View {
    @Binding var name: String
    @Binding var dosage: String
    @Binding var instructions: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Medication Details")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.leading, 5)
            
            VStack(spacing: 0) {
                TextField("Name (e.g., Prenatal Vitamin)", text: $name)
                    .padding()
                
                Divider()
                    .padding(.leading)
                
                TextField("Dosage (e.g., 1 Tablet)", text: $dosage)
                    .padding()
                
                Divider()
                    .padding(.leading)
                
                TextField("Instructions (e.g., Take with food)", text: $instructions)
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
}

struct ScheduleForm: View {
    @Binding var time: Date
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Schedule")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.leading, 5)
            
            VStack(spacing: 0) {
                // Time
                HStack {
                    Text("Time")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.darkText)
                    
                    Spacer()
                    
                    DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding(5)
                        .background(Color.sageGreen.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()
                
                Divider()
                    .padding(.leading)
                
                // Start Date
                HStack {
                    Text("Start Date")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.darkText)
                    
                    Spacer()
                    
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .labelsHidden()
                        .padding(5)
                }
                .padding()
                
                Divider()
                    .padding(.leading)
                
                // End Date
                HStack {
                    Text("End Date")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.darkText)
                    
                    Spacer()
                    
                    DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                        .labelsHidden()
                        .padding(5)
                }
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
}

#Preview {
    AddSupplementView()
}
