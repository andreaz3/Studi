//
//  CreateStudySpotView.swift
//  studi
//
//  Created by Peter Pao-Huang on 11/2/23.
//

import SwiftUI
import MapKit
import Foundation
import Combine

struct CreateStudySpotView: View {
    @Binding var isShowing: Bool
    @Binding var studySpots: [StudySpot]
    @Binding var filteredStudySpots: [StudySpot]
    @StateObject private var viewModel = CreateStudySpotViewModel()
    @State private var selectedItem: LocalSearchViewData?
    
    
    @State private var hasCoffee = false
    @State private var hasFood = false
    @State private var wifiStrength = 0.5
    @State private var noiseLevel = 0.5
    @State private var showStudySpotExists = false
    
    // Define a struct to hold the open and close times for each day
    struct DayHours {
        var openTime: Date
        var closeTime: Date
    }
    private var noiseLevelText: String {
        switch noiseLevel {
        case 0:
            return "No Noise"
        case 0.5:
            return "Some Noise"
        default:
            return "Loud"
        }
    }
    
    private var wifiLevelText: String {
            switch wifiStrength {
            case 0:
                return "No WiFi"
            case 0.5:
                return "None"
            default:
                return "Great WiFi"
            }
        }
    
    @State private var showingConfirmation = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    private var review_wifi_text: String {
        switch wifiStrength {
        case 0..<25:
            return "No Wifi"
        case 25..<50:
            return "Weak"
        case 50..<75:
            return "Medium"
        case 75..<100:
            return "Good"
        case 100 :
            return "Fast"
        default:
            return "Undefined"
        }
    }
    
    private var review_noise_text: String {
        switch noiseLevel {
        case 0..<25:
            return "Silent"
        case 25..<50:
            return "Quiet"
        case 50..<75:
            return "Medium"
        case 75..<100:
            return "Noisy"
        case 100 :
            return "Loud"
        default:
            return "Undefined"
        }
    }
    
    // An array to hold the open and close times for each day of the week
    @State private var weekHours: [DayHours] = Array(repeating: DayHours(openTime: Date(), closeTime: Date()), count: 7)
    private let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if let selectedItem = selectedItem {
                    // If selectedItemTitle is not nil, display the label with the title
                    Text(selectedItem.title).font(.largeTitle).frame(maxWidth: .infinity, alignment: .topLeading)
                    NavigationView {
                        Form {
                            Section {
                                Toggle("Coffee", isOn: $hasCoffee)
                                Toggle("Food", isOn: $hasFood)
                            }
                            
                            Section {
                                VStack {
                                    Text("WiFi").font(.title3).frame(maxWidth:.infinity, alignment:.leading)
                                    Slider(
                                        value: $wifiStrength,
                                        in: 0...100,
                                        step: 25
                                    ) {
                                        Text("Speed ")
                                    } minimumValueLabel: {
                                        Text("No Wifi")
                                    } maximumValueLabel: {
                                        Text("Fast")
                                    }
                                    Text(review_wifi_text)
                                }.padding(20)
                                VStack {
                                    Text("Noise").font(.title3).frame(maxWidth:.infinity, alignment:.leading)
                                    Slider(
                                        value: $noiseLevel,
                                        in: 0...100,
                                        step: 25
                                    ) {
                                        Text("Speed")
                                    } minimumValueLabel: {
                                        Text("Silent")
                                    } maximumValueLabel: {
                                        Text("Loud")
                                    }
                                    Text(review_noise_text)

                                }.padding(20)
                            }
                            
                            Section {
                                ForEach(0..<weekHours.count, id: \.self) { index in
                                    VStack(alignment: .leading) {
                                        Text(daysOfWeek[index])
                                            .font(.headline)
                                        HStack {
                                            HStack {
                                                Text("Open")
                                                DatePicker("", selection: $weekHours[index].openTime, displayedComponents: .hourAndMinute)
                                                    .frame(maxWidth: .infinity)
                                                    .labelsHidden()
                                            }
                                            
                                            HStack {
                                                Text("Close")
                                                DatePicker("", selection: $weekHours[index].closeTime, displayedComponents: .hourAndMinute)
                                                    .frame(maxWidth: .infinity)
                                                    .labelsHidden()
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Section {
                                Button(action: {
                                    showingImagePicker = true
                                }) {
                                    HStack {
                                        Image(systemName: "photo.on.rectangle.angled")
                                        Text("Attach Pictures of Study Spot")
                                    }
                                }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                                    ImagePicker(image: self.$inputImage)
                                }
                                if let selectedImage = inputImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFit()
                                }
                                Section {
                                    Button("Submit") {
                                        for studySpot in studySpots {
                                            if studySpot.name == selectedItem.title {
                                                showStudySpotExists = true
                                                isShowing = false
                                            }
                                        }
                                        if showStudySpotExists == false {
                                            let newStudySpot = StudySpot(
                                                name: selectedItem.title,
                                                coordinate: selectedItem.coordinate,
                                                mondayOpen: weekHours[0].openTime,
                                                mondayClose: weekHours[0].closeTime,
                                                tuesdayOpen: weekHours[1].openTime,
                                                tuesdayClose: weekHours[1].closeTime,
                                                wednesdayOpen: weekHours[2].openTime,
                                                wednesdayClose: weekHours[2].closeTime,
                                                thursdayOpen: weekHours[3].openTime,
                                                thursdayClose: weekHours[3].closeTime,
                                                fridayOpen: weekHours[4].openTime,
                                                fridayClose: weekHours[4].closeTime,
                                                saturdayOpen: weekHours[5].openTime,
                                                saturdayClose: weekHours[5].closeTime,
                                                sundayOpen: weekHours[6].openTime,
                                                sundayClose: weekHours[6].closeTime,
                                                image: inputImage,
                                                hasCoffee: hasCoffee,
                                                hasFood: hasFood,
                                                noiseLevel: noiseLevel,
                                                wifiLevel: wifiStrength
                                            )
                                            isShowing = false
                                            studySpots.append(newStudySpot)
                                            filteredStudySpots.append(newStudySpot)
                                            reviewsByLocation[selectedItem.title] = []
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    TextField("Enter Location of Study Spot", text: $viewModel.poiText)
                    Divider()
                    List(viewModel.viewData) { item in
                        VStack(alignment: .leading) {
                            Button {
                                buttonAction(itemValue: item)
                            } label: {
                                Text(item.title).frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.subtitle)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            .ignoresSafeArea(edges: .bottom)
            .alert(isPresented: $showStudySpotExists) {
                Alert(title: Text((selectedItem?.title ?? "Study Spot") + " Already Exists"), message: Text("Your created study spot already exists. Please upload a new study spot."), dismissButton: .default(Text("OK")))
            }
        }.navigationBarTitle("Add New Study Spot", displayMode: .inline)
    }
    func loadImage() {
        // Implement image processing if needed
    }
    func submitDetails() {
        // Your submission logic goes here.
        
        // After submission logic, trigger the navigation
        showingConfirmation = true
    }
    func buttonAction(itemValue: LocalSearchViewData){
        // clear list
        // create label with itemValue.title
        selectedItem = itemValue
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

final class CreateStudySpotViewModel: ObservableObject {
    private var cancellable: AnyCancellable?
    
    @Published var poiText = "" {
        didSet {
            searchForPOI(text: poiText)
        }
    }
    
    @Published var viewData = [LocalSearchViewData]()

    var service: LocalSearchService
    
    init() {
        let center = CLLocationCoordinate2D(latitude: 40.106205435739792, longitude: -88.21924183863197)
        service = LocalSearchService(in: center)
        
        cancellable = service.localSearchPublisher.sink { mapItems in
            self.viewData = mapItems.map({ LocalSearchViewData(mapItem: $0) })
        }
    }
    
    private func searchForCity(text: String) {
        service.searchCities(searchText: text)
    }
    
    private func searchForPOI(text: String) {
        service.searchPointOfInterests(searchText: text)
    }
}

final class LocalSearchService {
    let localSearchPublisher = PassthroughSubject<[MKMapItem], Never>()
    private let center: CLLocationCoordinate2D
    private let radius: CLLocationDistance

    init(in center: CLLocationCoordinate2D,
         radius: CLLocationDistance = 350_000) {
        self.center = center
        self.radius = radius
    }
    
    public func searchCities(searchText: String) {
        request(resultType: .address, searchText: searchText)
    }
    
    public func searchPointOfInterests(searchText: String) {
        request(searchText: searchText)
    }
    
    private func request(resultType: MKLocalSearch.ResultType = .pointOfInterest,
                         searchText: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = resultType
        request.region = MKCoordinateRegion(center: center,
                                            latitudinalMeters: radius,
                                            longitudinalMeters: radius)
        let search = MKLocalSearch(request: request)

        search.start { [weak self](response, _) in
            guard let response = response else {
                return
            }

            self?.localSearchPublisher.send(response.mapItems)
        }
    }
}

struct LocalSearchViewData: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var coordinate: CLLocationCoordinate2D
    
    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.title ?? ""
        self.coordinate = mapItem.placemark.coordinate
    }
}

