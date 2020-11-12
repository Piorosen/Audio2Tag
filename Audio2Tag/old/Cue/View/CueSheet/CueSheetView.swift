//
//  CueFileInfoView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import CoreMedia

enum SheetModelCueSheet : Identifiable {
    var id: Int {
        return self.hashValue
    }
    
    case saveCueFolder
    case splitFolderSelect
    case fileSelect
}

enum AlertModelCueSheet: Identifiable {
    var id: Int {
        return self.hashValue
    }
    
    case failLoad
    case success
    case splitRequest
    case cueSaveRequest
}

extension CueSheetView {
    
    // MARK: - alert창과 sheet창을 만드는 함수.

    func makeSheet(item: SheetModelCueSheet) -> some View {
        return VStack {
            switch item {
            case .fileSelect:
                DocumentPicker()
                    .setConfig(folderPicker: false, allowMultiple: true)
                    .onSelectFiles { urls in
                        _ = self.viewModel.selectFiles(urls)
                    }
            case .splitFolderSelect:
                DocumentPicker()
                    .setConfig(folderPicker: true, allowMultiple: false)
                    .onSelectFile { url in
                        self.splitStartAction(url, self.viewModel.cueSheetModel, { viewModel.alertType = .success })
                    }
            case .saveCueFolder:
                DocumentPicker()
                    .setConfig(folderPicker: true, allowMultiple: false)
                    .onSelectFile { url in
                        self.viewModel.saveCueSheet(url: url)
                    }
            }
        }
    }

    
    
    func makeAlert(item: AlertModelCueSheet) -> Alert {
        switch item {
        case .success:
            return Alert(title: Text("작업 완료"),
                         message: Text("CueSheet 저장 및 파일 분리 작업을 완료 하였습니다."),
                         dismissButton: .default(Text("확인")))
        case .cueSaveRequest:
            return Alert(title: Text("Cue Sheet 저장"),
                         message: Text("CueSheet를 작업 하신 내용 기준으로 저장하시겠습니까?"),
                         primaryButton: .cancel(Text("취소")),
                         secondaryButton: .default(Text("확인"), action:
                                                    {
                                                        self.viewModel.sheetType = .saveCueFolder
                                                    }))
        case .splitRequest:
            return Alert(title: Text("파일 분리"),
                         message: Text("Cue File 기준으로 파일을 분리 하겠습니까?"),
                         primaryButton: .cancel(Text("취소")),
                         secondaryButton: .default(Text("확인"), action:
                                                    {
                                                        self.viewModel.sheetType = .splitFolderSelect
                                                    }))
        case .failLoad:
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
    fileprivate var splitStartAction = { (directory:URL, sheet:CueSheetModel, callBack: @escaping (() -> Void)) in }
    
    // MARK: - 이벤트 처리 하는 함수.
    func onReuqestOpenState(_ action: @escaping () -> Void) -> CueSheetView {
        var copy = self
        copy.requestOpenState = action
        return copy
    }
    
    func onSplitStart(_ action: @escaping (URL, CueSheetModel, @escaping () -> Void) -> Void) -> CueSheetView {
        var copy = self
        copy.splitStartAction = action
        return copy
    }
    
    
    // MARK: - View
    var body: some View {
        NavigationView {
            CueSheetListView(fileInfo: self.$viewModel.cueSheetModel)
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
        .alert(item: self.$viewModel.alertType, content: self.makeAlert)
        .sheet(item: self.$viewModel.sheetType, content: self.makeSheet)
    }
    
}
