//
//  CueSheetEditorTrackEditMeta.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/08.
//

import SwiftUI
import SwiftCueSheet

class CueSheetEditorTrackEditMetaViewModel : ObservableObject {
    
    init(cueTrack: Binding<[CueSheetTrack]>, present: Binding<CueSheetAlertList?>, trackUUID: UUID, metaUUID:UUID) {
        self._cueTrack = cueTrack
        self._present = present
        self.trackUUID = trackUUID
        self.metaUUID = metaUUID
        
        trackIndex = cueTrack.wrappedValue.firstIndex { $0.id == trackUUID } ?? 0
        metaIndex = cueTrack[trackIndex].meta.wrappedValue.firstIndex { $0.id == metaUUID } ?? 0
    }
    
    @Binding var cueTrack: [CueSheetTrack]
    @Binding var present: CueSheetAlertList?
    
    let trackUUID: UUID
    let metaUUID: UUID
    
    let trackIndex: Int
    let metaIndex: Int
    var meta: CueSheetMeta { cueTrack[trackIndex].meta[metaIndex] }
    
    @Published var value = String()
    
    func okCallEvent() -> Void {
        cueTrack[trackIndex].meta[metaIndex].value = value
        cancelCallEvent()
    }
    
    func cancelCallEvent() -> Void {
        present = nil
        value = String()
    }
}

struct CueSheetEditorTrackEditMeta: View {
    @ObservedObject var viewModel: CueSheetEditorTrackEditMetaViewModel
    
    func getMe(_ callback: (Self) -> Void) -> Self {
        callback(self)
        return self
    }
    
    init(cueTrack: Binding<[CueSheetTrack]>, present: Binding<CueSheetAlertList?>, trackUUID: UUID, metaUUID:UUID) {
        viewModel = CueSheetEditorTrackEditMetaViewModel(cueTrack: cueTrack, present: present, trackUUID: trackUUID, metaUUID: metaUUID)
    }
    
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
