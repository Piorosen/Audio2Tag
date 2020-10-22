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
        viewModel = CueSheetListViewModel(fileInfo)
    }
    
    // MARK: - 이벤트 처리하는 함수
    var body: some View {
        ZStack {
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
                    ForEach (self.viewModel.meta.indices, id: \.self) { idx in
                        Button(action: { viewModel.editMeta(idx) },
                               label: {
                            HStack {
                                Text(viewModel.meta[idx].value.key)
                                Spacer()
                                Text(viewModel.meta[idx].value.value)
                            }
                        })
                    }
                    AddButton("META 추가", viewModel.addMeta)
                }
                Section(header: Text("Rem")) {
                    ForEach (self.viewModel.rem.indices, id: \.self) { idx in
                        Button(action: { viewModel.editRem(idx) },
                               label: {
                            HStack {
                                Text(viewModel.rem[idx].value.key)
                                Spacer()
                                Text(viewModel.rem[idx].value.value)
                            }
                        })
                    }
                    AddButton("REM 추가", viewModel.addRem)
                }
                Section(header: Text("File : \(viewModel.title)")) {
                    ForEach (self.viewModel.tracks.indices, id: \.self) { trackIndex in
                        NavigationLink(destination: CueDetailTrackView($viewModel.fileInfo.tracks[trackIndex])
                        ) {
                            Text("\(viewModel.tracks[trackIndex].track.trackNum) : \(viewModel.tracks[trackIndex].track.title)")
                        }
                    }
                    AddButton("Track 추가", viewModel.addTrack)
                }
                
            }
            CustomAlertView(item: $viewModel.addSheetType, title: "데이터 추가", ok: {
                viewModel.addItem(type: self.viewModel.addSheetType)
            }) { item in
                VStack(alignment: .leading) {
                    switch item {
                    case .meta:
                        Text("meta")
                    case .rem:
                        Text("rem")
                    case .track:
                        Text("track")
                    }
                    
                    TextField("", text: $viewModel.sheetKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("내용")
                    TextField("", text: $viewModel.sheetValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()
            }
            
            CustomAlertView(item: $viewModel.editSheetType, title: "데이터 수정", ok: {
                viewModel.editItem(type: self.viewModel.editSheetType)
            }) { item in
                VStack(alignment: .leading) {
                    Text("\(viewModel.sheetKey)")
                    TextField("", text: $viewModel.sheetValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()
            }
            
        }
    }
}
