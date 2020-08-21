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
    
    init() {
        print("재 생성됨.")
    }
    
    // MARK: - 이벤트
    private var requestOpenState = { }
    
    // MARK: - 이벤트 처리 하는 함수.
    func onReuqestOpenState(_ action: @escaping () -> Void) -> CueSheetInfoView {
        var copy = self
        copy.requestOpenState = action
        return copy
    }
    
    func onSelectedCueSheetAndAudioAction(_ action: @escaping (CueSheetModel) -> Void) -> CueSheetInfoView {
        let copy = self
        copy.viewModel.selectedCueSheet = action
        return copy
    }
    
    func onSplitStart(_ action: @escaping (URL) -> Void) -> CueSheetInfoView {
        let copy = self
        copy.viewModel.splitStartAction = action
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
                        .onSplitStart {
                            self.viewModel.showFolderSelection = true
                            self.viewModel.showFilesSelection = false
                            self.viewModel.openSheet = true
                        }
                        .onSplitState(self.requestOpenState)
                    , trailing:
                    CueInfoNavigationBarTrailling()
                        .onTrashAction {
                            // 수정하기
                    }.onFolderBadgePlusAction {
                        self.viewModel.showFolderSelection = false
                        self.viewModel.showFilesSelection = true
                        self.viewModel.openSheet = true
                    }
                )
        }
        .alert(isPresented: self.$viewModel.openAlert, content: self.viewModel.makeAlert)
        .sheet(isPresented: self.$viewModel.openSheet, content: self.viewModel.makeSheet)            
    }
    
}
