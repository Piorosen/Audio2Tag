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
    @State var key = String()
    @State var value = String()
    @State var openSheet = false
    @State var openAlert = false
    @State var alertType: CueDetailTrack? = nil
    

    init(_ item: Binding<TrackModel>) {
        viewModel = CueDetailTrackViewModel(items: item)
    }
    
    // MARK: - View
    var body: some View {
        ZStack {
            List {
                CueDetailTrackDescriptionCell(track: viewModel.item)
                CueDetailTrackRemCell(rem: $viewModel.rem)
                    .onRequestAddRem {
                        self.key = ""
                        self.value = ""
                        openAlert = true
                    }.onRequestEditRem { idx, rem in
                        self.key = viewModel.rem[idx].value.key
                        self.key = viewModel.rem[idx].value.value
                        openAlert = true   
                    }
                CueDetailTrackTimeCell(startTime: viewModel.startTime
                                       , endTime: viewModel.endTime
                                       , waitTime: viewModel.waitTime
                                       , durationTime: viewModel.durTime)
            }
            .navigationBarTitle("Track Info")
            .sheet(isPresented: $openSheet, content: makeSheet)
            
            CustomAlertView(isPresent: $openAlert, title: "Rem 추가", ok: {
                viewModel.rem.append(RemModel(value: (key, value)))
            }) {
                VStack(alignment: .leading) {
                    Text("제목")
                    TextField("hint", text: $key)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("내용")
                    TextField("hint", text: $value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()
            }
        }
    }
}
