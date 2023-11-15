import SwiftUI

struct ReviewData: Identifiable, Codable {
    var id: Int
    var wifiStrength: Double
    var noiseLevel: Double
    var foodQuality: Double
    var drinkQuality: Double
    var additionalNotes: String
    var imageNames: [String]
}
