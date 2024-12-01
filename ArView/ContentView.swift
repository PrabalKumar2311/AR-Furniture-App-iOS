//
//  ContentView.swift
//  ArView
//
//  Created by Prabal Kumar on 08/10/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @State var isControlsVisible:Bool = true
    @State var showBrowse:Bool = false
    @State var showSettings:Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            ARViewContainer()
            
            
            if self.placementSettings.selectedModel == nil{
                ControlView(isControlsVisible: $isControlsVisible, showBrowse: $showBrowse, showSettings: $showSettings)
            }
            else{
                PlacementView()
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable{
    @EnvironmentObject var placementSettings:PlacementSettings
    @EnvironmentObject var sessionSettings:SessionSettings
    func makeUIView(context: Context) -> CustomARView {
        
        let arView = CustomARView(frame: .zero,sessionSettings: sessionSettings)
        
        //add subscriber
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            
            self.updateScene(for: arView)
            //call update scene method
            
        })
        
        return arView
    }

    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    private func updateScene(for arView: CustomARView){
        // display focus entity logic
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity{
            
            self.place(modelEntity, in: arView)
            
            self.placementSettings.confirmedModel = nil
            
        }
    }
    
    private func place(_ modelEntity: ModelEntity, in arView: ARView){
        //clone model entity. this cretes n identical copy of modelEntity and refrences the same model. this also allows us to have multiple models of the same asset in out scene
        let clonedEntity = modelEntity.clone(recursive: true)
        
        //Enable translation and rotation gestures.
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: clonedEntity)
        
        // Create an anchor Entity and add clonedEntity to the anchorEntity
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        
        // Add the anchor Entity to the arView.scene
        arView.scene.addAnchor(anchorEntity)
        
        print("Added Entity model to scene")
    }
}

#Preview {
    ContentView()
        .environmentObject(PlacementSettings())
        .environmentObject(SessionSettings())
}
