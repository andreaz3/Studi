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
}
extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}

var SelectedStudySpot: StudySpot = StudySpot(name: "",coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion(
        center: .init(latitude: 40.106205435739792, longitude: -88.21924183863197),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
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
                span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
}


struct ContentView: View {
    var studySpots:[StudySpot] = [
        StudySpot(name: "Cafe Paradiso",
                  coordinate: CLLocationCoordinate2D(latitude: 40.106205435739792, longitude: -88.21924183863197)),
        StudySpot(name: "Grainger Library",
                coordinate: CLLocationCoordinate2D(latitude: 40.11345149750377, longitude: -88.2269172))
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
    
    var body: some View {
        NavigationView{
            ZStack {
                Map(coordinateRegion: $manager.region, showsUserLocation: true, annotationItems: studySpots) {
                        (studySpot) in
                        MapAnnotation(coordinate: studySpot.coordinate) {
                            NavigationLink(destination: ReviewsListView(), tag:1, selection: $selection) {
                                Button(action: {  self.selection = 1
                                    SelectedStudySpot = studySpot
                                }, label: {
                                    Image(systemName: "mappin.circle").resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.red)
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
                        Image(systemName: "plus.app")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                            .padding(.leading, 30)
                            .padding(.top, 5)
                            .onTapGesture {
                                withAnimation {
                                    showToolbar.toggle()
                                }
                            }
                        if showToolbar {
                            VStack(spacing: 10) {
                                NavigationLink("Add New Study Spot", isActive: $isShowingCreateStudySpot) {
                                                // 1
                                    CreateStudySpotView(isShowing: $isShowingCreateStudySpot)

                                            }
//                                NavigationLink(destination: CreateStudySpotView(isShowing: $isShowingCreateStudySpot)) {
//                                    Label("Add New Study Spot", systemImage: "doc.badge.plus")
//                                }
                                Divider()
                                NavigationLink(destination: CheckInView()) {
                                    Label("Check In", systemImage: "checkmark.circle")
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                        }
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
                    Spacer() // Pushes the next view to the top
                    
                    if isSearching == true {
                        
                    }
                    HStack {
                        Image(systemName: "magnifyingglass").padding(.trailing, -15).padding(.leading, 20)
                        TextField("Search for Study Spots", text: $searchText)
                            .padding(7)
                            .background(Color(.clear))
                            .cornerRadius(8)
                            .border(Color(.black))
                            .padding(.horizontal)
                            .padding(.trailing, 20)
                            .onTapGesture {
                                isSearching = true
                            }
                    }
                    .padding()
                }
            }
        }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
