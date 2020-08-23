//
//  CueSheetInfoView+Extension.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI


extension CueSheetInfoView {
    
    // MARK: - alert창과 sheet창을 만드는 함수.
    
    func makeSheet() -> some View {
        return Group {
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
//                        self.splitStartAction(url)
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
                         secondaryButton: .default(Text("확인"), action: { self.viewModel.showFolderSelection = true }))
        } else {
            return Alert(title: Text("오류"),
                         message: Text("Cue File과 음원 파일을 선택해 주세요."),
                         dismissButton: .cancel(Text("확인")))
        }
    }
}
