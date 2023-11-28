import SwiftUI

struct CreateReviewView: View {
    @State private var wifiStrength: Double = 0
    @State private var noiseLevel: Double = 0
    @State private var foodQuality: Double = 0
    @State private var drinkQuality: Double = 0
    @State private var additionalNotes: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Form {
                Section() {
                    HStack {
                        Image(systemName: "wifi")
                            .foregroundColor(.gray)
                            .frame(width: 25, height: 25) // Adjust the size of the icon
                        Text("Weak")
                            .font(.subheadline) // Make the text slightly smaller
                            .foregroundColor(.primary)
                        Slider(value: $wifiStrength, in: 0...2, step: 1)
                        Text("Strong")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "speaker.wave.2")
                            .foregroundColor(.gray)
                            .frame(width: 25, height: 25)
                        Text("Quiet")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Slider(value: $noiseLevel, in: 0...2, step: 1)
                        Text("Loud")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(.gray)
                            .frame(width: 25, height: 25)
                        Text("Bad")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Slider(value: $foodQuality, in: 0...2, step: 1)
                        Text("Good")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "cup.and.saucer")
                            .foregroundColor(.gray)
                            .frame(width: 25, height: 25)
                        Text("Bad")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Slider(value: $drinkQuality, in: 0...2, step: 1)
                        Text("Good")
                            .font(.subheadline)
                            .foregroundColor(.primary)
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
                        foodRating: foodQuality,
                        drinkRating: drinkQuality,
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
                    foodQuality = 0
                    drinkQuality = 0
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
