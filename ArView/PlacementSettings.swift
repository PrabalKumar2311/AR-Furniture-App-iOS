//
//  PlacementSettings.swift
//  ArView
//
//  Created by Prabal Kumar on 08/10/24.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject {
    
    //When user selects a model in browswerView, this property is set
    @Published var selectedModel: Model? {
        willSet(newValue){
            print("Settings selectedModel to \(String(describing: newValue?.name))")
        }
    }
    
    //when the user taps confirm in placementview, the value of selected model is assigned to confirmedModel
    @Published var confirmedModel: Model?{
        willSet(newValue) {
            guard let model = newValue else{
                print("Clearing confirmedModel")
                return
            }
            print("Setting confirmedModel to \(model.name)")
            
            self.recentlyPlaced.append(model)
        }
    }
    
    @Published var recentlyPlaced: [Model] = []
    
    var sceneObserver: Cancellable?
}
