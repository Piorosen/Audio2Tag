//
//  CueSheetEditorEditRem.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/06.
//

import SwiftUI
import SwiftCueSheet

class CueSheetEditorEditRemViewModel : ObservableObject {
    init(cueRem: Binding<[CueSheetRem]>, present: Binding<CueSheetAlertList?>, uuid: UUID) {
        self._cueRem = cueRem
        self._present = present
        self.uuid = uuid
        self.remIndex = cueRem.wrappedValue.firstIndex { $0.id == uuid } ?? 0
    }
    
    @Binding var cueRem: [CueSheetRem]
    @Binding var present: CueSheetAlertList?
    
    let uuid: UUID
    
    let remIndex: Int
    var rem: CueSheetRem { cueRem[remIndex] }
    
    @Published var value = String()
    
    func okCallEvent() -> Void {
        cueRem[remIndex].value = value
        cancelCallEvent()
    }
    
    func cancelCallEvent() -> Void {
        present = nil
        value = String()
    }
}

struct CueSheetEditorEditRem: View {
    @ObservedObject var viewModel: CueSheetEditorEditRemViewModel
    
    func getMe(_ callback: (Self) -> Void) -> Self {
        callback(self)
        return self
    }
    
    init(cueRem: Binding<[CueSheetRem]>, present: Binding<CueSheetAlertList?>, uuid: UUID) {
        viewModel = CueSheetEditorEditRemViewModel(cueRem: cueRem, present: present, uuid: uuid)
    }
    
    private static let itemList = CSRemKey.allCases.map { $0.caseName } + ["other"]
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Meta key : \(viewModel.rem.key.caseName)")
                    Spacer()
                }
            }.padding([.top])
            
            VStack {
                HStack {
                    Text(viewModel.value.isEmpty ? "Meta Value" : "Meta Value : \(viewModel.rem.value)")
                    Spacer()
                }
                TextField(viewModel.rem.value.isEmpty ? "Empty Data" : viewModel.rem.value, text: $viewModel.value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }.padding()
    }
}
