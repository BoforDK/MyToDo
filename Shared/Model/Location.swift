//
//  Location.swift
//  MyToDo
//
//  Created by Alexander on 2/10/21.
//

import Foundation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
