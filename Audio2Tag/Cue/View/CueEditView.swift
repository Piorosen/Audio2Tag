//
//  CueEditView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/11/12.
//

import SwiftUI
import SwiftCueSheet

enum CueEditSheetEvent : Identifiable {
    var id: Int {
        self.hashValue
    }
    case fileSelect
    case splitFolderSelect
    case saveCueFolder
}

extension CueEditView {
    func makeSheet(item: CueEditSheetEvent) -> some View {
        return Group {
            switch item {
            case .fileSelect:
                DocumentPicker()
                    .setConfig(folderPicker: false, allowMultiple: true)
                    .onSelectFiles { urls in
//                        _ = self.viewModel.selectFiles(urls)
                    }
            case .splitFolderSelect:
                DocumentPicker()
                    .setConfig(folderPicker: true, allowMultiple: false)
                    .onSelectFile { url in
//                        self.splitStartAction(url, self.viewModel.cueSheetModel, { viewModel.alertType = .success })
                    }
            case .saveCueFolder:
                DocumentPicker()
                    .setConfig(folderPicker: true, allowMultiple: false)
                    .onSelectFile { url in
//                        self.viewModel.saveCueSheet(url: url)
                    }
            }
        }
    }
}


struct CueEditView: View {
    @ObservedObject var viewModel = CueEditViewModel()
    
    @State var sheet: CueEditSheetEvent? = nil
    
    private var requestExecute: (CueSheet) -> Void = { _ in }
    private var requestStatus: () -> Void = { }
    
    
    func onRequestExecute(_ action: @escaping (CueSheet) -> Void) -> CueEditView {
        var copy = self
        copy.requestExecute = action
        return copy
    }
    
    func onRequestStatus(_ action: @escaping () -> Void) -> CueEditView {
        var copy = self
        copy.requestStatus = action
        return copy
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Music")) {
                    HStack {
                        Text("음원 길이")
                        Spacer()
                        Text("")
                    }
                    HStack {
                        Text("채널 수")
                        Spacer()
                        Text("")
                    }
                    HStack {
                        Text("샘플 레이트")
                        Spacer()
                        Text("")
                    }
                }
                
                Section(header: Text("Meta")) {
                    AddButton("META 추가", viewModel.add.meta)
                }
                
                Section(header: Text("Rem")) {
                    
                    AddButton("REM 추가", viewModel.add.rem)
                }
                Section(header: Text("File : ")) {
                    AddButton("Track 추가", viewModel.add.track)
                }
                
                
            }.navigationTitle("큐 편집기")
            .navigationBarItems(leading: HStack {
                Button(action: { }) {
                    Image(systemName: "play")
                }
                Button(action: requestStatus) {
                    Image(systemName: "doc.on.doc")
                }
            }, trailing: HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "folder.badge.plus")
                }
            })
//            .customAlertView(C
        }
//        }.sheet(item: <#T##Binding<Identifiable?>#>, content: <#T##(Identifiable) -> View#>)
    }
}

struct CueEditView_Previews: PreviewProvider {
    static var previews: some View {
        CueEditView()
    }
}
