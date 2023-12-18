//
//  ContentViewModel.swift
//  RideBetter
//
//  Created by Maryam Afshar on 2023-12-12.
//

import Foundation
import MapKit

class ContentViewModel: NSObject, ObservableObject {
    
    @Published private(set) var results: Array<AddressResult> = []
    @Published var searchableText1 = ""
    @Published var searchableText2 = ""

    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
    func searchAddress1(_ searchableText1: String) {
        guard searchableText1.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchableText1
    }
    
    func searchAddress2(_ searchableText2: String) {
        guard searchableText2.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchableText2
    }
}

extension ContentViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            results = completer.results.map {
                AddressResult(title: $0.title, subtitle: $0.subtitle)
            }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
