//
//  ContentView.swift
//  studi
//
//  Created by Peter Pao-Huang on 11/1/23.
//

import SwiftUI
import MapKit
import CoreLocation

struct StudySpot: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let mondayOpen: Date
    let mondayClose: Date
    let tuesdayOpen: Date
    let tuesdayClose: Date
    let wednesdayOpen: Date
    let wednesdayClose: Date
    let thursdayOpen: Date
    let thursdayClose: Date
    let fridayOpen: Date
    let fridayClose: Date
    let saturdayOpen: Date
    let saturdayClose: Date
    let sundayOpen: Date
    let sundayClose: Date
    let image: UIImage?
    let hasCoffee: Bool
    let hasFood: Bool
    let noiseLevel: Double
    let wifiLevel: Double
}
extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}

var SelectedStudySpot: StudySpot = StudySpot(
    name: "",
    coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
    mondayOpen: Date(),
    mondayClose: Date(),
    tuesdayOpen: Date(),
    tuesdayClose: Date(),
    wednesdayOpen: Date(),
    wednesdayClose: Date(),
    thursdayOpen: Date(),
    thursdayClose: Date(),
    fridayOpen: Date(),
    fridayClose: Date(),
    saturdayOpen: Date(),
    saturdayClose: Date(),
    sundayOpen: Date(),
    sundayClose: Date(),
    image: nil,
    hasCoffee: false,
    hasFood: false,
    noiseLevel: 0.5,
    wifiLevel: 0.5
)

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

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion(
        center: .init(latitude: 40.106205435739792, longitude: -88.21924183863197),
        span: .init(latitudeDelta: 0.04, longitudeDelta: 0.04)
    )
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.setup()
    }
    
    func setup() {
        switch locationManager.authorizationStatus {
        //If we are authorized then we request location just once, to center the map
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        //If we don´t, we request authorization
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locations.last.map {
            region = MKCoordinateRegion(
                center: $0.coordinate,
                span: .init(latitudeDelta: 0.001, longitudeDelta: 0.01)
            )
        }
    }
}


struct ContentView: View {
    @State var studySpots:[StudySpot] = [
        StudySpot(
            name: "Caffe Paradiso",
            coordinate: CLLocationCoordinate2D(latitude: 40.106205435739792, longitude: -88.21924183863197),
            mondayOpen: Date(),
            mondayClose: Date(),
            tuesdayOpen: Date(),
            tuesdayClose: Date(),
            wednesdayOpen: Date(),
            wednesdayClose: Date(),
            thursdayOpen: Date(),
            thursdayClose: Date(),
            fridayOpen: Date(),
            fridayClose: Date(),
            saturdayOpen: Date(),
            saturdayClose: Date(),
            sundayOpen: Date(),
            sundayClose: Date(),
            image: UIImage(named: "paradiso"),
            hasCoffee: false,
            hasFood: false,
            noiseLevel: 1.0,
            wifiLevel: 0.5
        ),
        StudySpot(
            name: "Grainger Engineering Library",
            coordinate: CLLocationCoordinate2D(latitude: 40.11345149750377, longitude: -88.2269172),
            mondayOpen: Date(),
            mondayClose: Date(),
            tuesdayOpen: Date(),
            tuesdayClose: Date(),
            wednesdayOpen: Date(),
            wednesdayClose: Date(),
            thursdayOpen: Date(),
            thursdayClose: Date(),
            fridayOpen: Date(),
            fridayClose: Date(),
            saturdayOpen: Date(),
            saturdayClose: Date(),
            sundayOpen: Date(),
            sundayClose: Date(),
            image: UIImage(named: "grainger"),
            hasCoffee: false,
            hasFood: false,
            noiseLevel: 0.2,
            wifiLevel: 1.0
        ),
        StudySpot(
            name: "Peet's Coffee",
            coordinate: CLLocationCoordinate2D(latitude: 37.78606782572351, longitude: -122.40512616318732),
            mondayOpen: Date(),
            mondayClose: Date(),
            tuesdayOpen: Date(),
            tuesdayClose: Date(),
            wednesdayOpen: Date(),
            wednesdayClose: Date(),
            thursdayOpen: Date(),
            thursdayClose: Date(),
            fridayOpen: Date(),
            fridayClose: Date(),
            saturdayOpen: Date(),
            saturdayClose: Date(),
            sundayOpen: Date(),
            sundayClose: Date(),
            image: nil,
            hasCoffee: false,
            hasFood: false,
            noiseLevel: 0.5,
            wifiLevel: 0.5
        )
    ]
    @State var filteredStudySpots:[StudySpot] = [
        StudySpot(
            name: "Caffe Paradiso",
            coordinate: CLLocationCoordinate2D(latitude: 40.106205435739792, longitude: -88.21924183863197),
            mondayOpen: Date(),
            mondayClose: Date(),
            tuesdayOpen: Date(),
            tuesdayClose: Date(),
            wednesdayOpen: Date(),
            wednesdayClose: Date(),
            thursdayOpen: Date(),
            thursdayClose: Date(),
            fridayOpen: Date(),
            fridayClose: Date(),
            saturdayOpen: Date(),
            saturdayClose: Date(),
            sundayOpen: Date(),
            sundayClose: Date(),
            image: UIImage(named: "paradiso"),
            hasCoffee: false,
            hasFood: false,
            noiseLevel: 1.0,
            wifiLevel: 0.5
        ),
        StudySpot(
            name: "Grainger Engineering Library",
            coordinate: CLLocationCoordinate2D(latitude: 40.11345149750377, longitude: -88.2269172),
            mondayOpen: Date(),
            mondayClose: Date(),
            tuesdayOpen: Date(),
            tuesdayClose: Date(),
            wednesdayOpen: Date(),
            wednesdayClose: Date(),
            thursdayOpen: Date(),
            thursdayClose: Date(),
            fridayOpen: Date(),
            fridayClose: Date(),
            saturdayOpen: Date(),
            saturdayClose: Date(),
            sundayOpen: Date(),
            sundayClose: Date(),
            image: UIImage(named: "grainger"),
            hasCoffee: false,
            hasFood: false,
            noiseLevel: 0.2,
            wifiLevel: 1.0
        ),
        StudySpot(
            name: "Peet's Coffee",
            coordinate: CLLocationCoordinate2D(latitude: 37.78606782572351, longitude: -122.40512616318732),
            mondayOpen: Date(),
            mondayClose: Date(),
            tuesdayOpen: Date(),
            tuesdayClose: Date(),
            wednesdayOpen: Date(),
            wednesdayClose: Date(),
            thursdayOpen: Date(),
            thursdayClose: Date(),
            fridayOpen: Date(),
            fridayClose: Date(),
            saturdayOpen: Date(),
            saturdayClose: Date(),
            sundayOpen: Date(),
            sundayClose: Date(),
            image: nil,
            hasCoffee: false,
            hasFood: false,
            noiseLevel: 0.5,
            wifiLevel: 0.5
        )
    ]
    // {name: coordinates}
    var studySpotInfo = {}
    // {name: [is_wifi, is_coffee, is_food, noise \in [0,1]]}
    var reviews = {}
    var userMetrics = {}
    
    
    
    // PROFILE DATA
    
    static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    
    @State private var allStudySessions: [Date: Int] = [
            dateFormatter.date(from: "2023-11-01")!: 2,
            dateFormatter.date(from: "2023-11-02")!: 3,
            dateFormatter.date(from: "2023-11-03")!: 1,
            dateFormatter.date(from: "2023-11-04")!: 4,
            dateFormatter.date(from: "2023-11-05")!: 2,
            dateFormatter.date(from: "2023-11-06")!: 3,
            dateFormatter.date(from: "2023-11-07")!: 1,
            dateFormatter.date(from: "2023-11-08")!: 4,
            dateFormatter.date(from: "2023-11-09")!: 2,
            dateFormatter.date(from: "2023-11-10")!: 3,
            dateFormatter.date(from: "2023-11-11")!: 1,
            dateFormatter.date(from: "2023-11-12")!: 4,
            dateFormatter.date(from: "2023-11-13")!: 2,
            dateFormatter.date(from: "2023-11-14")!: 3,
            dateFormatter.date(from: "2023-11-15")!: 1,
            dateFormatter.date(from: "2023-11-16")!: 4,
//            dateFormatter.date(from: "2023-11-17")!: 2,
            dateFormatter.date(from: "2023-11-18")!: 3,
            dateFormatter.date(from: "2023-11-19")!: 1,
            dateFormatter.date(from: "2023-11-20")!: 4,
            dateFormatter.date(from: "2023-11-21")!: 2,
            dateFormatter.date(from: "2023-11-22")!: 5,
            dateFormatter.date(from: "2023-11-23")!: 2,
            dateFormatter.date(from: "2023-11-24")!: 6,
            dateFormatter.date(from: "2023-11-25")!: 1,
            dateFormatter.date(from: "2023-11-26")!: 2,
//            dateFormatter.date(from: "2023-11-27")!: 2,
            dateFormatter.date(from: "2023-11-28")!: 3,
//            dateFormatter.date(from: "2023-11-29")!: 2,
        ]
    
    @State private var myLocationHours: [String: Int] = [
        "Campus Instruction Facility": 20,
        "Grainger Engineering Library": 15,
        "Pyschology Building": 4
    ]
    
    @StateObject var manager = LocationManager()
    @State private var showActionSheet = false
    @State private var navigateTo: Int? = nil
    @State private var showToolbar = false
    @State private var searchText: String = ""
    @State private var isSearching = false
    @State var selection: Int? = nil
    @State private var isShowingCreateStudySpot = false
    @State private var isShowingCreateReview = false
    @State private var isShowingCheckIn = false
    @State private var showCheckedOutAlert = false
    
    @ObservedObject var stopwatchViewModel = StopwatchViewModel()
    
    var body: some View {
        NavigationView{
            ZStack {
                Map(coordinateRegion: $manager.region, showsUserLocation: true, annotationItems: filteredStudySpots) {
                        (studySpot) in
                        MapAnnotation(coordinate: studySpot.coordinate) {
                            NavigationLink(destination: InfoView(studySpot: SelectedStudySpot), tag:1, selection: $selection) {
                                Button(action: {  self.selection = 1
                                    SelectedStudySpot = studySpot
                                }, label: {
                                    Image(systemName: "mappin.circle.fill").resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.orange)
                                })
                            }
                            
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("logo")
                    Spacer() // pushes the Image to the top
                }
                VStack {
                    HStack {
                        NavigationLink(destination: CreateStudySpotView(isShowing: $isShowingCreateStudySpot, studySpots: $studySpots, filteredStudySpots: $filteredStudySpots), isActive: $isShowingCreateStudySpot) {
                            Image(systemName:
                                "plus.app")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.black)
                                .padding(.leading, 30)
                                .padding(.top, 5)

                        }

//                        if showToolbar {
//
////                                NavigationLink(destination: CreateStudySpotView(isShowing: $isShowingCreateStudySpot)) {
////                                    Label("Add New Study Spot", systemImage: "doc.badge.plus")
////                                }
//                                Divider()
//                                NavigationLink(destination: CheckInView()) {
//                                    Label("Check In", systemImage: "checkmark.circle")
//                                }
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(8)
//                            .shadow(radius: 4)
//                        }
                        Spacer() // Pushes the next view to the right
                        NavigationLink(destination: ProfileView(allStudySessions:$allStudySessions,myLocationHours:$myLocationHours, stopwatchViewModel:stopwatchViewModel)) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.black)
                                .padding(.trailing, 30)
                                .padding(.top, 5)
                        }

                    }

                    if isSearching == true {
                        
                    }
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass").padding(.trailing, -15).padding(.leading, 0)
                            TextField("Search for Study Spots", text: $searchText)
                                .padding(7)
                                .background(Color(.clear))
                                .cornerRadius(8)
                                .border(Color(.black))
                                .padding(.horizontal)
                                .padding(.trailing, 0)
                                .onTapGesture {
                                    isSearching = true
                                }
                                .onChange(of: searchText, perform: { value in
                                        filterStudySpots()
                                    })
                        }
                        .padding()
                        .background(Color.white.opacity(0.70)) // Change opacity as needed
                        .cornerRadius(8)
                        Spacer()
                    }.padding(20)
                    if stopwatchViewModel.isStopwatchRunning == true {
                        Button(action: {
                            addStudyStats()
                            stopwatchViewModel.stopStopwatch()
                            showCheckedOutAlert = true
                        }) {
                            Text("Check Out with Elapsed Time: " + timeFormatted(stopwatchViewModel.stopwatchTimeInSeconds))
                                .frame(maxWidth: .infinity) // Full width
                                .padding()
                                .foregroundColor(Color.white)
                                .background(Color.red.opacity(0.70))
                                .cornerRadius(8)
                        }.padding(.horizontal, 20)
                    } else {
                        NavigationLink(destination: CheckInView(stopwatchViewModel:stopwatchViewModel, isShowing: $isShowingCheckIn), isActive: $isShowingCheckIn) {
                            Text("Check In")
                                .frame(maxWidth: .infinity) // Full width
                                .padding()
                                .foregroundColor(Color.white)
                                .background(Color.green.opacity(0.70))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                }
            }.alert(isPresented: $showCheckedOutAlert) {
                Alert(title: Text("Checked Out!"), message: Text("Your study statistics have been successfully collected."), dismissButton: .default(Text("OK")))
            }
        }
    }
    func filterStudySpots() {
        if searchText.isEmpty {
            filteredStudySpots = studySpots // Assuming 'studySpots' is your original array
        } else {
            filteredStudySpots = studySpots.filter { spot in
                spot.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func addStudyStats() {
        let today = Calendar.current.startOfDay(for: Date())
        allStudySessions[today, default: 0] += stopwatchViewModel.stopwatchTimeInSeconds
        if let location = stopwatchViewModel.checkInLocation {
            myLocationHours[location, default: 0] += stopwatchViewModel.stopwatchTimeInSeconds
        } else {
            // This should never happen
            print("Error: No Location Selected")
        }
        
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class StopwatchViewModel: ObservableObject {
    @Published var stopwatchTimeInSeconds: Int = 0
    @Published var timer = Timer()
    @Published var isStopwatchRunning: Bool = false
    @Published var checkInLocation: String?

    func startStopwatch() {
        stopwatchTimeInSeconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.stopwatchTimeInSeconds += 1
        }
        isStopwatchRunning = true
    }

    func stopStopwatch() {
        // Stop the stopwatch
        timer.invalidate()
        stopwatchTimeInSeconds = 0
        isStopwatchRunning = false
    }
}

func timeFormatted(_ totalSeconds: Int) -> String {
    let seconds: Int = totalSeconds % 60
    let minutes: Int = (totalSeconds / 60) % 60
    let hours: Int = totalSeconds / 3600
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}
