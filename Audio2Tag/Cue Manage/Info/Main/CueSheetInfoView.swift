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
    @ObservedObject var viewModel = CueSheetInfoViewModel()
    
    
    private var splitStartAction = { }
    private var requestOpenState = { }
    
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
    
    func onSplitStart(_ action: @escaping () -> Void) -> CueSheetInfoView {
        var copy = self
        copy.splitStartAction = action
        return copy
    }
    
    var body: some View {
        NavigationView {
            CueSheetListInfoView(fileInfo: self.$viewModel.cueSheetModel)
                .navigationBarTitle("Cue Info")
                .navigationBarItems(
                    leading:
                    CueInfoNavigationBarLeading()
                        .onSplitStart(self.splitStartAction)
                        .onSplitState(self.requestOpenState)
                    , trailing:
                    CueInfoNavigationBarTrailling()
                        .onTrashAction {
                            // 수정하기
                    }.onFolderBadgePlusAction {
                        self.viewModel.showFilesSelection = true
                        self.viewModel.openSheet = true
                        
                    }
            )
            
        }
        .alert(isPresented: self.$viewModel.openAlert, content: self.viewModel.makeAlert)
        .sheet(isPresented: self.$viewModel.openSheet, content: self.viewModel.makeSheet)            
    }
    
}
