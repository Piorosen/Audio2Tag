//
//  CueDetailTrackView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

enum CueDetailTrackItem: Identifiable {
    var id: Int {
        return self.hashValue
    }
    
    case time
    case rem
    case description
}


struct CueDetailTrackView: View {
    @ObservedObject var viewModel: CueDetailTrackViewModel
    //    @State var sheetType = CueSheetChangeType.None
    
    @State var descType: CueDetailTrackDescription?
    @State var openAlert = false
    @State var alertType: CueDetailTrackItem? = nil
    
    
    init(_ item: Binding<TrackModel>) {
        viewModel = CueDetailTrackViewModel(items: item)
    }
    
    // MARK: - View
    var body: some View {
        ZStack {
            List {
                CueDetailTrackDescriptionCell(track: $viewModel.track)
                    .onEdit { item in
                        self.viewModel.key = item.caseName.uppercased()
                        self.viewModel.value = ""
                        alertType = .description
                        descType = item
                        openAlert = false
                    }
                CueDetailTrackRemCell(rem: $viewModel.rem)
                    .onRequestAddRem {
                        self.viewModel.key = ""
                        self.viewModel.value = ""
                        descType = nil
                        openAlert = true
                    }.onRequestEditRem { idx, rem in
                        viewModel.setRemEdit(idx: idx)
                        alertType = .rem
                        descType = nil
                        openAlert = false
                    }
                CueDetailTrackTimeCell(startTime: viewModel.startTime
                                       , endTime: viewModel.endTime
                                       , waitTime: viewModel.waitTime
                                       , durationTime: viewModel.durTime)
            }
            .navigationBarTitle("Track Info")
            
            // REM 데이터만 추가가 가능하므로 REM만 추가함.
            CustomAlertView(isPresent: $openAlert, title: "데이터 추가", ok: {
                if viewModel.key != "" && viewModel.value != "" {
                    viewModel.rem.append(RemModel(value: (viewModel.key, viewModel.value)))
                }
            }) {
                VStack(alignment: .leading) {
                    Text("제목")
                    TextField("", text: $viewModel.key)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("내용")
                    TextField("", text: $viewModel.value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()
            }
            
            // META, REM, TIME 모두 변경이 가능 하므로 이 처럼 구성함.
            CustomAlertView(item: $alertType, title: "데이터 수정", ok: {
                if let type = alertType {
                    switch type {
                    case .rem:
                        viewModel.editRem()
                        break
                    case .time:
                        
                        break
                    case .description:
                        viewModel.editDescription(type: descType)
                        break
                    }
                }
                
            }) { _ in
                VStack(alignment: .leading) {
                    Text(self.viewModel.key)
                    TextField("", text: $viewModel.value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()
            }
            
        }.onDisappear(perform: viewModel.disappear)
    }
}
