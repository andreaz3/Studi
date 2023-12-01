import SwiftUI

struct Review: Identifiable, Decodable {
    var id: Int
    var user_name: String
    var date: String
    var wifiRating: Double
    var noiseLevelRating: Double
    var foodRating: Bool
    var drinkRating: Bool
    var imageURL: String
    var description: String
}

var reviewsByLocation: [String: [Review]] = [
    "Grainger Engineering Library": [
        Review(id: 1, user_name: "Ali Husain", date: "10/10/2023", wifiRating: 100, noiseLevelRating: 25, foodRating: false, drinkRating: true, imageURL: "grainger main", description: "Great spot with strong wifi and delicious coffee!"),
        Review(id: 2, user_name: "Wendy Shi", date: "4/19/2023", wifiRating: 75, noiseLevelRating: 75, foodRating: false, drinkRating: false, imageURL: "grainger stairs", description: "Cozy place, perfect for long study sessions.")
    ],
    "Caffe Paradiso": [
        Review(id: 2, user_name: "John Doe", date: "4/19/2023", wifiRating: 100, noiseLevelRating: 100, foodRating: true, drinkRating: true, imageURL: "paradiso", description: "I love the atmosphere here. Will definitely come back!")
    ]
]

struct ReviewsView: View {
    var review: Review
    @State private var showingCreateReview = false
    @State private var foodRating: Bool
    @State private var drinkRating: Bool
    
    private var review_wifi_text: String {
        switch review.wifiRating {
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
        switch review.noiseLevelRating {
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
    
    // Initialize the @State variables with values from the Review object
    init(review: Review) {
        self.review = review
        _foodRating = State(initialValue: review.foodRating)
        _drinkRating = State(initialValue: review.drinkRating)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(review.date)")
            }
            HStack {
                Text("\(review.user_name)")
            }
            VStack{
                HStack {
                    Image(systemName: "wifi")
                        .foregroundColor(.gray)
                        .frame(width: 25, height: 25)
                    Text("No Wifi")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Slider(value: .constant(review.wifiRating), in: 0...100)
                    Text("Fast")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                Text(review_wifi_text)
            }
            VStack{
                HStack {
                    Image(systemName: "speaker.wave.2")
                        .foregroundColor(.gray)
                        .frame(width: 25, height: 25)
                    Text("Silent")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Slider(value: .constant(review.noiseLevelRating), in: 0...100)
                    Text("Loud")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                Text(review_noise_text)
            }
            HStack {
                Image(systemName: "fork.knife")
                    .foregroundColor(.gray)
                    .frame(width: 25, height: 25)
                Toggle("Food", isOn: $foodRating)
            }
            HStack {
                Image(systemName: "cup.and.saucer")
                    .foregroundColor(.gray)
                    .frame(width: 25, height: 25)
                Toggle("Coffee", isOn: $drinkRating)
            }
            
            // Apply styling to the description
            Text(review.description)
                .padding(10)
                .background(Color(red: 84 / 255, green: 128 / 255, blue: 140 / 255))
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)

            
            if !review.imageURL.isEmpty { Image(review.imageURL)
                    .resizable()
                    .frame(height: 200)
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .navigationBarTitle(SelectedStudySpot.name, displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                // Action for the plus button
                showingCreateReview = true
            }) {
                Image(systemName: "plus")
            }
        )
        .background(
            NavigationLink(
                destination: CreateReviewView(),
                isActive: $showingCreateReview,
                label: { EmptyView() }
            )
        )
    }
}

struct ReviewsListView: View {
    @Binding var SelectedStudySpot: StudySpot
    var body: some View {
        ScrollView {
            Text("REVIEWS")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 25)
                .foregroundColor(.gray)
            
            VStack {
                ScrollView {
                    if let reviews = reviewsByLocation[SelectedStudySpot.name], !reviews.isEmpty {
                        ForEach(reviews) { review in
                            ReviewsView(review: review)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                        }
                    } else {
                        Text("No reviews")
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

