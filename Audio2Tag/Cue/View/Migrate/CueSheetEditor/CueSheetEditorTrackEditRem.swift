//
//  CueSheetEditorTrackEditRem.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/08.
//

import SwiftUI
import SwiftCueSheet

struct CueSheetEditorTrackEditRem: View {
//    (cueTrack: $cueTrack, present: $present, track: track, rem: rem)
    
    @Binding var cueTrack: [CueSheetTrack]
    @Binding var present: CueSheetAlertList?
    
    let trackUUID: UUID
    let remUUID: UUID
    
    var trackIndex: Int { cueTrack.firstIndex { $0.id == trackUUID } ?? 0 }

    var remIndex: Int { cueTrack[trackIndex].rem.firstIndex { $0.id == remUUID } ?? 0 }
    var rem: CueSheetRem { cueTrack[trackIndex].rem[remIndex] }
    
    @State var value = String()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Meta key : \(rem.key.caseName)")
                    Spacer()
                }
            }.padding([.top])
            
            VStack {
                HStack {
                    Text(value.isEmpty ? "Meta Value" : "Meta Value : \(rem.value)")
                    Spacer()
                }
                TextField(rem.value.isEmpty ? "Empty Data" : rem.value, text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }.padding()
        .navigationBarItems(trailing: Button(action: {
            cueTrack[trackIndex].rem[remIndex].value = value
            present = nil
        }) {
            Text("Edit")
        })
    }
}
