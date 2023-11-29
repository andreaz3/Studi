//
//  InfoView.swift
//  studi
//
//  Created by Peter Pao-Huang on 11/2/23.
//

import SwiftUI
import MapKit


struct InfoView: View {
    @State private var hasCoffee: Bool
    @State private var hasFood: Bool
    @State private var selectedStudy: StudySpot

    init(studySpot: StudySpot) {
        _hasCoffee = State(initialValue: studySpot.hasCoffee)
        _hasFood = State(initialValue: studySpot.hasFood)
        _selectedStudy = State(initialValue: studySpot)
        // Initialize other properties if needed
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let image = SelectedStudySpot.image {
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .clipped()
                    }
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
                }
                Group {
                    Text("Hours").font(.title2)
                    HStack {
                        Text("Monday:")
                        Spacer()
                        Text("\(SelectedStudySpot.mondayOpen, formatter: hourMinuteFormatter) - \(SelectedStudySpot.mondayClose, formatter: hourMinuteFormatter)")
                    }
                    HStack {
                        Text("Tuesday:")
                        Spacer()
                        Text("\(SelectedStudySpot.tuesdayOpen, formatter: hourMinuteFormatter) - \(SelectedStudySpot.tuesdayClose, formatter: hourMinuteFormatter)")
                    }
                    HStack {
                        Text("Wednesday:")
                        Spacer()
                        Text("\(SelectedStudySpot.wednesdayOpen, formatter: hourMinuteFormatter) - \(SelectedStudySpot.wednesdayClose, formatter: hourMinuteFormatter)")
                    }
                    HStack {
                        Text("Thursday:")
                        Spacer()
                        Text("\(SelectedStudySpot.thursdayOpen, formatter: hourMinuteFormatter) - \(SelectedStudySpot.thursdayClose, formatter: hourMinuteFormatter)")
                    }
                    HStack {
                        Text("Friday:")
                        Spacer()
                        Text("\(SelectedStudySpot.fridayOpen, formatter: hourMinuteFormatter) - \(SelectedStudySpot.fridayClose, formatter: hourMinuteFormatter)")
                    }
                    HStack {
                        Text("Saturday:")
                        Spacer()
                        Text("\(SelectedStudySpot.saturdayOpen, formatter: hourMinuteFormatter) - \(SelectedStudySpot.saturdayClose, formatter: hourMinuteFormatter)")
                    }
                    HStack {
                        Text("Sunday:")
                        Spacer()
                        Text("\(SelectedStudySpot.sundayOpen, formatter: hourMinuteFormatter) - \(SelectedStudySpot.sundayClose, formatter: hourMinuteFormatter)")
                    }
                }
                                
                Text("Coffee Availability")
                    .font(.headline)
                CustomToggle(isOn: $hasCoffee, leftText: "No Coffee", rightText: "Coffee")

                // Custom Toggle for Food
                Text("Food Availability")
                    .font(.headline)
                CustomToggle(isOn: $hasFood, leftText: "No Food", rightText: "Food")

                HStack {
                    Text("Noise Level").font(.headline)
                    Spacer()
                    if SelectedStudySpot.noiseLevel < 0.2 {
                        Text("Quiet")
                    } else if SelectedStudySpot.noiseLevel >= 0.2 && SelectedStudySpot.noiseLevel < 0.8 {
                        Text("Moderate")
                    } else {
                        Text("Loud")
                    }
                }
                HStack {
                    Text("WiFi").font(.headline)
                    Spacer()
                    if SelectedStudySpot.noiseLevel < 0.2 {
                        Text("None")
                    } else if SelectedStudySpot.noiseLevel >= 0.2 && SelectedStudySpot.noiseLevel < 0.8 {
                        Text("Unreliable")
                    } else {
                        Text("Excellent")
                    }
                }
                NavigationLink(destination: ReviewsListView(SelectedStudySpot: $selectedStudy)) {
                    Text("Reviews")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.teal)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 10)
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: SelectedStudySpot.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))), annotationItems: [SelectedStudySpot]) { spot in
                        MapPin(coordinate: spot.coordinate)
                    }
                    .frame(height: 200)
            }
            .padding()
        }.navigationBarTitle(SelectedStudySpot.name)
    }
    private var hourMinuteFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}

struct MapView: View {
    var coordinate: CLLocationCoordinate2D

    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))
    }
}
struct CustomToggle: View {
    @Binding var isOn: Bool
    var leftText: String
    var rightText: String

    var body: some View {
        HStack {
            Text(leftText)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isOn ? Color.gray : Color.teal)
                .foregroundColor(.white)
                .cornerRadius(10)

            Text(rightText)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isOn ? Color.teal : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
        }.disabled(true)
    }
}
