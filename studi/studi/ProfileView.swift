import SwiftUI
import Charts
import Foundation

struct ProfileView: View {
    
    @Binding var allStudySessions: [Date: Int]
    @Binding var myLocationHours : [String: Int]
    
    @ObservedObject var stopwatchViewModel: StopwatchViewModel
    
    @State private var weeklyStudySessions: [StudySession] = []
    @State private var currentWeekIndex = 0 // Start with the most recent week
    
    private var dateRangeText: String {
        if let firstDate = weeklyStudySessions.first?.date,
           let lastDate = weeklyStudySessions.last?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return "\(dateFormatter.string(from: firstDate)) - \(dateFormatter.string(from: lastDate))"
        }
        return ""
    }

    var body: some View {
        VStack {
            HStack{
                Image("dummypfp")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .clipShape(Circle())
                    .padding(20)
                Text("Username").font(.title)
                Text("\(stopwatchViewModel.stopwatchTimeInSeconds)")
            }.frame(maxWidth:.infinity, alignment:.leading)
                .padding(.horizontal)
            Text("HOURS STUDIED")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 25).foregroundColor(.gray)
            Text(dateRangeText)
                .font(.headline)
                .padding(.top)
            VStack{
                Chart {
                    ForEach(weeklyStudySessions) { session in
                        BarMark(
                            x: .value("Date", session.date, unit: .day),
                            y: .value("Hours Studied", session.hours)
                        )
                        .foregroundStyle(by: .value("Date", session.date))
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .frame(height: 225)
                .padding(20)
            }
            .background(Color(.white))

            // Buttons to navigate between weeks
            HStack {
                Button(action: {
                    // Go to previous week
                    if currentWeekIndex < allStudySessions.count - 1 {
                        currentWeekIndex += 1
                        loadWeeklyStudySessions()
                    }
                }) {
                    Label("Previous Week", systemImage: "arrow.left")
                }

                Spacer()

                Button(action: {
                    // Go to next week
                    if currentWeekIndex > 0 {
                        currentWeekIndex -= 1
                        loadWeeklyStudySessions()
                    }
                }) {
                    Label("Next Week", systemImage: "arrow.right")
                }
            }
            .padding()
            List {
                Section(header: Text("Locations Studied").font(.headline)) {
                    // Sort via values from high to low
                    ForEach(myLocationHours.keys.sorted { myLocationHours[$0, default: 0] > myLocationHours[$1, default: 0] }, id: \.self) { key in
                        HStack {
                            Text(key)
                            Spacer()
                            Text("\(myLocationHours[key, default: 0]) hours").frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
            }

        }
        .onAppear {
            loadWeeklyStudySessions()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitle("Your Profile", displayMode: .inline)

    }
    
    // Function to load study sessions for the current week
//    private func loadWeeklyStudySessions() {
//        weeklyStudySessions = allStudySessions[currentWeekIndex]
//    }
    private func loadWeeklyStudySessions() {
        weeklyStudySessions = []

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Calculate the start of the current week
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        // Calculate the start of the week based on currentWeekIndex
        guard let startOfWeek = calendar.date(byAdding: .weekOfYear, value: -currentWeekIndex, to: weekStart) else { return }

        // Loop through each day of the week
        for dayOffset in 0..<7 {
            guard let specificDate = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) else { continue }

            // Check if there is data for this date, otherwise use 0
            let hoursStudied = allStudySessions[specificDate] ?? 0

            // Add this study session
            weeklyStudySessions.append(StudySession(date: specificDate, hours: hoursStudied))
        }
    }
}
