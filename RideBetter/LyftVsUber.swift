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
        VStack {
            Link("Take me to Lyft", destination: URL(string: "https://ride.lyft.com/")!)
            
            Link("Take me to Uber", destination: URL(string: "https://www.uber.com/us/en/ride/")!)
            }
//        Text("DISTANCES")
//        Text(String(s1))
//        Text(String(s2))
//        Text(String(e1))
//        Text(String(e2))
        
        Button("Get Estimates") {
                       uberViewModel.getRidePriceEstimates(startLat: s1, startLng: s2, endLat: e1, endLng: e2)
                   }
                   
                   List(uberViewModel.priceEstimates, id: \.localizedDisplayName) { estimate in
                       Text(estimate.localizedDisplayName)
                       Text(estimate.estimate)
                   }
        
        Button("Get Price Estimate") {
                        getPriceEstimate()
                    }

                    if let priceEstimate = priceEstimate {
                        VStack {
                            Text("Price Estimate Details:")
                                .font(.headline)

                            Text("Price: \(priceEstimate.price) \(priceEstimate.currency)")
                        }
                        .padding()
                    }
        
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
