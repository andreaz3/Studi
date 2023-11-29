//
//  CheckInView.swift
//  studi
//
//  Created by Peter Pao-Huang on 11/2/23.
//

import SwiftUI

struct CheckInView: View {
    @State private var searchQuery = ""
    @State private var isDropdownVisible = false
    @State private var selectedItem: String?
    let allItems: [String] = ["Grainger Engineering Library", "Campus Instruction Facility", "Psychology Building", "Espresso Royale", "Cafe Bene", "Business Instruction Facility", "JSM Study", "Siebel Center for Design","Siebel Center for Computer Science"]
    @State private var filteredItems: [String] = []
    
    @State private var noiseLevel = 50.0
    @State private var capLevel = 50.0
    @State private var wifiLevel = 50.0
    
    @ObservedObject var stopwatchViewModel: StopwatchViewModel
    
    @Binding var isShowing: Bool
    
    var noiseLevelCategory: String {
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
    
    var capLevelCateogry: String {
        switch capLevel {
        case 0..<25:
            return "Empty"
        case 25..<50:
            return "Sparse"
        case 50..<75:
            return "Medium"
        case 75..<100:
            return "Crowded"
        case 100 :
            return "Full"
        default:
            return "Undefined"
        }
    }
    
    var wifiLevelCateogry: String {
        switch wifiLevel {
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
    
    var body: some View {

        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.isDropdownVisible = false
                    hideKeyboard()
                }
            VStack {
                VStack{
                    Text(selectedItem == nil ? "First, select a location" : "").frame(maxWidth: .infinity, alignment: .leading).padding()
                    TextField(selectedItem == nil ? "Search for a location" : "Search for a different location", text: $searchQuery)
                        .padding(.horizontal)
                        .onTapGesture {
                            isDropdownVisible = true
                        }
                        .onChange(of: searchQuery) { newValue in
                            filterItems(query: newValue)
                        }

                    if let selectedItem = selectedItem {
                        VStack{
                            Text("\(selectedItem)")
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true) // Ensure that it can grow vertically
                                .padding(5)
                        }.padding(20)
                    }
                }.padding(.vertical)
                
                VStack {
                    Text("Noise Level").font(.title3).frame(maxWidth:.infinity, alignment:.leading)
                    Slider(
                        value: $noiseLevel,
                        in: 0...100,
                        step: 25
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("Silent")
                    } maximumValueLabel: {
                        Text("Loud")
                    }.disabled(selectedItem == nil || stopwatchViewModel.isStopwatchRunning == true)
                    Text(noiseLevelCategory)
                }.padding(.horizontal)
                VStack {
                    Text("Capacity").font(.title3).frame(maxWidth:.infinity, alignment:.leading)
                    Slider(
                        value: $capLevel,
                        in: 0...100,
                        step: 25
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("Empty")
                    } maximumValueLabel: {
                        Text("Full")
                    }.disabled(selectedItem == nil || stopwatchViewModel.isStopwatchRunning == true)
                    Text(capLevelCateogry)

                }.padding(.horizontal)
                
                VStack {
                    Text("Wifi").font(.title3).frame(maxWidth:.infinity, alignment:.leading)
                    Slider(
                        value: $wifiLevel,
                        in: 0...100,
                        step: 25
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("No Wifi")
                    } maximumValueLabel: {
                        Text("Fast")
                    }.disabled(selectedItem == nil || stopwatchViewModel.isStopwatchRunning == true)
                    Text(wifiLevelCateogry)
                }.padding(.horizontal)
                VStack {
                    Text(timeFormatted(stopwatchViewModel.stopwatchTimeInSeconds))
                        .font(.largeTitle)
                        .padding()
                    
                    Button(action: {
                        stopwatchViewModel.startStopwatch()
                        isShowing = false
                    }) {
                        Text(stopwatchViewModel.isStopwatchRunning ? "Check Out" : "Check In")
                            .foregroundColor(.white)
                            .padding()
                            .background(selectedItem == nil ? Color.gray : (stopwatchViewModel.isStopwatchRunning ? Color.red : Color.green))
                            .cornerRadius(10)
                        
                    }
                }
                
            }.padding(20)
            
            
            if isDropdownVisible {
                List(filteredItems, id: \.self) { item in
                    Text(item)
                        .onTapGesture {
                            self.selectedItem = item
                            self.isDropdownVisible = false
                            self.searchQuery = ""
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
        
        }
        .navigationBarTitle("Check In")
//        .simultaneousGesture(
//            TapGesture().onEnded {
//                isDropdownVisible = false
//            }
//        )
    }
    
    func filterItems(query: String) {
        if query.isEmpty {
            filteredItems = allItems
        } else {
            filteredItems = allItems.filter { $0.localizedCaseInsensitiveContains(query) }
        }
    }
    
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}

struct CheckInView_Preview: PreviewProvider {
    static var previews: some View {
        CheckInView(stopwatchViewModel: StopwatchViewModel(), isShowing: .constant(true))
    }
}

