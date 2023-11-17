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

var reviews: [Review] = [
    Review(id: 1, user_name: "Ali Husain", date: "10/10/2023", wifiRating: 4.5, noiseLevelRating: 3.0, foodRating: 4.0, drinkRating: 5.0, imageURL: "https://example.com/image1.jpg", description: "Great spot with strong wifi and delicious coffee!"),
    Review(id: 2, user_name: "Wendy Shi", date: "4/19/2023", wifiRating: 3.5, noiseLevelRating: 2.5, foodRating: 3.0, drinkRating: 4.5, imageURL: "https://example.com/image2.jpg", description: "Cozy place, perfect for long study sessions.")
]

struct ReviewsView: View {
    var review: Review
    @State private var showingCreateReview = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack{
                Text("\(review.date)")
                
            }
            HStack{
                Text("\(review.user_name)")
            }
            HStack {
                Image(systemName: "wifi")
                    .foregroundColor(.gray)
                Slider(value: .constant(review.wifiRating), in: 0...5)
            }
            HStack {
                Image(systemName: "speaker.wave.2")
                    .foregroundColor(.gray)
                Slider(value: .constant(review.noiseLevelRating), in: 0...5)
            }
            HStack {
                Image(systemName: "fork.knife")
                    .foregroundColor(.gray)
                Slider(value: .constant(review.foodRating), in: 0...5)
            }
            HStack {
                Image(systemName: "cup.and.saucer")
                    .foregroundColor(.gray)
                Slider(value: .constant(review.drinkRating), in: 0...5)
            }
            AsyncImage(url: URL(string: review.imageURL)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(height: 200)
            
            // Apply styling to the description
            Text(review.description)
                .padding(10)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
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
                VStack{
                    ScrollView {
                        ForEach(reviews) { review in
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
