//
//  CueFileInfoView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import CoreMedia


extension CueSheetView {
    
    // MARK: - alert창과 sheet창을 만드는 함수.

    func makeSheet() -> some View {
        return VStack {
            if self.viewModel.showFilesSelection {
                DocumentPicker()
                    .setConfig(folderPicker: false, allowMultiple: true)
                    .onSelectFiles { urls in
                        _ = self.viewModel.selectFiles(urls)
                    }
            }else if self.viewModel.showFolderSelection {
                DocumentPicker()
                    .setConfig(folderPicker: true, allowMultiple: false)
                    .onSelectFile { url in
                        self.splitStartAction(url, self.viewModel.cueSheetModel)
                    }
            }else {
                EmptyView()
            }
        }
    }

    
    
    func makeAlert() -> Alert {
        if self.viewModel.cueSheetModel.musicUrl != nil {
            return Alert(title: Text("파일 분리"),
                         message: Text("Cue File 기준으로 파일을 분리 하겠습니까?"),
                         primaryButton: .cancel(Text("취소")),
                         secondaryButton: .default(Text("확인"), action:
                                                    {
                                                        self.viewModel.showFolderSelection = true;
                                                        self.viewModel.showFilesSelection = false;
                                                        self.viewModel.openSheet = true
                                                    }))
        } else {
            return Alert(title: Text("오류"),
                         message: Text("Cue File 또는 음원 파일을 선택해 주세요."),
                         dismissButton: .cancel(Text("확인")))
        }
    }
}


struct CueSheetView: View {
    @StateObject var viewModel = CueSheetViewModel()
    
    // MARK: - 이벤트
    fileprivate var requestOpenState = { }
    fileprivate var splitStartAction = { (directory:URL, sheet:CueSheetModel) in }
    
    // MARK: - 이벤트 처리 하는 함수.
    func onReuqestOpenState(_ action: @escaping () -> Void) -> CueSheetView {
        var copy = self
        copy.requestOpenState = action
        return copy
    }
    
    func onSplitStart(_ action: @escaping (URL, CueSheetModel) -> Void) -> CueSheetView {
        var copy = self
        copy.splitStartAction = action
        return copy
    }
    
    
    // MARK: - View
    var body: some View {
        NavigationView {
            CueSheetListView(fileInfo: self.$viewModel.cueSheetModel)
                .onChangedRem { r in
                    viewModel.cueSheetModel.rem = r
                }.onChangedMeta { m in
                    viewModel.cueSheetModel.meta = m
                }
                .navigationBarTitle("Cue Info")
                .navigationBarItems(
                    leading:
                        CueSheetNavigationBarLeading()
                        .onSplitStart(viewModel.onStartSplit)
                        .onSplitState(requestOpenState)
                    , trailing:
                        CueSheetNavigationBarTrailling()
                        .onFolderBadgePlusAction(viewModel.onBadgePlus)
                )
        }
        .alert(isPresented: self.$viewModel.openAlert, content: self.makeAlert)
        .sheet(isPresented: self.$viewModel.openSheet, content: self.makeSheet)
    }
    
}
