import SwiftUI

struct BrowseView: View {
    @Binding var showBrowse: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                RecentsGrid(showBrowse: $showBrowse)
                ModelsByCategoryGrid(showBrowse: $showBrowse)
            }
            .navigationTitle("Browse")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showBrowse = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct RecentsGrid: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse:Bool
    
    var body: some View {
        if !self.placementSettings.recentlyPlaced.isEmpty {
            HorizontalGrid(showBrowse: $showBrowse, title: "Recents", items: getRecentsUniqueOrdered())
        }
    }
    
    func getRecentsUniqueOrdered() -> [Model] {
        var recentsUniqueOrderedArray: [Model] = []
        var modelNameSet: Set<String> = []
        
        for model in self.placementSettings.recentlyPlaced.reversed() {
            if !modelNameSet.contains(model.name) {
                recentsUniqueOrderedArray.append(model)
                modelNameSet.insert(model.name)
            }
        }
        return recentsUniqueOrderedArray
    }
    
}

struct ModelsByCategoryGrid: View {
    @Binding var showBrowse:Bool
    let models = Models()
    
    var body: some View {
        VStack {
            ForEach(ModelCategory.allCases, id: \.self) { category in
                let modelsByCategory = models.get(category: category)
                // Only display if the category has at least one model in it
                if !modelsByCategory.isEmpty {
                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: modelsByCategory)
                }
            }
        }
    }
}

struct HorizontalGrid: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse:Bool
    var title: String
    var items: [Model]
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: columns, spacing: 30) {
                    ForEach(0..<items.count) { index in
                        let model = items[index]
                        
                        ItemButton(model: model) {
                            model.asyncLoadModeEntity()
                            self.placementSettings.selectedModel = model
                            print("Browser selected \(model.name) for placement")
                            showBrowse = false
                        }
                    }
                }
            }
            Seprator()
        }
        .padding([.leading, .top])
    }
}

struct ItemButton: View {
    
    let model: Model
    let action: () -> Void
    
    var body: some View {
        Button{
            self.action()
        } label: {
            Image(uiImage: self.model.thumbnail)
                .resizable()
                .frame(height: 150)
                .aspectRatio(1/1, contentMode: .fit)
                .background(Color.secondary)
                .cornerRadius(10)
        }
    }
}


struct Seprator:View {
    var body: some View {
        Divider()
            .padding([.horizontal,.vertical])
    }
}

#Preview {
    BrowseView(showBrowse: .constant(true))
}
