//
//  CueDetailTrackView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

enum CueDetailTrack : Identifiable {
    var id: Int {
        return self.hashValue
    }
    
    case AddRem
    case EditRem
    case EditTime
    case EditDescription
}


struct CueDetailTrackView: View {
    @ObservedObject var viewModel: CueDetailTrackViewModel
    //    @State var sheetType = CueSheetChangeType.None
    
    @State var descType: CueDetailTrackDescription?
    @State var openAlert = false
    @State var alertType: CueDetailTrack? = nil
    
    
    init(_ item: Binding<TrackModel>) {
        viewModel = CueDetailTrackViewModel(items: item)
    }
    
    // MARK: - View
    var body: some View {
        ZStack {
            List {
                CueDetailTrackDescriptionCell(track: $viewModel.item)
                    .onEdit { item in
                        self.viewModel.value = ""
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
                        self.viewModel.key = viewModel.rem[idx].value.key
                        self.viewModel.value = viewModel.rem[idx].value.value
                        descType = nil
                        openAlert = true
                    }
                CueDetailTrackTimeCell(startTime: viewModel.startTime
                                       , endTime: viewModel.endTime
                                       , waitTime: viewModel.waitTime
                                       , durationTime: viewModel.durTime)
            }
            .navigationBarTitle("Track Info")
            
            
            CustomAlertView(isPresent: $openAlert, title: "Rem 추가", ok: {
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
            CustomAlertView(item: $descType, title: "Desc 수정", ok: {
                viewModel.editDescription(type: descType)
            }) { _ in
                VStack(alignment: .leading) {
                    Text("내용")
                    TextField("", text: $viewModel.value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()
            }
        }
    }
}
