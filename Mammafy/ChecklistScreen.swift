import SwiftUI

struct ChecklistScreen: View {
    @ObservedObject var manager = VisitManager.shared
    @State private var newItemTitle: String = ""
    @State private var isEditing = false
    @State private var isAddingItem = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ChecklistHeader(isEditing: $isEditing)
                
                // Add Item Button
                Button(action: {
                    isAddingItem = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Checklist Item")
                    }
                    .font(.headline)
                    .foregroundColor(.sageGreen)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.sageGreen.opacity(0.2))
                    .cornerRadius(16)
                }
                .padding(.horizontal)
                .alert("Add Checklist Item", isPresented: $isAddingItem) {
                    TextField("Item Name", text: $newItemTitle)
                    Button("Add") {
                        if !newItemTitle.isEmpty {
                            manager.addChecklistItem(newItemTitle)
                            newItemTitle = ""
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }
                
                if manager.checklist.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 50))
                            .foregroundColor(.sageGreen)
                        Text("Your checklist is empty")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Add items to prepare for your next visit.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                } else {
                    VStack(spacing: 12) {
                        ForEach(manager.checklist) { item in
                            HStack {
                                Button(action: {
                                    manager.toggleChecklistItem(id: item.id)
                                }) {
                                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundColor(item.isCompleted ? .sageGreen : .gray)
                                }
                                
                                Text(item.title.uppercased())
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.darkText)
                                    .strikethrough(item.isCompleted)
                                
                                Spacer()
                                
                                if isEditing {
                                    Button(action: {
                                        if let index = manager.checklist.firstIndex(where: { $0.id == item.id }) {
                                            manager.deleteChecklistItem(at: IndexSet(integer: index))
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red.opacity(0.6))
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .shadow(color: Color.black.opacity(0.02), radius: 2, x: 0, y: 1)
                        }
                    }
                }
                
                Spacer().frame(height: 100)
            }
            .padding(.top)
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
    }
}

struct ChecklistHeader: View {
    @Binding var isEditing: Bool
    
    var body: some View {
        HStack {
            Text("Checklist")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.darkText)
            
            Spacer()
            
            Button(action: {
                isEditing.toggle()
            }) {
                Text(isEditing ? "Done" : "Edit")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                    .foregroundColor(.sageGreen)
            }
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

#Preview {
    ChecklistScreen()
}
