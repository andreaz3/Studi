import SwiftUI

struct CreateReviewView: View {
    @State private var wifiStrength: Double = 0
    @State private var noiseLevel: Double = 0
    @State private var food = false
    @State private var drink = false
    @State private var additionalNotes: String = ""
    @Environment(\.presentationMode) var presentationMode
    
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
    
    var body: some View {
        VStack {
            Form {
                Section() {
                    VStack{
                        HStack {
                            Image(systemName: "wifi")
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25) // Adjust the size of the icon
                            Text("No Wifi")
                                .font(.subheadline) // Make the text slightly smaller
                                .foregroundColor(.primary)
                            Slider(value: $wifiStrength, in: 0...100, step: 25)
                            Text("Fast")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        Text(review_wifi_text).font(.subheadline).foregroundColor(.primary)
                    }
                    VStack{
                        HStack {
                            Image(systemName: "speaker.wave.2")
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)
                            Text("Quiet")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Slider(value: $noiseLevel, in: 0...100, step: 25)
                            Text("Loud")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        Text(review_noise_text).font(.subheadline).foregroundColor(.primary)
                    }
                    VStack{
                        HStack {
                            Image(systemName: "fork.knife")
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)
                            Toggle("Coffee", isOn: $drink)
                        }
                        
                    }
                    HStack {
                        Image(systemName: "cup.and.saucer")
                            .foregroundColor(.gray)
                            .frame(width: 25, height: 25)
                        Toggle("Food", isOn: $food)

                    }
                    TextField("Additional Notes", text: $additionalNotes)
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundColor(.gray)
                            .frame(width: 25, height: 25)
                        Text("Attach Pictures of Study Spot")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
                
                Button("Post Review") {
                    // Get the current date
                    let currentDate = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)

                    // Create a new review based on user input
                    let new_review = Review(
                        id: 10, // Use a unique ID (you can use a better mechanism for generating IDs)
                        user_name: "Ali Husain", // Replace with the actual username
                        date: currentDate,
                        wifiRating: wifiStrength,
                        noiseLevelRating: noiseLevel,
                        foodRating: food,
                        drinkRating: drink,
                        imageURL: "", // Replace with an actual image URL
                        description: additionalNotes
                    )

                    // Append the new review to the reviews array
//                    reviewsByLocation[SelectedStudySpot.name].append(new_review)
    
                    if var reviewsForSpot = reviewsByLocation[SelectedStudySpot.name] {
                        // If there are already reviews for this spot, append the new review
                        reviewsForSpot.append(new_review)
                        reviewsByLocation[SelectedStudySpot.name] = reviewsForSpot
                    } else {
                        // If there are no reviews for this spot, create a new array with the new review
                        reviewsByLocation[SelectedStudySpot.name] = [new_review]
                    }


                    // Optionally, reset the form fields
                    wifiStrength = 0
                    noiseLevel = 0
                    food = false
                    drink = false
                    additionalNotes = ""
                    presentationMode.wrappedValue.dismiss()
                }

            }
        }
        .navigationBarTitle("Add Review for " + SelectedStudySpot.name, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct CreateReviewsView_Preview: PreviewProvider {
    static var previews: some View {
        CreateReviewView()
    }
}
