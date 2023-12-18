//
//  ContentView.swift
//  RideBetter
//
//  Created by Maryam Afshar on 2023-12-10.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @Binding var s1: Double
    @Binding var s2: Double
    @Binding var e1: Double
    @Binding var e2: Double
    
    @Environment(\.presentationMode) var presentationMode
    @State private var directions: [String] = []
      @State private var showDirections = false

      var body: some View {
          VStack {
              MapView(directions: $directions, s1: $s1, s2: $s2, e1: $e1, e2: $e2)
              
              Text("Does this Route Look Correct?").padding(10)
              
              HStack {
                  Button("No") {
                      presentationMode.wrappedValue.dismiss()
                      
                  }
                  Button("Yes") {
                      self.showDirections.toggle()
                  }
                  .disabled(directions.isEmpty)
                  .padding()
              }}.sheet(isPresented: $showDirections, content: {
          VStack(spacing: 0) {
            Text("Better Ride")
              .font(.largeTitle)
              .bold()
              .padding()
              LyftVsUber(s1: $s1, s2: $s2, e1: $e1, e2: $e2)
          }
        })
      }
    }

    struct MapView: UIViewRepresentable {
      typealias UIViewType = MKMapView
      
      @Binding var directions: [String]
        @Binding var s1: Double
        @Binding var s2: Double
        @Binding var e1: Double
        @Binding var e2: Double
      
      func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
      }
      
      func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(
          center: CLLocationCoordinate2D(latitude: 37.33181, longitude: -122.03118),
          span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        
        // START
          let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: s1, longitude: s2))
        
        // END
          let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: e1, longitude: e2))
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
          guard let route = response?.routes.first else { return }
          mapView.addAnnotations([p1, p2])
          mapView.addOverlay(route.polyline)
          mapView.setVisibleMapRect(
            route.polyline.boundingMapRect,
            edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
            animated: true)
          self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        return mapView
      }
      
      func updateUIView(_ uiView: MKMapView, context: Context) {
      }
      
      class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
          let renderer = MKPolylineRenderer(overlay: overlay)
          renderer.strokeColor = .systemBlue
          renderer.lineWidth = 5
          return renderer
        }
      }
    
}


struct LocationView_Previews: PreviewProvider {
    //let startingAddress: String
    @State static var s1: Double = 0.0
    @State static var s2: Double = 0.0
    @State static var e1: Double = 0.0
    @State static var e2: Double = 0.0
    
    static var previews: some View {
        LocationView(s1: $s1, s2: $s2, e1: $e1, e2: $e2)
    }
}
