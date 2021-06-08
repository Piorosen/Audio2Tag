//
//  CueSheetEditorTrackEditMeta.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/08.
//

import SwiftUI
import SwiftCueSheet

struct CueSheetEditorTrackEditMeta: View {
    @Binding var cueTrack: [CueSheetTrack]
    @Binding var present: CueSheetAlertList?
    
    let trackUUID: UUID
    let metaUUID: UUID
    
    var trackIndex: Int { cueTrack.firstIndex { $0.id == trackUUID } ?? 0 }

    var metaIndex: Int { cueTrack[trackIndex].meta.firstIndex { $0.id == metaUUID } ?? 0 }
    var meta: CueSheetMeta { cueTrack[trackIndex].meta[metaIndex] }
    
    @State var value = String()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Meta key : \(meta.key.caseName)")
                    Spacer()
                }
            }.padding([.top])
            
            VStack {
                HStack {
                    Text(value.isEmpty ? "Meta Value" : "Meta Value : \(meta.value)")
                    Spacer()
                }
                TextField(meta.value.isEmpty ? "Empty Data" : meta.value, text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }.padding()
        .navigationBarItems(trailing: Button(action: {
            cueTrack[trackIndex].meta[metaIndex].value = value
            
            present = nil
        }) {
            Text("Edit")
        })
    }
}
