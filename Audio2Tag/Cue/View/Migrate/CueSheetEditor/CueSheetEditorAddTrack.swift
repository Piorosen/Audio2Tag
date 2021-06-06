//
//  CueSheetEditorAddTrack.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/06.
//

import SwiftUI
import SwiftCueSheet
import Combine

struct CueSheetEditorAddTrack: View {
    @Binding var cueTrack:[CueSheetTrack]
    @Binding var present: CueSelectMode?
    
    @State var trackTitle = String()
    @State var trackInsertIndex: Int = 0
    @State var trackInsertPositionPrivous = false
    @State var trackAudioToggle = true
    @State var trackNum = String()
    @State var trackStartTime = CSIndexTime(min: 0, sec: 0, frame: 0)
    @State var trackEndTime = CSIndexTime(min: 0, sec: 0, frame: 0)
    
    
    
    var body: some View {
        ScrollView {
            VStack {
                GroupBox(label: Text("Track Info")) {
                    TextField("Title", text: $trackTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    TextField("Track Index Number", text: $trackNum)
                        .customToolBar()
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(trackNum)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                trackNum = filtered
                            }
                        }
                    
                }
                GroupBox(label: Text("Track Type")) {
                    VStack {
                        Text("Audio")
                            .frame(maxWidth: .infinity)
                            .padding()
                            // True -> Color.init(UIColor.secondarySystemFill)
                            // False -> Color.init(UIColor.systemBackground)
                            .background(Color.init(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.init(UIColor.systemBlue), lineWidth: trackAudioToggle ? 1 : 0))
                            .onTapGesture {
                                trackAudioToggle = true
                            }
                        
                        Text("Video")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.init(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            .overlay(RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.init(UIColor.systemBlue), lineWidth: trackAudioToggle ? 0 : 1))
                            .onTapGesture {
                                trackAudioToggle = false
                            }
                    }
                    .padding([.top])
                    
                }
                GroupBox(label: Text("Track Play-Time")) {
                    VStack {
                        HStack {
                            Text("Start Time")
                            Spacer()
                        }
                        
                        HStack{
                            TextField("min", text: $trackTitle)
                                .customToolBar()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            TextField("sec", text: $trackTitle)
                                .customToolBar()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            TextField("frame", text: $trackTitle)
                                .customToolBar()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                    }.padding()
                    
                    VStack {
                        HStack {
                            Text("End Time")
                            Spacer()
                        }
                        
                        HStack{
                            TextField("min", text: $trackTitle)
                                .customToolBar()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            TextField("sec", text: $trackTitle)
                                .customToolBar()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            TextField("frame", text: $trackTitle)
                                .customToolBar()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                    }.padding()
                    
                }
                
                if cueTrack.count != 0 {
                    GroupBox(label: Text("Insert Position")) {
                        Picker("", selection: $trackInsertIndex) {
                            ForEach(cueTrack.indices, id: \.self) { trackIdx in
                                Text("\(trackIdx + 1) : \(cueTrack[trackIdx].title)")
                                    .tag(trackIdx)
                            }
                        }
                        HStack {
                            Text("Previous")
                                .frame(maxWidth: .infinity)
                                .padding()
                                // True -> Color.init(UIColor.secondarySystemFill)
                                // False -> Color.init(UIColor.systemBackground)
                                .background(Color.init(UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.init(UIColor.systemBlue), lineWidth: trackInsertPositionPrivous ? 1 : 0))
                                .onTapGesture {
                                    trackInsertPositionPrivous = true
                                }
                            
                            Text("Next")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.init(UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                
                                .overlay(RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.init(UIColor.systemBlue), lineWidth: trackInsertPositionPrivous ? 0 : 1))
                                .onTapGesture {
                                    trackInsertPositionPrivous = false
                                }
                        }
                        .padding([.top])
                    }
                }
                
                //                CSTrack(trackNum: <#T##Int#>, trackType: <#T##String#>, index: <#T##[CSIndex]#>, rem: <#T##CSRem#>, meta: <#T##CSMeta#>)
            }.padding()
        }
        .navigationTitle("Appending")
        .navigationBarItems(trailing: Button(action: {
            guard let num = Int(trackNum) else {
                return
            }
            
            var newTrack = cueTrack.map { (CSLengthOfAudio(startTime: $0.startTime , endTime: $0.endTime),
                                           CSTrack(trackNum: $0.trackNum,
                                                   trackType: $0.trackType,
                                                   index: $0.index,
                                                   rem: $0.rem.reduce(CSRem(), { r, e in
                                                    var p = r
                                                    p[e.key] = e.value
                                                    return p
                                                   }),
                                                   meta: $0.meta.reduce(CSMeta(), { r, e in
                                                    var p = r
                                                    p[e.key] = e.value
                                                    return p
                                                   }))
            )}
            
            let type: String
            if trackAudioToggle {
                type = "Audio"
            }else {
                type = "Video"
            }
            let index: Int
            if cueTrack.count != 0 {
                if trackInsertPositionPrivous {
                    index = trackInsertIndex
                }else {
                    index = trackInsertIndex + 1
                }
            }else {
                index = 0
            }
            
            newTrack.insert((CSLengthOfAudio(startTime: trackStartTime.totalSeconds, endTime: trackEndTime.totalSeconds), CSTrack(trackNum: num, trackType: type, index: [CSIndex](), rem: CSRem(), meta: [.title: trackTitle])),
                            at: index)
            
            cueTrack = zip(CueSheet.makeTrack(data: newTrack), newTrack.map { $0.0 }).map { (track, audio) in
                CueSheetTrack(title: (track.meta[.title] ?? String()),
                              meta: track.meta.map { CueSheetMeta(key: $0.key, value: $0.value) },
                              rem: track.rem.map { CueSheetRem(key: $0.key, value: $0.value) },
                              trackNum: track.trackNum,
                              trackType: track.trackType,
                              index: track.index,
                              startTime: audio.startTime,
                              endTime: audio.endTime)
            }
            
            present = nil
        }) {
            Text("Add")
        })
    }
}
