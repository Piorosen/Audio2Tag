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
    @State var test = ""
    
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
                
                
            }
            CustomAlertView(item: $viewModel.addSheetType, title: "데이터 추가", ok: {
                viewModel.addItem(type: self.viewModel.addSheetType)
            }) { item in
                switch item {
                case .track:
                    AnyView(ScrollView {
                            GroupBox {
                                VStack {
//                                GroupBox {
                                    Text("시작 시간")
                                    HStack {
                                        TextField("분", text: $test).textFieldStyle(RoundedBorderTextFieldStyle())
                                        TextField("초", text: $test).textFieldStyle(RoundedBorderTextFieldStyle())
                                        TextField("프레임", text: $test).textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                                }
                                Divider()
                                VStack {
//                                GroupBox {
                                    Text("종료 시간")
                                    HStack {
                                        TextField("분", text: $test).textFieldStyle(RoundedBorderTextFieldStyle())
                                        TextField("초", text: $test).textFieldStyle(RoundedBorderTextFieldStyle())
                                        TextField("프레임", text: $test).textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                                    
                                }
                                Divider()
                                VStack {
//                                GroupBox {
                                    Text("추가할 트랙 위치")
                                    Picker("삽입할 인덱스", selection: $viewModel.selectTrackIndex) {
                                        ForEach(0..<((viewModel.fileInfo.cueSheet?.file.tracks.count ?? 0) + 1), id: \.self) { i in
                                            Text("\(i) 번 위치")
                                        }
                                    }
                                }
                            }
                        }.scaledToFit())
                default:
                    AnyView(VStack(alignment: .leading) {
                        Text("제목")
                        TextField("", text: $viewModel.sheetKey)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("내용")
                        TextField("", text: $viewModel.sheetValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }.padding())
                }
                
            }
            
            CustomAlertView(item: $viewModel.editSheetType, title: "데이터 수정", ok: {
                viewModel.editItem(type: self.viewModel.editSheetType)
            }) { item in
                VStack(alignment: .leading) {
                    Text("\(viewModel.sheetKey)")
                    switch item {
                    case .meta:
                        TextField(viewModel.meta[viewModel.editIndex].value.value, text: $viewModel.sheetValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    case .rem:
                        TextField(viewModel.rem[viewModel.editIndex].value.value, text: $viewModel.sheetValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    default:
                        TextField("", text: $viewModel.sheetValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                }.padding()
            }
            
        }
        
    }
}
