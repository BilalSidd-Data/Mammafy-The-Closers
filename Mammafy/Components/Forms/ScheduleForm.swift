import SwiftUI

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
