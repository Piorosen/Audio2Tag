//
//  CueDetailTrackView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI


struct CueDetailTrackView: View {
    @ObservedObject var viewModel: CueDetailTrackViewModel
    @State var sheetType = CueSheetChangeType.None
    @State var key = String()
    @State var value = String()
    @State var openSheet = false
    
    // MARK: - 이벤트
    var changeMeta = { (_:[MetaModel]) in }
    var changeRem = { (_:[RemModel]) in }
    
    // MARK: - 이벤트 처리하는 함수
    func onChangedMeta(action: @escaping ([MetaModel]) -> Void) -> CueDetailTrackView {
        var copy = self
        copy.changeMeta = action
        return copy
    }
    
    func onChangedRem(action: @escaping ([RemModel]) -> Void) -> CueDetailTrackView {
        var copy = self
        copy.changeRem = action
        return copy
    }
    
    init(_ item: TrackModel) {
        viewModel = CueDetailTrackViewModel(item: item)
    }
    
    // MARK: - View
    var body: some View {
        List {
            Section(header: Text("Description")) {
                HStack {
                    Text("Title")
                    Spacer()
                    Text("\(self.viewModel.item.track.title)")
                }
                HStack {
                    Text("Track Num")
                    Spacer()
                    Text("\(self.viewModel.item.track.trackNum)")
                }
                HStack {
                    Text("ISRC")
                    Spacer()
                    Text("\(self.viewModel.item.track.isrc)")
                }
                HStack {
                    Text("Performer")
                    Spacer()
                    Text("\(self.viewModel.item.track.performer)")
                }
                
                HStack {
                    Text("Track Type")
                    Spacer()
                    Text("\(self.viewModel.item.track.trackType)")
                }
                HStack {
                    Text("Song Writer")
                    Spacer()
                    Text("\(self.viewModel.item.track.songWriter)")
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
                ForEach (self.viewModel.rem) { item in
                    HStack {
                        Text("\(item.value.key)")
                        Spacer()
                        Text("\(item.value.value)")
                    }
                }
                Button(action: {
                    sheetType = .Rem
                    openSheet = true
                }) {
                    HStack {
                        Text("Rem 정보 추가")
                        Spacer()
                        Image(systemName: "plus")
                    }
                }
            }
            
            Section(header: Text("Time Info")) {
                HStack {
                    Text("Start Time")
                    Spacer()
                    Text(self.viewModel.startTime)
                }
                HStack {
                    Text("End Time")
                    Spacer()
                    Text(self.viewModel.endTime)
                }
                HStack {
                    Text("Wait Time")
                    Spacer()
                    Text(self.viewModel.waitTime)
                }
                HStack {
                    Text("Duration Time")
                    Spacer()
                    Text(self.viewModel.durTime)
                }
            }

        }.navigationBarTitle("Track Info")
        .sheet(isPresented: $openSheet, content: {
            VStack {
                Text("키값")
                TextField("", text: self.$key)
                Text("밸류 값")
                TextField("", text: self.$value)
                Button("적용", action: {
                    switch (self.sheetType) {
                    case .Rem:
                        var copy = viewModel.rem
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
