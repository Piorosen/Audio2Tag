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
    
    func makeSheet<T: Identifiable>(item: T) -> some View {
        var text = ""
        if let value = item as? CueSheetList {
            switch value {
            case .meta:
                text = "Meta"
            case .rem:
                text = "Rem"
            case .track:
                text = "Track"
                
            }
        }else {
            text = "Occur Error"
        }
        
        
        return NavigationView {
            VStack {
                GroupBox {
                    VStack(alignment: .leading) {
                        Text("Key 값")
                        TextField("Key 값", text: $viewModel.sheetKey)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                GroupBox {
                    VStack(alignment: .leading) {
                        Text("Value 값")
                        TextField("Value 값", text: $viewModel.sheetValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("\(text) 추가")
        }.onDisappear {
            viewModel.addItem(type: item as? CueSheetList)
        }
    }
    
    
    init(fileInfo: Binding<CueSheetModel>) {
        viewModel = CueSheetListViewModel(fileInfo)
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
                AddButton("META 추가", viewModel.addMeta)
            }
            Section(header: Text("Rem")) {
                ForEach (self.viewModel.rem) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
                AddButton("REM 추가", viewModel.addRem)
            }
            Section(header: Text("File : \(viewModel.title)")) {
                ForEach (self.viewModel.tracks) { track in
                    NavigationLink(destination: CueDetailTrackView(track)
                                    .onChangedRem { r in
                                        
                                    }.onChangedMeta { m in
                                        
                                    }
                    ) {
                        Text("\(track.track.trackNum) : \(track.track.title)")
                    }
                }
//                AddButton("File 추가", viewModel.addTrack)
            }
        }.sheet(item: $viewModel.sheetType, content: self.makeSheet)
    }
}
