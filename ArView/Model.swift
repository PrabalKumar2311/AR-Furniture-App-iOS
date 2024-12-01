//
//  Model.swift
//  ArView
//
//  Created by Prabal Kumar on 08/10/24.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
    case table
    case chair
    case decor
    case bed
    
    var label: String {
        get{
            switch self {
            case .table: return "Table"
            case .chair: return "Chair"
            case .decor: return "Decor"
            case .bed: return "Bed"
            }
        }
    }
}

class Model{
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage 
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory,scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    func asyncLoadModeEntity() {
        let filename = self.name + ".usdz"
        
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                
                switch loadCompletion {
                case .failure(let error): print("Unable to laod modelEntity for \(filename). Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
                
            }, receiveValue: { modelEntity in
                
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                print("modelEntity for \(self.name) has been loaded")
            })
    }
}

struct Models{
    var all: [Model] = []
    
    init () {
        //Tables
        let diningTable = Model(name: "WoodenTable", category: .table,scaleCompensation: 20/100)
        
        let table = Model(name: "Table", category: .table,scaleCompensation: 50/100)//nope
        
        let desk = Model(name: "Desk", category: .table,scaleCompensation: 70/100)
        
        let deskWhite = Model(name: "TableFurniture", category: .table,scaleCompensation: 30/100)
        
        let tvTable = Model(name: "TvTable", category: .table,scaleCompensation: 30/100)
        
        self.all += [diningTable, table, desk, deskWhite, tvTable]
        
        //Chairs
        let diningChair = Model(name: "WoodenChair", category: .chair,scaleCompensation: 120/100)
        
        let sofa = Model(name: "Sofa", category: .chair,scaleCompensation: 50/100)
        
        let luxurySofa = Model(name: "LuxurySofa", category: .chair,scaleCompensation: 80/100)
        
        let modernChair = Model(name: "ModernChair", category: .chair,scaleCompensation: 80/100)
        
        self.all += [diningChair, luxurySofa,sofa,modernChair]
        
        //Beds
        let bedWooden = Model(name: "WoodenBed", category: .bed,scaleCompensation: 70/100)
        
        self.all += [bedWooden]
        
        //Decor
        let tvSet = Model(name: "LivingRoom", category: .decor,scaleCompensation: 50/100)
        
        let decorative = Model(name: "Decorative", category: .decor,scaleCompensation: 60/100)
        
        let pancakes = Model(name: "pancakes", category: .decor,scaleCompensation: 70/100)
        
        let car = Model(name: "car", category: .decor,scaleCompensation: 90/100)
        
        let flowerTulip = Model(name: "flower_tulip", category: .decor,scaleCompensation: 70/100)
        
        let toyAirplane = Model(name: "ToyAirplane", category: .decor,scaleCompensation: 70/100)
        
        let teaPot = Model(name: "Teapot", category: .decor,scaleCompensation: 70/100)
        
        let teaCup = Model(name: "Teacup", category: .decor,scaleCompensation: 70/100)
        
        let oldTv = Model(name: "OldTv", category: .decor,scaleCompensation: 70/100)
        
        let guitar = Model(name: "Guitar", category: .decor,scaleCompensation: 90/100)
        
        self.all += [tvSet, decorative,pancakes,car,flowerTulip,toyAirplane,teaPot,teaCup,oldTv,guitar]
        
    }
    
    func get(category: ModelCategory) -> [Model] {
        return all.filter( {$0.category == category} )
    }
}
