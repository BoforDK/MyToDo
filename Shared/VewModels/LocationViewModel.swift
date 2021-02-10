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
    var visible: Bool
    var taskCellVM: TaskCellViewModel
    
    init(taskCellVM: TaskCellViewModel, visible: Bool) {
        self.taskCellVM = taskCellVM
        self.visible = visible
        if let location = taskCellVM.task.location {
            annotations = [Location(name: taskCellVM.task.title, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))]
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
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
    
    func deleteLocation() {
        annotations = []
        taskCellVM.task.location = nil
    }
}
