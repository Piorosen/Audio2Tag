//
//  CueFileInfoView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import CoreMedia

struct CueSheetInfoView: View {
    @StateObject var viewModel = CueSheetInfoViewModel()
    
    // MARK: - 이벤트
    private var requestOpenState = { }
    private var splitStartAction = { (directory:URL, sheet:CueSheetModel) in }
    
    // MARK: - 이벤트 처리 하는 함수.
    func onReuqestOpenState(_ action: @escaping () -> Void) -> CueSheetInfoView {
        var copy = self
        copy.requestOpenState = action
        return copy
    }
    
    func onSplitStart(_ action: @escaping (URL, CueSheetModel) -> Void) -> CueSheetInfoView {
        var copy = self
        copy.splitStartAction = action
        return copy
    }
    
    
    // MARK: - View
    var body: some View {
        NavigationView {
            CueSheetListInfoView(fileInfo: self.$viewModel.cueSheetModel)
                .onChangedRem { r in
                    viewModel.cueSheetModel.rem = r
                }.onChangedMeta { m in
                    viewModel.cueSheetModel.meta = m
                }
                .navigationBarTitle("Cue Info")
                .navigationBarItems(
                    leading:
                        CueInfoNavigationBarLeading()
                        .onSplitStart(viewModel.onStartSplit)
                        .onSplitState(requestOpenState)
                    , trailing:
                        CueInfoNavigationBarTrailling()
                        .onTrashAction {
                            // 수정하기
                        }.onFolderBadgePlusAction(viewModel.onBadgePlus)
                )
        }
        .alert(isPresented: self.$viewModel.openAlert, content: self.makeAlert)
        .sheet(isPresented: self.$viewModel.openSheet, content: self.makeSheet)            
    }
    
}
