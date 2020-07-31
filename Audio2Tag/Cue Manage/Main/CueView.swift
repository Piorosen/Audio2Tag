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
    
    func makeAlert() -> Alert {
        switch viewModel.alert {
        case .alertSplitView:
            return Alert(title: Text("파일 분리"),
                         message: Text("Cue File 기준으로 파일을 분리 하겠습니까?"),
                         primaryButton: .cancel(Text("취소")),
                         secondaryButton: .default(Text("확인"), action: self.viewModel.openSplitFolderDocument))
        case .none:
            return Alert(title: Text("오류"),
                         message: Text("Cue File과 음원 파일을 선택해 주세요."),
                         dismissButton: .cancel(Text("확인")))
        }
    }
    
    func makeSheet() -> AnyView {
        switch viewModel.sheet {
        case .cueSearchDocument:
            return AnyView(DocumentPicker(isFolderPicker: false).onSelectFiles{ urls in
                let _ = self.viewModel.loadItem(url: urls)
            })
        case .splitFolderDocument:
            return AnyView(DocumentPicker(isFolderPicker: true).onSelectFile { url in
                self.viewModel.openSplitStatusView()
                self.viewModel.splitStart(url: url)
            })
            
        case .splitStatusView:
            return AnyView(SplitMusicView(bind: self.$viewModel.splitStatus))
            
        default:
            return AnyView(EmptyView().background(Color.red))
        }
    }
    
    var body: some View {
        NavigationView {
            CueFileInfoView(fileInfo: self.$viewModel.cueSheetModel)
                .sheet(isPresented: self.$viewModel.openSheet) { self.makeSheet() }
            .alert(isPresented: self.$viewModel.openAlert) { self.makeAlert() }
            .navigationBarTitle("Cue Info")
            .navigationBarItems(
            leading:
                Button(action: self.viewModel.navigationLeadingButton) {
                    if self.viewModel.sheet == .splitStatusView {
                        Text("Show")
                    } else {
                        Text("Make")
                    }
                },
            trailing:
                Button(action: self.viewModel.navigationTrailingButton) { Image(systemName: "plus") }
            )
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
