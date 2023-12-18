//
//  ContentView.swift
//  RideBetter
//
//  Created by Maryam Afshar on 2023-12-16.
//

//import SwiftUI
//import MapKit
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel
    @FocusState private var isFocusedTextField: Bool
    
    
    
    @State private var startingAddress: Double = 1.1
    
    @State var s1: Double = 0
    @State var s2: Double = 0
    
    @State var e1: Double = 0
    @State var e2: Double = 0
    
    
    @State var destinationAddress: String = ""
    
    @State var showDetails: Bool = false
    
    @State private var isSearchingStart = false
    @State private var isSearchingEnd = false
    @State var startAdd: String = ""
    @State var endAdd: String = ""
    @State private var startCoordinates: CLLocationCoordinate2D?
    @State private var endCoordinates: CLLocationCoordinate2D?
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "car")
                                    .imageScale(.large)
                                    .foregroundColor(.accentColor)
                Text("Ride Cheaper, Ride Better!").multilineTextAlignment(.center).padding(10)
                
                // STARTING
                TextField("Enter start address", text: $viewModel.searchableText1, onEditingChanged: { isEditing in
                                isSearchingStart = isEditing
                            })
                    .padding()
                    .focused($isFocusedTextField)
                    .onReceive(
                        viewModel.$searchableText1.debounce(
                            for: .seconds(1),
                            scheduler: DispatchQueue.main
                        )
                    ) {
                        viewModel.searchAddress1($0)
                    }
                    .background(Color.init(uiColor: .systemBackground))
                    .onAppear {
                        isFocusedTextField = true
                    }
                
                // ENDING
                TextField("Enter destination address", text: $viewModel.searchableText2, onEditingChanged: { isEditing in
                                isSearchingEnd = isEditing
                            })
                    .padding()
                    .focused($isFocusedTextField)
                    .onReceive(
                        viewModel.$searchableText2.debounce(
                            for: .seconds(1),
                            scheduler: DispatchQueue.main
                        )
                    ) {
                        viewModel.searchAddress2($0)
                    }
                    .background(Color.init(uiColor: .systemBackground))
                    .onAppear {
                        isFocusedTextField = true
                    }
                
                // START
                if isSearchingStart {
                    List(self.viewModel.results) { address in
                        Button(action: {
                            startAdd = address.title
                            isSearchingStart = false
                            geocodeAddress(startAdd, type: "1")
                        }) {
                            VStack(alignment: .leading) {
                                Text(address.title)
                                Text(address.subtitle)
                            }
                        }
                        .listRowBackground(backgroundColor)
                        
                    }
                    
                    .listStyle(.plain)
                } else {
                    Text("Starting Address:")
                    Text(startAdd)
                }
                
                // END
                if isSearchingEnd {
                    List(self.viewModel.results) { address in
                        Button(action: {
                            endAdd = address.title
                            isSearchingEnd = false
                            geocodeAddress(endAdd, type: "2")
                        }) {
                            VStack(alignment: .leading) {
                                Text(address.title)
                                Text(address.subtitle)
                            }
                        }
                        .listRowBackground(backgroundColor)
                    }
                    
                    .listStyle(.plain)
                } else {
                    Text("Ending Address:")
                    Text(endAdd)
                }
                    
                
                if startAdd != "" && endAdd != "" {
                    Text ("")
                                .onAppear {
                                    showDetails = true
                                }
                }
                
                Section {
                    NavigationLink(
                        // s1: 37.298423, s2: -122.031074, e1: 40.09, e2: -122.031074
                        destination: LocationView(s1: $s1, s2: $s2, e1: $e1, e2: $e2)) {
                            Text("Show Details")
                        }
                }.disabled(showDetails == false)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    func geocodeAddress(_ address: String, type: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                print("Error geocoding address: \(error?.localizedDescription ?? "")")
                return
            }

            // selectedAddress = address
            if (type == "1") {
                startCoordinates = location.coordinate
                s1 = location.coordinate.latitude
                s2 = location.coordinate.longitude
            } else {
                endCoordinates = location.coordinate
                e1 = location.coordinate.latitude
                e2 = location.coordinate.longitude
            }
            
        }
    }
    
    var backgroundColor: Color = Color.init(uiColor: .systemGray6)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
