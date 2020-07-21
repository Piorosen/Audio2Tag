//
//  CueView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueView: View {
    @ObservedObject var viewModel = CueViewModel()
    
    var body: some View {
        
        NavigationView {
            CueFileInfoView(fileInfo: self.$viewModel.cueFileInfo)
                
            .navigationBarTitle("Cue Info")
            .navigationBarItems(leading: Group {
                Button(action: self.viewModel.splitFile) {
                    Text("Make")
                }.alert(isPresented: self.$viewModel.isSplitPresented) {
                    if self.viewModel.cue != nil {
                        return Alert(title: Text("파일 분리"),
                        message: Text("Cue File 기준으로 파일을 분리 하겠습니까?"),
                        primaryButton: .cancel(Text("취소")),
                        secondaryButton: .default(Text("확인"), action: self.viewModel.alertOK))
                    }else {
                        return Alert(title: Text("오류"),
                                     message: Text("아직 Cue File을 읽지 않은 상태 입니다."))
                    }
                }.sheet(isPresented: self.$viewModel.isFolderShow) {
                    DocumentPicker(isFolderPicker: true)
                     .onSelectFile { url in
                         self.viewModel.splitStart(url: url)
                    }
                }
            }, trailing: Group {
                Button(action: self.viewModel.addItem) {
                    Image(systemName: "plus")
                }
                .padding(10)
            })
            .sheet(isPresented: self.$viewModel.isDocumentShow) {
                DocumentPicker(isFolderPicker: false)
                .onSelectFiles { urls in
                    self.viewModel.loadItem(url: urls)
                }
            }
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
