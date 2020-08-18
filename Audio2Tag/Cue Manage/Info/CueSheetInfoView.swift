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
    
    
    func makeAlert() -> Alert {
        if viewModel.cueSheetModel.musicUrl != nil {
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
    
    
    var body: some View {
        NavigationView {
            CueSheetListInfoView(fileInfo: self.$viewModel.cueSheetModel)
                .navigationBarTitle("Cue Info")
                .navigationBarItems(
                    leading:
                        CueInfoNavigationBarLeading()
                        .onSplitStart {
                        
                        }
                        .onSplitState {
                        
                        }
                    , trailing:
                        CueInfoNavigationBarTrailling().onTrashAction {
                        
                        }.onFolderBadgePlusAction {
                        
                        }
                )
            
        }
    }
    
}
