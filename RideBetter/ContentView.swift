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
                
                Text("Ride Cheaper, Ride Better!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(5)
                    .foregroundColor(.blue)
                    
                    .cornerRadius(5)
                
                Text("").padding(5)
                
                // STARTING
                TextField("Enter start address", text: startAdd == "" ? $viewModel.searchableText1 : $startAdd, onEditingChanged: { isEditing in
                                isSearchingStart = isEditing
                            })
                .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    .padding(.horizontal)
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
                TextField("Enter destination address", text: endAdd == "" ? $viewModel.searchableText2 : $endAdd, onEditingChanged: { isEditing in
                                isSearchingEnd = isEditing
                            })
                .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    .padding(.horizontal)
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
                }
                
                if (startAdd != "" && endAdd != "") {
                    Text ("")
                    .onAppear {
                        showDetails = true
                                                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "pin")
                            Text("Starting Address:")
                            Text(startAdd)
                        }
                     
                        HStack {
                            Image(systemName: "pin")
                            Text("Ending Address:")
                            Text(endAdd)
                        }
                    }
                    .padding()
                    .background(Color.white) // Set a background color for the section
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 3, x: 1, y: 1)
                    
                }
                
                if isSearchingEnd {
                    List(self.viewModel.results) { address in
                        Button(action: {
                            endAdd = address.title
                            isSearchingEnd = false
                            geocodeAddress(endAdd, type: "2")
                        }) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(address.title)
                                    .font(.headline)
                                Text(address.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(backgroundColor)
                    }
                    .listStyle(PlainListStyle())
                    .background(backgroundColor) // Set a background color for the entire list
                }

                
            
                
                Section {
                    NavigationLink(
                        // s1: 37.298423, s2: -122.031074, e1: 40.09, e2: -122.031074
                        destination: LocationView(s1: $s1, s2: $s2, e1: $e1, e2: $e2)) {
                            Text("Show Details").padding(15)
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
