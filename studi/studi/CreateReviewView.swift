//
//  CreateReviewView.swift
//  studi
//
//  Created by Peter Pao-Huang on 11/2/23.
//

import SwiftUI

struct CreateReviewView: View {
    @State private var wifiStrength: Double = 0
    @State private var noiseLevel: Double = 0
    @State private var foodQuality: Double = 0
    @State private var drinkQuality: Double = 0
    @State private var additionalNotes: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
//                    HStack{
//                        NavigationLink(destination: ContentView()) { // Change to NavigationLink to navigate to ReviewsView
//                                            Image(systemName: "arrow.backward") // Use a system image for back arrow
//                                                .resizable()
//                                                .frame(width: 30, height: 30) // Adjust size as needed
//                                                .foregroundColor(.black)
//                                                .padding(.leading, 30)
//                                                .padding(.top, 5)
//                                        }
//                        Spacer()
//                        Image("logo")
//                        Spacer()
//                        NavigationLink(destination: ProfileView()) {
//                            Image(systemName: "person.circle.fill")
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                                .foregroundColor(.black)
//                                .padding(.trailing, 30)
//                                .padding(.top, 5)
//                        }
//                    }
            Form {
                Section(header: Text(SelectedStudySpot.name)) {
                    HStack {
                        Image(systemName: "wifi")
                            .foregroundColor(.gray)
                        Slider(value: $wifiStrength, in: 0...5, step: 1) {
                            Text("Wifi")
                        }
                    }
                    HStack {
                        Image(systemName: "speaker.wave.2")
                            .foregroundColor(.gray)
                        Slider(value: $noiseLevel, in: 0...5, step: 1) {
                            Text("Noise")
                        }
                    }
                    HStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(.gray)
                        Slider(value: $foodQuality, in: 0...5, step: 1) {
                            Text("Food")
                        }
                    }
                    HStack {
                        Image(systemName: "cup.and.saucer")
                            .foregroundColor(.gray)
                        Slider(value: $drinkQuality, in: 0...5, step: 1) {
                            Text("Drinks")
                        }
                    }
                    TextField("Additional Notes", text: $additionalNotes)
                }
                
                Button("Post Review") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarTitle("Add Review for " + SelectedStudySpot.name, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}
