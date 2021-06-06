//
//  CueSheetEditorView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/03.
//

import SwiftUI
import SwiftCueSheet
import Combine
import Introspect

extension CSRemKey : CaseIterable {
    public static var allCases: [CSRemKey] = {
        [.comment, .composer, .date, .discId, .genre, .title]
    }()
}

extension CSMetaKey : CaseIterable {
    public static var allCases: [CSMetaKey] = {
        [.isrc, .performer, .songWriter, .title]
    }()
}

fileprivate extension TextField {
    func customToolBar() -> some View {
        return self.introspectTextField { (textField) in
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
            toolBar.items = [flexButton, doneButton]
            toolBar.setItems([flexButton, doneButton], animated: true)
            textField.inputAccessoryView = toolBar
        }
    }
}

fileprivate extension  UITextField {
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
        self.resignFirstResponder()
    }
}

extension CueSheetEditorView {
    func makeAddMeta() -> some View {
        return ScrollView {
            VStack {
                GroupBox(label: Text("Meta Key")) {
                    Picker("Key", selection: $remKey) {
                        ForEach (metaItemList, id: \.self) { item in
                            Text(item)
                        }
                    }.onAppear {
                        remKey = metaItemList[0]
                    }
                    if remKey == "other" {
                        TextField("other key", text: $remWriteKey)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                GroupBox(label: Text("Meta Value")) {
                    TextField("value", text: $remValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Spacer()
            }.padding()
        }
        .navigationTitle("Appending")
        .navigationBarItems(trailing: Button(action: {
            if remKey == "other" {
                if remWriteKey == "" {
                    return
                }
                cueMeta.append(.init(key: .init(remWriteKey), value: remValue))
            }else {
                cueMeta.append(.init(key: .init(remKey), value: remValue))
            }
            present = nil
        }) {
            Text("Add")
        })
    }
    func makeAddRem() -> some View {
        return ScrollView {
            VStack {
                GroupBox(label: Text("Rem Key")) {
                    Picker("Key", selection: $remKey) {
                        ForEach (remItemList, id: \.self) { item in
                            Text(item)
                        }
                    }
                    .onAppear {
                        remKey = remItemList[0]
                    }
                    if remKey == "other" {
                        TextField("other key", text: $remWriteKey)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                GroupBox(label: Text("Rem Value")) {
                    TextField("value", text: $remValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Spacer()
            }.padding()
        }
        .navigationTitle("Appending")
        .navigationBarItems(trailing: Button(action: {
            if remKey == "other" {
                if remWriteKey == "" {
                    return
                }
                cueRem.append(.init(key: .init(remWriteKey), value: remValue))
            }else {
                cueRem.append(.init(key: .init(remKey), value: remValue))
            }
            present = nil
        }) {
            Text("Add")
        })
    }
    func makeAddTrack() -> some View {
        return ScrollView {
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
        }.navigationTitle("Appending")
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
    func makeFile() -> some View {
        VStack {
            VStack {
                HStack {
                    Text(fileTitle.isEmpty ? "File Name" : "File Name : \(cueFile.fileName)")
                    Spacer()
                }
                TextField(cueFile.fileName.isEmpty ? "Empty Data" : cueFile.fileName, text: $fileTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding([.top])
            
            VStack {
                HStack {
                    Text(fileType.isEmpty ? "File Type" : "File Type : \(cueFile.fileType)")
                    Spacer()
                }
                TextField(cueFile.fileType.isEmpty ? "Empty Data" : cueFile.fileType, text: $fileType)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Editting")
        .navigationBarItems(trailing: Button(action: {
            if !fileTitle.isEmpty {
                cueFile.fileName = fileTitle
            }
            if !fileType.isEmpty {
                cueFile.fileType = fileType
            }
            present = nil
        }) {
            Text("Edit")
        })
    }
    
}

struct CueSheetEditorView: View {
    let item: CueSheetList
    @State var fileTitle = String()
    @State var fileType = String()
    
    
    @State var trackTitle = String()
    @State var trackInsertIndex: Int = 0
    @State var trackInsertPositionPrivous = false
    @State var trackAudioToggle = true
    @State var trackNum = String()
    @State var trackStartTime = CSIndexTime(min: 0, sec: 0, frame: 0)
    @State var trackEndTime = CSIndexTime(min: 0, sec: 0, frame: 0)
    
    
    @Binding var cueRem:[CueSheetRem]
    @Binding var cueMeta:[CueSheetMeta]
    @Binding var cueTrack:[CueSheetTrack]
    @Binding var cueFile: CueSheetFile
    
    @Binding var present: CueSelectMode?
    
    @State var remKey = String()
    @State var remWriteKey = String()
    @State var remValue = String()
    
    let metaItemList = CSMetaKey.allCases.map { $0.caseName } + ["other"]
    let remItemList = CSRemKey.allCases.map { $0.caseName } + ["other"]
    
    var body: some View {
        NavigationView {
            Group {
                switch item {
                case .metaAdd:
                    makeAddMeta()
                case .remAdd:
                    makeAddRem()
                case .trackAdd:
                    makeAddTrack()
                case .file:
                    makeFile()
                    
                case .trackMetaAdd:
                    EmptyView()
                    
                case .trackRemAdd:
                    EmptyView()
                    
                    
                    
                    
                default:
                    EmptyView()
                }
            }
        }
    }
}

//struct CueSheetEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        CueSheetEditorView()
//    }
//}
