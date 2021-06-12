//
//  CueSheetEditorEditMeta.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/06.
//

import SwiftUI
import SwiftCueSheet

class CueSheetEditorEditMetaViewModel : ObservableObject {
    init(cueMeta: Binding<[CueSheetMeta]>, present: Binding<CueSheetAlertList?>, uuid: UUID) {
        self._cueMeta = cueMeta
        self._present = present
        self.uuid = uuid
        metaIndex = cueMeta.wrappedValue.firstIndex { $0.id == uuid } ?? 0
        
    }
    
    @Binding var cueMeta:[CueSheetMeta]
    @Binding var present: CueSheetAlertList?
    
    let uuid: UUID
    
    let metaIndex: Int
    var meta: CueSheetMeta { cueMeta[metaIndex] }
    
    @Published var value = String()
    
    func okCallEvent() -> Void {
        cueMeta[metaIndex].value = value
        cancelCallEvent()
    }
    
    func cancelCallEvent() -> Void {
        present = nil
        value = String()
    }
}

struct CueSheetEditorEditMeta: View {
    @ObservedObject var viewModel: CueSheetEditorEditMetaViewModel
    
    func getMe(_ callback: (Self) -> Void) -> Self {
        callback(self)
        return self
    }
    
    init(cueMeta: Binding<[CueSheetMeta]>, present: Binding<CueSheetAlertList?>, uuid: UUID) {
        viewModel = CueSheetEditorEditMetaViewModel(cueMeta: cueMeta, present: present, uuid: uuid)
    }
    
    private static let itemList = CSMetaKey.allCases.map { $0.caseName } + ["other"]
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Meta key : \(viewModel.meta.key.caseName.uppercased())")
                    Spacer()
                }
            }
            
            VStack {
                HStack {
                    Text(viewModel.value.isEmpty ? "Meta Value" : "Meta Value : \(viewModel.meta.value)")
                    Spacer()
                }
                TextField(viewModel.meta.value.isEmpty ? "Empty Data" : viewModel.meta.value, text: $viewModel.value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }.padding()
    }
}
