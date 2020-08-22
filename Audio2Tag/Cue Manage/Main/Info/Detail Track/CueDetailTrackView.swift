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
            CueDetailListInfoDescriptionSection()
            CueDetailListInfoRemSection()
            CueDetailListInfoTimeSection()
        }
        .navigationBarTitle("Track Info")
        .sheet(isPresented: $openSheet, content: makeSheet)
    }
}
