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


struct CueSheetListInfoView: View {
    @Binding var fileInfo: CueSheetModel
    
    
    // MARK: - 이벤트
    var changeMeta = { (_:[MetaModel]) in }
    var changeRem = { (_:[RemModel]) in }
    
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
    
    // MARK: - 이벤트 처리하는 함수
    func musicInfo() -> AnyView {
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
                ForEach (self.fileInfo.rem) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
                Button(action: {
                    
                }) {
                    HStack {
                        Text("Meta 정보 추가")
                        Spacer()
                        Image(systemName: "plus")
                    }
                }
            }
            Section(header: Text("Rem")) {
                ForEach (self.fileInfo.meta) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
                Button(action: {
                    
                }) {
                    HStack {
                        Text("Rem 정보 추가")
                        Spacer()
                        Image(systemName: "plus")
                    }
                }
            }
            Section(header: Text("File : \(self.fileInfo.cueSheet?.file.fileName ?? String())")) {
                ForEach (self.fileInfo.tracks) { track in
                    NavigationLink(destination: CueDetailTrackView(track)) {
                        Text("\(track.track.trackNum) : \(track.track.title)")
                    }
                }
            }
        }
    }
}
