//
//  CueSheetEditorTrackEditRem.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/08.
//

import SwiftUI
import SwiftCueSheet

class CueSheetEditorTrackEditRemViewModel : ObservableObject {
    init(cueTrack: Binding<[CueSheetTrack]>, present: Binding<CueSheetAlertList?>, trackUUID: UUID, remUUID:UUID) {
        self._cueTrack = cueTrack
        self._present = present
        self.trackUUID = trackUUID
        self.remUUID = remUUID
        
        trackIndex = cueTrack.wrappedValue.firstIndex { $0.id == trackUUID } ?? 0
        remIndex = cueTrack[trackIndex].rem.wrappedValue.firstIndex { $0.id == remUUID } ?? 0
    }
    
    
    @Binding var cueTrack: [CueSheetTrack]
    @Binding var present: CueSheetAlertList?
    
    let trackUUID: UUID
    let remUUID: UUID
    
    let trackIndex: Int
    let remIndex: Int
    var rem: CueSheetRem { cueTrack[trackIndex].rem[remIndex] }
    
    @Published var value = String()
    
    func okCallEvent() -> Void {
        cueTrack[trackIndex].rem[remIndex].value = value
        cancelCallEvent()
    }
    
    func cancelCallEvent() -> Void {
        value = String()
        present = nil
    }
}

struct CueSheetEditorTrackEditRem: View {
    @ObservedObject var viewModel: CueSheetEditorTrackEditRemViewModel
    
    func getMe(_ callback: (Self) -> Void) -> Self {
        callback(self)
        return self
    }
    
    
    init(cueTrack: Binding<[CueSheetTrack]>, present: Binding<CueSheetAlertList?>, trackUUID: UUID, remUUID:UUID) {
        viewModel = CueSheetEditorTrackEditRemViewModel(cueTrack: cueTrack, present: present, trackUUID: trackUUID, remUUID: remUUID)
    }
    
    @State var value = String()
    
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
                    Text(value.isEmpty ? "Meta Value" : "Meta Value : \(viewModel.rem.value)")
                    Spacer()
                }
                TextField(viewModel.rem.value.isEmpty ? "Empty Data" : viewModel.rem.value, text: $viewModel.value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }.padding()
    }
}
