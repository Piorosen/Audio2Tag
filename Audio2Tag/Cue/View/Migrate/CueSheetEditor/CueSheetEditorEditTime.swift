//
//  CueSheetEditorEditTime.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/08.
//

import SwiftUI
import Combine
import SwiftCueSheet

struct CueSheetEditorEditTime: View {
    @Binding var cueTrack: [CueSheetTrack]
    @Binding var present: CueSelectMode?
    
    init(cueTrack: Binding<[CueSheetTrack]>, present: Binding<CueSelectMode?>, trackUUID: UUID) {
        self._cueTrack = cueTrack
        self._present = present
        self.trackUUID = trackUUID
        self.trackIndex = cueTrack.wrappedValue.firstIndex { $0.id == trackUUID } ?? 0
        
        startTime = .init(time: cueTrack[trackIndex].wrappedValue.startTime)
        endTime = .init(time: cueTrack[trackIndex].wrappedValue.endTime)
    }
    
    let trackUUID: UUID
    let trackIndex: Int
    let startTime: CSIndexTime
    let endTime: CSIndexTime
    
    @State var trackStartTime = CueSheetTime(min: 0, sec: 0, frame: 0)
    @State var trackEndTime = CueSheetTime(min: 0, sec: 0, frame: 0)
    
    
    var body: some View {
        VStack {
            GroupBox(label: Text("Track Play-Time")) {
                VStack {
                    HStack {
                        Text("Start Time")
                        Spacer()
                    }
                    
                    HStack{
                        TextField("\(startTime.minutes) min", text: $trackStartTime.min)
                            .customToolBar()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        TextField("\(startTime.seconds) sec", text: $trackStartTime.sec)
                            .customToolBar()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        TextField("\(startTime.frames)", text: $trackStartTime.frame)
                            .customToolBar()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }
                .padding([.top])
                
                VStack {
                    HStack {
                        Text("End Time")
                        Spacer()
                    }
                    
                    HStack{
                        TextField("\(endTime.minutes) min", text: $trackEndTime.min)
                            .customToolBar()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            
                        TextField("\(endTime.seconds) sec", text: $trackEndTime.sec)
                            .customToolBar()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        TextField("\(endTime.frames) frame", text: $trackEndTime.frame)
                            .customToolBar()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }
                
            }.padding()
            Spacer()
        }
        
        .navigationTitle("Appending")
        .navigationBarItems(trailing: Button(action: {
            var time = cueTrack.map { CSLengthOfAudio(startTime: $0.startTime, endTime: $0.endTime )}
            time[trackIndex] = CSLengthOfAudio(startTime: trackStartTime.totalSeconds, endTime: trackEndTime.totalSeconds)
            
            cueTrack = CueSheet.makeTrack(time: time, tracks: cueTrack.map {
                CSTrack(trackNum: $0.trackNum, trackType: $0.trackType, index: [CSIndex](), rem: $0.rem.reduce(CSRem(), { now, elem in
                    var copy = now
                    copy[elem.key] = elem.value
                    return copy
                }), meta: $0.meta.reduce(CSMeta(), { now, elem in
                    var copy = now
                    copy[elem.key] = elem.value
                    return copy
                }))
            })
            .enumerated()
            .map { (index, e) in
                CueSheetTrack(meta: e.meta.map { CueSheetMeta(key: $0.key, value: $0.value)},
                              rem: e.rem.map { CueSheetRem(key: $0.key, value: $0.value) },
                              trackNum: e.trackNum,
                              trackType: e.trackType,
                              index: e.index,
                              startTime: time[index].startTime,
                              endTime: time[index].endTime)
            }
            present = nil
        }) {
            Text("Add")
        })
        
        Spacer()
    }
}
