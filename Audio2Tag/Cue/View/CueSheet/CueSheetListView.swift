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


struct CueSheetListView: View {
    @ObservedObject var viewModel: CueSheetListViewModel

    
    init(fileInfo: Binding<CueSheetModel>) {
        viewModel = CueSheetListViewModel(fileInfo: fileInfo)
    }
    
    // MARK: - 이벤트
    var changeMeta = { (meta:[MetaModel]) in }
    var changeRem = { (rem:[RemModel]) in }
    var changeTrackRem = { (index:Int, rem:[RemModel]) in }
    var changeSheet = { (sheet:CueSheetModel) in }
    
    
    // MARK: - 이벤트 처리하는 함수
    func onChangedMeta(action: @escaping ([MetaModel]) -> Void) -> CueSheetListView {
        var copy = self
        copy.changeMeta = action
        return copy
    }
    
    func onChangedRem(action: @escaping ([RemModel]) -> Void) -> CueSheetListView {
        var copy = self
        copy.changeRem = action
        return copy
    }
    
    func onChangeTrackRem(action: @escaping (Int, [RemModel]) -> Void) -> CueSheetListView {
        var copy = self
        copy.changeTrackRem = action
        return copy
    }
    
    func onChangeCueSheet(action: @escaping (CueSheetModel) -> Void) -> CueSheetListView {
        var copy = self
        copy.changeSheet = action
        return copy
    }
    
    // MARK: - 이벤트 처리하는 함수
    var body: some View {
        List {
            if viewModel.audio.isAudio {
                Section(header: Text("Music")) {
                    HStack {
                        Text("음원 길이")
                        Spacer()
                        Text("\(CMTimeGetSeconds(viewModel.audio.audio!.lengthOfAudio).makeTime())")
                    }
                    HStack {
                        Text("채널 수")
                        Spacer()
                        Text("\(viewModel.audio.audio!.format.channelCount)")
                    }
                    HStack {
                        Text("샘플 레이트")
                        Spacer()
                        Text("\(Int(viewModel.audio.audio!.format.sampleRate))")
                    }
                }
            }
            
            Section(header: Text("Meta")) {
                ForEach (self.viewModel.meta) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
                AddButton("META 추가") {
                    viewModel.openAlert = true
                }
            }
            Section(header: Text("Rem")) {
                ForEach (self.viewModel.rem) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
                AddButton("REM 추가") {
                    viewModel.openAlert = true
                }
            }
            Section(header: Text("File : \(viewModel.title)")) {
                ForEach (self.viewModel.tracks) { track in
                    NavigationLink(destination: CueDetailTrackView(track)
                                    .onChangedRem { r in
                                        
                                    }
                    ) {
                        Text("\(track.track.trackNum) : \(track.track.title)")
                    }
                }
                AddButton("File 추가") {
                    viewModel.openAlert = true
                }
            }
        }.alert(isPresented: $viewModel.openAlert) {
            Alert(title: Text("미 구현 데이터 입니다."))
        }
    }
}
