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
    
    private var selectedCueSheet = { (sheet:CueSheetModel) in }
    private var splitStartAction = { }
    private var requestOpenState = { }
    
    func onReuqestOpenState(_ action: @escaping () -> Void) -> CueSheetInfoView {
        var copy = self
        copy.requestOpenState = action
        return copy
    }
    
    func onSelectedCueSheetAndAudioAction(_ action: @escaping (CueSheetModel) -> Void) -> CueSheetInfoView {
        var copy = self
        copy.selectedCueSheet = action
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
                        DocumentPicker()
                            .setConfig(folderPicker: false, allowMultiple: true)
                            .onSelectFiles { urls in
                                if let v = self.viewModel.selectFiles(urls) {
                                    self.selectedCueSheet(v)
                                }
                            }
                    }
            )
            
        }
        .alert(isPresented: self.$viewModel.openAlert, content: self.viewModel.makeAlert)
        .sheet(isPresented: self.$viewModel.openSheet, content: self.viewModel.makeSheet)            
    }
    
}
