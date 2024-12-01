//
//  ControlView.swift
//  ArView
//
//  Created by Prabal Kumar on 08/10/24.
//

import SwiftUI

struct ControlView: View {
    
    @Binding var isControlsVisible: Bool
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    
    
    var body: some View {
        VStack{
            ControlVisibilityButton(isControlsVisible: $isControlsVisible)
            
            Spacer()
            
            if(isControlsVisible){
                ControlButtonBar(showBrowse: $showBrowse, showSettings: $showSettings)
            }
        }
    }
}

struct ControlVisibilityButton: View {
    
    @Binding var isControlsVisible: Bool
    
    var body: some View {
        HStack{
            
            Spacer()
            
            ZStack{
                
                Color.black.opacity(0.25)
                
                Button{
                    isControlsVisible.toggle()
                }label: {
                    Image(systemName: self.isControlsVisible ? "rectangle" : "slider.horizontal.below.rectangle")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
        

                }
                .padding()
            }
            .cornerRadius(10)
            .frame(width: 45,height: 45)
        }
        .padding(.top,60)
        .padding(.trailing,60)
    }
}

struct ControlButtonBar: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse:Bool
    @Binding var showSettings:Bool
    
    var body: some View {
        HStack{
            
            Spacer()
            
            MostRecentlyPlacementButton().hidden(self.placementSettings.recentlyPlaced.isEmpty)
            
            Spacer()
            
            
            Button{
                self.showBrowse.toggle()
            }label: {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
            }
            .sheet(isPresented: $showBrowse){
                BrowseView(showBrowse: $showBrowse)
            }
            
            Spacer()
            
            Button{
                print("Settings button pressed")
                self.showSettings.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
            }
            .sheet(isPresented: $showSettings){
                SettingsView(showSettings: $showSettings)
//                    .presentationDetents([.fraction(0.3)])
            }
            
            Spacer()
        }
        .frame(maxWidth: 500,maxHeight: 50)
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(50)
        .padding([.horizontal,.bottom])
//        .padding(.bottom,-20)
//        .ignoresSafeArea(.all)
    }
}

struct MostRecentlyPlacementButton: View {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var body: some View {
        Button{
            print("Most recently placed button pressed")
            
            self.placementSettings.selectedModel = self.placementSettings.recentlyPlaced.last
        } label: {
            if let mostRecentlyPlaced = self.placementSettings.recentlyPlaced.last{
                Image(uiImage: mostRecentlyPlaced.thumbnail)
                    .resizable()
                    .frame(width: 46)
                    .aspectRatio(1/1, contentMode: .fit)
            }
            else{
                Image(systemName: "clock")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 50, height: 50)
        .background(Color.white)
        .cornerRadius(8)
    }
}



#Preview {
    ControlView(isControlsVisible: .constant(true), showBrowse: .constant(false), showSettings: .constant(false))
}
