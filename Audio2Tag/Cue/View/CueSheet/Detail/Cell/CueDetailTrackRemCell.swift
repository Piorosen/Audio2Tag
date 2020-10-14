//
//  CueDetailListInfoRemSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

class CueDetailTrackRemCellViewModel : ObservableObject {
    @State var openSheet = false
    
    @State var sheetKey = ""
    @State var sheetValue = ""
    
    private var _rem = [RemModel]()
    var remChanged = { (_:[RemModel]) -> Void in }
    
    var rem: [RemModel] {
        get {
            return _rem
        }
        set {
            _rem = newValue
            remChanged(newValue)
        }
    }
    
    init(_ rem: [RemModel]) {
        self.rem = rem
    }
    
    func add() {
        rem.append(RemModel(value: (sheetKey, sheetValue)))
    }
    
    
}

struct CueDetailTrackRemCell: View {
    @ObservedObject var viewModel: CueDetailTrackRemCellViewModel
    
    init(rem: [RemModel]) {
        viewModel = CueDetailTrackRemCellViewModel(rem)
    }
    
    func makeSheet() -> some View {
        NavigationView {
            VStack {
                GroupBox {
                    VStack(alignment: .leading) {
                        Text("Key 값")
                        TextField("Key 값", text: $viewModel.sheetKey)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                GroupBox {
                    VStack(alignment: .leading) {
                        Text("Value 값")
                        TextField("Value 값", text: $viewModel.sheetValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Rem 추가")
        }.onDisappear(perform: viewModel.add)
    }
    
    
    // MARK: - Handler
    
    
    func onRemChanged(_ action: @escaping ([RemModel]) -> Void) -> CueDetailTrackRemCell {
        let copy = self
        copy.viewModel.remChanged = action
        return copy
    }
    
    
    // MARK: - BODY
    var body: some View {
        Section(header: Text("Rem")) {
            ForEach (self.viewModel.rem) { item in
                HStack {
                    Text("\(item.value.key)")
                    Spacer()
                    Text("\(item.value.value)")
                }
            }
//            AddButton("REM 추가") {
//                viewModel.openSheet = true
//            }
        }
//        .sheet(isPresented: $viewModel.openSheet, content: makeSheet)
    }
}
