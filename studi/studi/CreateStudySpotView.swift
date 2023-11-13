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
    @StateObject private var viewModel = CreateStudySpotViewModel()
    @State private var selectedItemTitle: String?
    
    @State private var hasCoffee = false
    @State private var hasFood = false
    @State private var wifiStrength = 0.5
    @State private var noiseLevel = 0.5
    @State private var hours: [Bool] = Array(repeating: false, count: 7)
    
    // Define a struct to hold the open and close times for each day
    struct DayHours {
        var openTime: Date
        var closeTime: Date
    }
    
    @State private var showingConfirmation = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    // An array to hold the open and close times for each day of the week
    @State private var weekHours: [DayHours] = Array(repeating: DayHours(openTime: Date(), closeTime: Date()), count: 7)
    private let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if let selectedItemTitle = selectedItemTitle {
                    // If selectedItemTitle is not nil, display the label with the title
                    Text(selectedItemTitle).font(.largeTitle).frame(maxWidth: .infinity, alignment: .topLeading)
                    NavigationView {
                        Form {
                            Section {
                                Toggle("Coffee", isOn: $hasCoffee)
                                Toggle("Food", isOn: $hasFood)
                            }
                            
                            Section {
                                HStack {
                                    Text("WiFi")
                                    Slider(value: $wifiStrength, in: 0...1, step: 0.1)
                                        .accentColor(.black)
                                }
                                HStack {
                                    Text("Noise")
                                    Slider(value: $noiseLevel, in: 0...1, step: 0.1)
                                        .accentColor(.black)
                                }
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
                                Section {
                                    Button("Submit") {
                                        isShowing = false
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
        }
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
        selectedItemTitle = itemValue.title
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
    
    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.title ?? ""
    }
}

