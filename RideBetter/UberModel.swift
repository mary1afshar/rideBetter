//
//  UberModel.swift
//  RideBetter
//
//  Created by Maryam Afshar on 2023-12-23.
//

import Foundation
import Combine

class UberViewModel: ObservableObject {
    @Published var priceEstimates: [UberPriceEstimate] = []
    
    func getRidePriceEstimates(startLat: Double, startLng: Double, endLat: Double, endLng: Double) {
        let urlString = "https://api.uber.com/v1.2/estimates/price"
        let queryItems = [
            URLQueryItem(name: "start_latitude", value: String(startLat)),
            URLQueryItem(name: "start_longitude", value: String(startLng)),
            URLQueryItem(name: "end_latitude", value: String(endLat)),
            URLQueryItem(name: "end_longitude", value: String(endLng))
        ]
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Replace YOUR_ACCESS_TOKEN with your actual access token
        request.setValue("", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    print("API request finished successfully.")
                case .failure(let error):
                    print("API request failed with error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] data in
                print("Received API response data: \(String(data: data, encoding: .utf8) ?? "")")
                do {
                    let response = try JSONDecoder().decode(UberPriceEstimateResponse.self, from: data)
                    print("Received ride price estimates: \(response.prices)")
                    self?.priceEstimates = response.prices
                } catch {
                    print("Failed to decode API response data: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
    
    private var cancellables: Set<AnyCancellable> = []
}
