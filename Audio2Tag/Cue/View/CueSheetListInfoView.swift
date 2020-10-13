//
//  CueFileMetaInfo.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/16.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI
import CoreMedia

enum CueSheetChangeType {
    case None, Meta, Rem
}

struct CueSheetListInfoView: View {
    @Binding var fileInfo: CueSheetModel
    @State var openSheet = false
    @State var sheetType = CueSheetChangeType.None
    @State var key = String()
    @State var value = String()
    
    // MARK: - 이벤트
    var changeMeta = { (meta:[MetaModel]) in }
    var changeRem = { (rem:[RemModel]) in }
    var changeTrackRem = { (index:Int, rem:[RemModel]) in }
    var changeSheet = { (sheet:CueSheetModel) in }
    
    
    // MARK: - 이벤트 처리하는 함수
    func onChangedMeta(action: @escaping ([MetaModel]) -> Void) -> CueSheetListInfoView {
        var copy = self
        copy.changeMeta = action
        return copy
    }
    
    func onChangedRem(action: @escaping ([RemModel]) -> Void) -> CueSheetListInfoView {
        var copy = self
        copy.changeRem = action
        return copy
    }
    
    func onChangeTrackRem(action: @escaping (Int, [RemModel]) -> Void) -> CueSheetListInfoView {
        var copy = self
        copy.changeTrackRem = action
        return copy
    }
    
    func onChangeCueSheet(action: @escaping (CueSheetModel) -> Void) -> CueSheetListInfoView {
        var copy = self
        copy.changeSheet = action
        return copy
    }
    
    // MARK: - 이벤트 처리하는 함수
    func musicInfo() -> some View {
        guard let info = fileInfo.cueSheet?.info else {
            return AnyView(EmptyView())
        }
        if fileInfo.musicUrl == nil {
            return AnyView(EmptyView())
        }
        
        
        return AnyView(Section(header: Text("Music")) {
            HStack {
                Text("음원 길이")
                Spacer()
                Text("\(CMTimeGetSeconds(info.lengthOfAudio).makeTime())")
            }
            HStack {
                Text("채널 수")
                Spacer()
                Text("\(info.format.channelCount)")
            }
            HStack {
                Text("샘플 레이트")
                Spacer()
                Text("\(Int(info.format.sampleRate))")
            }
        })
        
        
    }
    
    var body: some View {
        List {
            musicInfo()
            Section(header: Text("Meta")) {
                ForEach (self.fileInfo.meta) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
//                Button(action: {
//                    self.sheetType = .Meta
//                    self.openSheet = true
//                }) {
//                    HStack {
//                        Text("Meta 정보 추가")
//                        Spacer()
//                        Image(systemName: "plus")
//                    }
//                }
            }
            Section(header: Text("Rem")) {
                ForEach (self.fileInfo.rem) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
//                Button(action: {
//                    self.sheetType = .Rem
//                    self.openSheet = true
//                }) {
//                    HStack {
//                        Text("Rem 정보 추가")
//                        Spacer()
//                        Image(systemName: "plus")
//                    }
//                }
            }
            Section(header: Text("File : \(self.fileInfo.cueSheet?.file.fileName ?? String())")) {
                ForEach (self.fileInfo.tracks) { track in
                    NavigationLink(destination:
                                    CueDetailTrackView(track)
                                    .onChangedRem { r in
                                        
                                    }
                    
                    
                    ) {
                        Text("\(track.track.trackNum) : \(track.track.title)")
                    }
                }
            }
        }
        .sheet(isPresented: $openSheet, content: {
            VStack {
                Text("키값")
                TextField("", text: self.$key)
                Text("밸류 값")
                TextField("", text: self.$value)
                Button("적용", action: {
                    switch (self.sheetType) {
                    case .Meta:
                        var copy = fileInfo.meta
                        copy.append(MetaModel(value: (self.key, self.value)))
                        self.changeMeta(copy)
                        break
                    case .Rem:
                        var copy = fileInfo.rem
                        copy.append(RemModel(value: (self.key, self.value)))
                        self.changeRem(copy)
                        break
                    default:
                        break
                    }
                    self.openSheet = false
                })
            }
        })
    }
}
