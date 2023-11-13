import SwiftUI
import Charts

struct StudySession: Identifiable {
    let id = UUID()
    let date: Date
    let hours: Int
}

struct LocationHours: Identifiable {
    let id = UUID()
    let name: String
    let hours: Int
}

struct ProfileView: View {
    
    @State private var allStudySessions = [
        // Week 1 data
        [StudySession(date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!, hours: 1),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -13, to: Date())!, hours: 2),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -12, to: Date())!, hours: 3),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -11, to: Date())!, hours: 4),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, hours: 5),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!, hours: 2),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!, hours: 1)],
        // Week 2 data
        [StudySession(date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, hours: 2),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, hours: 1),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, hours: 3),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, hours: 4),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, hours: 5),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, hours: 6),
         StudySession(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, hours: 3)]
    ]
    
    // This should be sorted
    @State private var myLocationHours = [
        LocationHours(name: "Campus Instruction Facility", hours:20),
        LocationHours(name: "Grainger Engineering Library", hours:15),
        LocationHours(name: "Pyschology Building", hours:4)
    ]
    
    @State private var weeklyStudySessions: [StudySession] = []
    @State private var currentWeekIndex = 1 // Start with the most recent week
    
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
            }.frame(maxWidth:.infinity, alignment:.leading)
                .padding(20)
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
                    if currentWeekIndex > 0 {
                        currentWeekIndex -= 1
                        loadWeeklyStudySessions()
                    }
                }) {
                    Label("Previous Week", systemImage: "arrow.left")
                }

                Spacer()

                Button(action: {
                    // Go to next week
                    if currentWeekIndex < allStudySessions.count - 1 {
                        currentWeekIndex += 1
                        loadWeeklyStudySessions()
                    }
                }) {
                    Label("Next Week", systemImage: "arrow.right")
                }
            }
            .padding()
            List {
                Section(header: Text("Locations Studied").font(.headline)) {
                    ForEach(myLocationHours) { location in
                        HStack {
                            Text(location.name)
                            Text("\(location.hours) hours").frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadWeeklyStudySessions()
        }
        .background(Color(.systemGroupedBackground))

    }
    
    // Function to load study sessions for the current week
    private func loadWeeklyStudySessions() {
        weeklyStudySessions = allStudySessions[currentWeekIndex]
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
