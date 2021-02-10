//
//  LocationView.swift
//  MyToDo
//
//  Created by Alexander on 2/9/21.
//

import SwiftUI
import UIKit
import MapKit

struct LocationView: View {
    @ObservedObject var viewModel: LocationViewModel

    var body: some View {
        VStack {
            ZStack {
                Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $viewModel.userTrackingMode, annotationItems: viewModel.annotations) {
//                    MapPin(coordinate: $0.coordinate)
                    MapMarker(coordinate: $0.coordinate)
                }
                Circle()
                    .strokeBorder(Color.red, lineWidth: 4)
                    .frame(width: 40, height: 40)
            }
            Button("plus") {
                viewModel.addLocation()
            }
        }
        .onAppear {
            print("AHoj")
            viewModel.startLocation()
        }
    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(viewModel: LocationViewModel(taskCellVM: TaskCellViewModel(task: Task())))
    }
}
