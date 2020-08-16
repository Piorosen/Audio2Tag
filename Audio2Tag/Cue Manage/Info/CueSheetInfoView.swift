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
                HStack {
                    Button(action: self.viewModel.navigationLeadingDivdeMusicButton) {
                        Image(systemName: "play").padding(10)
                    }.sheet(isPresented: self.$viewModel.showFolderSelection) {
                        DocumentPicker()
                            .setConfig(folderPicker: true)
                            .onSelectFile { url in
                                self.viewModel.musicOfSplit(url: url)
                        }
                    }.alert(isPresented: self.$viewModel.showLeadingAlert, content: self.makeAlert)
                    Button(action: { self.viewModel.isShowing = true } /* self.viewModel.navigationLeadingDivideStatusButton */){
                        Image(systemName: "doc.on.doc").padding(10)
                    }
                }
                ,
                trailing:
                HStack {
                    Button(action: self.viewModel.navigationTrailingButton) {
                        Image(systemName: "folder.badge.plus").padding(10)
                    }.sheet(isPresented: self.$viewModel.showFilesSelection) {
                        DocumentPicker()
                            .setConfig(folderPicker: false, allowMultiple: true)
                            .onSelectFiles { urls in
                                self.viewModel.selectFiles(urls)
                        }
                    }
                    Button(action: { self.viewModel.isShowing = true } /* self.viewModel.navigationLeadingDivideStatusButton */){
                        Image(systemName: "trash").padding(10)
                    }
                }
            )
            
        }
    }
    
}
