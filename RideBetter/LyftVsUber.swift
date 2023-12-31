//
//  LyftVsUber.swift
//  RideBetter
//
//  Created by Maryam Afshar on 2023-12-15.
//

import Foundation

import SwiftUI

struct PriceEstimateResponse: Codable {
    let price: Double
    let currency: String
    // You can add other properties if they are present in the API response
}

struct LyftVsUber: View {
    @Binding var s1: Double
    @Binding var s2: Double
    @Binding var e1: Double
    @Binding var e2: Double
    @StateObject private var uberViewModel = UberViewModel()
    @State private var priceEstimate: PriceEstimateResponse?
    let uberCost = 12.99
    let lyftCost = 11.98
    
    func getPriceEstimate() {
        guard let url = URL(string: "https://api.uber.com/v1/customers/<CUSTOMER_ID>/delivery_quotes") else {
            print("Invalid URL")
            return
        }
        
        // replace with toekn IDs
        let customerId = ""
        let accessToken = ""
        
        
        let pickupAddress = "20 W 34th St, New York, NY 10001"
        let dropoffAddress = "285 Fulton St, New York, NY 10007"
        
        let parameters: [String: Any] = [
            "pickup_address": pickupAddress,
            "dropoff_address": dropoffAddress
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Failed to serialize JSON data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(PriceEstimateResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.priceEstimate = decodedResponse
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error: \(error)")
            }
        }.resume()
    }
    
    var body: some View {
        let text: String
        if (uberCost > lyftCost) {
            text = "Lyft is cheaper"
        } else if (uberCost < lyftCost) {
            text = "Uber is cheaper"
        } else {
            text = "Lyft and Uber are the same price."
        }
        
        return VStack {
//            Image(systemName: "dollarsign")
//                                .imageScale(.large)
//                                .foregroundColor(.accentColor)
            Text("Price Estimate Details")
                .font(.title)
                .fontWeight(.bold)
                .padding(5)
                .foregroundColor(.blue)
                
                .cornerRadius(5)
            
            Text("").padding(5)
           
            // uber
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Uber")
                        .font(.headline)
                    
                    Text("Price: $\(String(format: "%.2f", uberCost)) USD")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    if let url = URL(string: "https://www.uber.com/us/en/ride/") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Text("Take me to Uber")
                            
                        
                        Image(systemName: "arrow.right")
                         
                    }.foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }

            // lyft
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Lyft")
                        .font(.headline)
                    
                    Text("Price: $\(String(format: "%.2f", lyftCost)) USD")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    if let url = URL(string: "https://ride.lyft.com/") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Text("Take me to Lyft")
                        Image(systemName: "arrow.right")
                    }.foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            
            HStack {
                Spacer() // This spacer will push the content to the right
                
                Image(systemName: "info.circle")
                    .foregroundColor(.green)
                
                Text(text)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .padding(0)
                    .cornerRadius(8)
            }.padding(5)


        }
        .padding()
        //        Text("DISTANCES")
        //        Text(String(s1))
        //        Text(String(s2))
        //        Text(String(e1))
        //        Text(String(e2))
        
        //        Button("Get Estimates") {
        //                       uberViewModel.getRidePriceEstimates(startLat: s1, startLng: s2, endLat: e1, endLng: e2)
        //                   }
        //
        //                   List(uberViewModel.priceEstimates, id: \.localizedDisplayName) { estimate in
        //                       Text(estimate.localizedDisplayName)
        //                       Text(estimate.estimate)
        //                   }
        
        
    }
}
    


struct LyftVsUber_Previews: PreviewProvider {
    
    @State static var s1: Double = 0.0
    @State static var s2: Double = 0.0
    @State static var e1: Double = 0.0
    @State static var e2: Double = 0.0
    
    static var previews: some View {
        LyftVsUber(s1: $s1, s2: $s2, e1: $e1, e2: $e2)
    }
}
