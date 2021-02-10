//
//  LocationViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/10/21.
//

import Foundation
import MapKit
import SwiftUI
import Firebase

class LocationViewModel: ObservableObject {
    @Published var annotations: [Location] = []
    @Published var userTrackingMode: MapUserTrackingMode = .follow
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Published var manager = CLLocationManager()
    var taskCellVM: TaskCellViewModel
    
    init(taskCellVM: TaskCellViewModel) {
        self.taskCellVM = taskCellVM
        if let location = taskCellVM.task.location {
            annotations = [Location(name: taskCellVM.task.title, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))]
        }
    }
    
    func startLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    func addLocation() {
        annotations = [Location(name: "", coordinate: region.center)]
        taskCellVM.task.location = GeoPoint(latitude: region.center.latitude, longitude: region.center.longitude)
    }
}
