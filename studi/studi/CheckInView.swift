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
    
    @ObservedObject var stopwatchViewModel: StopwatchViewModel
    
    @Binding var isShowing: Bool
    
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
                    // TODO: maybe use PETER's search UI instead
                    TextField(selectedItem == nil ? "Search for a location" : "Search for a different location", text: $searchQuery)
                        .padding()
                        .onTapGesture {
                            isDropdownVisible = true
                        }
                        .onChange(of: searchQuery) { newValue in
                            filterItems(query: newValue)
                        }

                    if let selectedItem = selectedItem {
                        VStack{
                            Text("Location").font(.title2).frame(maxWidth:.infinity, alignment:.leading)
                            Text("\(selectedItem)")
                                .font(.title)
                                .frame(maxWidth:.infinity, alignment:.leading)
                                .padding(5)
                        }.padding(20)
                    }
                }
                
                VStack {
                    Text("Noise Level").font(.title3).frame(maxWidth:.infinity, alignment:.leading)
                    Slider(
                        value: $noiseLevel,
                        in: 0...100,
                        step: 5
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("Quiet")
                    } maximumValueLabel: {
                        Text("Loud")
                    }.disabled(selectedItem == nil || stopwatchViewModel.isStopwatchRunning == true)
                    // Do we want to allow them to record the value ?
                    //                Text("\(level)")
                }.padding(20)
                VStack {
                    Text("Capacity").font(.title3).frame(maxWidth:.infinity, alignment:.leading)
                    Slider(
                        value: $capLevel,
                        in: 0...100,
                        step: 5
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("Empty")
                    } maximumValueLabel: {
                        Text("Full")
                    }.disabled(selectedItem == nil || stopwatchViewModel.isStopwatchRunning == true)
                }.padding(20)
                
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
                
            }
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

