import SwiftUI

struct Review: Identifiable, Decodable {
    var id: Int
    var user_name: String
    var date: String
    var wifiRating: Double
    var noiseLevelRating: Double
    var foodRating: Double
    var drinkRating: Double
    var imageURL: String
    var description: String
}

var reviewsByLocation: [String: [Review]] = [
    "Grainger Engineering Library": [
        Review(id: 1, user_name: "Ali Husain", date: "10/10/2023", wifiRating: 2, noiseLevelRating: 1, foodRating: 0, drinkRating: 2, imageURL: "IMG_8122", description: "Great spot with strong wifi and delicious coffee!"),
        Review(id: 2, user_name: "Wendy Shi", date: "4/19/2023", wifiRating: 2, noiseLevelRating: 1, foodRating: 1, drinkRating: 1, imageURL: "IMG_8121", description: "Cozy place, perfect for long study sessions.")
    ],
    "Caffe Paradiso": [
        Review(id: 2, user_name: "John Doe", date: "4/19/2023", wifiRating: 2, noiseLevelRating: 1, foodRating: 1, drinkRating: 1, imageURL: "IMG_8121", description: "I love the atmosphere here. Will definitely come back!")
    ]
]

struct ReviewsView: View {
    var review: Review
    @State private var showingCreateReview = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(review.date)")
            }
            HStack {
                Text("\(review.user_name)")
            }
            HStack {
                Image(systemName: "wifi")
                    .foregroundColor(.gray)
                    .frame(width: 25, height: 25)
                Text("Weak")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Slider(value: .constant(review.wifiRating), in: 0...2)
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
                Slider(value: .constant(review.noiseLevelRating), in: 0...2)
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
                Slider(value: .constant(review.foodRating), in: 0...2)
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
                Slider(value: .constant(review.drinkRating), in: 0...2)
                Text("Good")
                    .font(.subheadline)
                    .foregroundColor(.primary)
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
    var body: some View {
        ScrollView {
            Text("REVIEWS")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 25).foregroundColor(.gray)
            VStack {
                ScrollView {
                    ForEach(reviewsByLocation[SelectedStudySpot.name] ?? []) { review in
                        ReviewsView(review: review)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                    }
                }
            }
        }
    }
}


struct ReviewsView_Preview: PreviewProvider {
    static var previews: some View {
        ReviewsListView()
    }
}
