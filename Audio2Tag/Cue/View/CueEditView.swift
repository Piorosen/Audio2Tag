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
                        self.viewModel.selectFiles(urls: urls)
                    }
            case .splitFolderSelect:
                DocumentPicker()
                    .setConfig(folderPicker: true, allowMultiple: false)
                    .onSelectFile { url in
                        self.viewModel.splitCueSheet(url: url)
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
}


struct CueEditView: View {
    @ObservedObject var viewModel = CueEditViewModel()
    
    @State var sheet: CueEditSheetEvent? = nil
    
    func onRequestExecute(_ action: @escaping (CueSheet, URL) -> Void) -> CueEditView {
//        let copy = self
        self.viewModel.requestExecute = action
        return self
    }
    func onRequestSaveCueSheet(_ action: @escaping (CueSheet) -> Void) -> CueEditView {
//        var copy = self
        self.viewModel.requestSaveCueSheet = action
        return self
    }
    
    func onRequestStatus(_ action: @escaping () -> Void) -> CueEditView {
//        var copy = self
        self.viewModel.requestStatus = action
        return self
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
                    ForEach(self.viewModel.meta) { item in
                        Button(action: {
                            
                        }) {
                            HStack {
                                Text("\(item.key.caseName)")
                                Spacer()
                                Text("\(item.value)")
                            }
                        }
                    }
                    AddButton("META 추가", viewModel.add.meta)
                }
                
                Section(header: Text("Rem")) {
                    ForEach(self.viewModel.rem) { item in
                        Button(action: {
                            
                        }) {
                            HStack {
                                Text("\(item.key.caseName)")
                                Spacer()
                                Text("\(item.value)")
                            }
                        }
                    }
                    AddButton("REM 추가", viewModel.add.rem)
                }
                Section(header: Text("File : ")) {
//                    ForEach(self.viewModel.track) { item in
//                        Button(action: {
//
//                        }) {
//                            HStack {
//                                Text("\(item.key.caseName)")
//                                Spacer()
//                                Text("\(item.value)")
//                            }
//                        }
//                    }
                    AddButton("Track 추가", viewModel.add.track)
                }
                
                
            }.navigationTitle("큐 편집기")
            .navigationBarItems(leading: HStack {
                Button(action: { viewModel.executePlay() }) {
                    Image(systemName: "play")
                }
                Button(action: viewModel.requestStatus) {
                    Image(systemName: "doc.on.doc")
                }
            }, trailing: HStack {
                Button(action: { viewModel.fileSelectPicker() }) {
                    Image(systemName: "folder.badge.plus")
                }
            })
        }.sheet(item: self.$viewModel.sheetEvent, content: makeSheet)
        
    }
}

struct CueEditView_Previews: PreviewProvider {
    static var previews: some View {
        CueEditView()
    }
}
