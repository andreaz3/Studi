//
//  CreateReviewView.swift
//  studi
//
//  Created by Peter Pao-Huang on 11/2/23.
//

import SwiftUI

struct CreateReviewView: View {
    @State private var reviewData: [ReviewData] = loadReviewData()
    
    @State private var wifiStrength: Double = 0
    @State private var noiseLevel: Double = 0
    @State private var foodQuality: Double = 0
    @State private var drinkQuality: Double = 0
    @State private var additionalNotes: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: ReviewsView()) {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                            .padding(.leading, 30)
                            .padding(.top, 5)
                    }
                    Spacer()
                    Image("logo")
                    Spacer()
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                            .padding(.trailing, 30)
                            .padding(.top, 5)
                    }
                }
                Form {
                    Section(header: Text("Cafe Paradiso")) {
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
                    
                    ForEach(reviewData.imageNames, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }

                    Button("Post Review") {
                        // Handle the post review action
                    }
                }
            }
        }
    }

    static func loadReviewData() -> [ReviewData] {
        guard let url = Bundle.main.url(forResource: "ReviewData", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([ReviewData].self, from: data)
        } catch {
            print("Error decoding data: \(error)")
            return []
        }
    }
}

struct CreateReviewView_Previews: PreviewProvider {
    static var previews: some View {
        CreateReviewView()
    }
}



