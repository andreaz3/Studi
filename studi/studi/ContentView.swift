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
            name: "Cafe Paradiso",
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
            image: nil,
            hasCoffee: false,
            hasFood: false,
            noiseLevel: 0.5,
            wifiLevel: 0.5
        ),
        StudySpot(
            name: "Grainger Library",
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
            image: nil,
            hasCoffee: false,
            hasFood: false,
            noiseLevel: 0.5,
            wifiLevel: 0.5
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
            name: "Cafe Paradiso",
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
            image: nil,
            hasCoffee: false,
            hasFood: false,
            noiseLevel: 0.5,
            wifiLevel: 0.5
        ),
        StudySpot(
            name: "Grainger Library",
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
            image: nil,
            hasCoffee: false,
            hasFood: false,
            noiseLevel: 0.5,
            wifiLevel: 0.5
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
                            NavigationLink(destination: ReviewsListView(), tag:1, selection: $selection) {
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
                        NavigationLink(destination: ProfileView()) {
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
                            .alert(isPresented: $showCheckedOutAlert) {
                                        Alert(title: Text("Checked Out!"), message: Text("Your study statistics have been successfully collected."), dismissButton: .default(Text("OK")))
                                    }
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
    @Published var checkInLocation: StudySpot?

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
