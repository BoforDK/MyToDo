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
//                    MapMarker(coordinate: $0.coordinate)
                    MapMarker(coordinate: $0.coordinate, tint: .green)
//                    MapAnnotation(coordinate: $0.coordinate) {
//                        ZStack {
//                            Circle()
//                                .strokeBorder(Color.red, lineWidth: 4)
//                                .frame(width: 40, height: 40)
//                            Text("1")
//                        }
//                    }
                }
                if viewModel.visible {
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 3)
                        .frame(width: 30, height: 30)
                }
            }
            if viewModel.visible {
            HStack {
                Button("Add marker") {
                    viewModel.addLocation()
                }
                Spacer()
                Button("Delete marker") {
                    viewModel.deleteLocation()
                }
            }
            }
        }
        .navigationTitle("Location")
        .onAppear {
            viewModel.startLocation()
        }
    }

    var marker: some View {
        HStack {
            Circle()
                .strokeBorder(Color.red, lineWidth: 4)
                .frame(width: 40, height: 40)
            Text("1")
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(viewModel: LocationViewModel(taskCellVM: TaskCellViewModel(task: Task()), visible: true))
    }
}
