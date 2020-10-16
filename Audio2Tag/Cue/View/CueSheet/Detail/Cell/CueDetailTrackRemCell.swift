//
//  CueDetailListInfoRemSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

class CueDetailTrackRemCellViewModel : ObservableObject {
    @Binding var rem: [RemModel]
    @Published var openAlert = false
    
    var addRem: () -> Void = { }
    var editRem: (_ idx:Int, _ rem:RemModel) -> Void = { _, _ in }
    
    init(rem: Binding<[RemModel]>) {
        self._rem = rem
    }
    
    
    
    
}

struct CueDetailTrackRemCell: View {
    @ObservedObject var viewModel: CueDetailTrackRemCellViewModel
    @State var key = ""
    @State var value = ""
    
    init(rem: Binding<[RemModel]>) {
        viewModel = CueDetailTrackRemCellViewModel(rem: rem)
    }
    
    // MARK: - Handler
    
    func onRequestAddRem(_ action: @escaping () -> Void) -> CueDetailTrackRemCell {
        let copy = self
        copy.viewModel.addRem = action
        return copy
    }
    func onRequestEditRem(_ action: @escaping (_ idx:Int, _ rem:RemModel) -> Void) -> CueDetailTrackRemCell {
        let copy = self
        copy.viewModel.editRem = action
        return copy
    }
    
    // MARK: - BODY
    var body: some View {
        Section(header: Text("Rem")) {
            ForEach (self.viewModel.rem.indices) { idx in
                Button(action: {
                    viewModel.editRem(idx, viewModel.rem[idx])
                }) {
                    HStack {
                        Text("\(viewModel.rem[idx].value.key)")
                        Spacer()
                        Text("\(viewModel.rem[idx].value.value)")
                    }
                }
            }
            AddButton("REM 추가") {
                viewModel.openAlert = true
                viewModel.addRem()
            }
        }
    }
}
