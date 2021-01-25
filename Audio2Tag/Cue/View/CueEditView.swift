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


// MARK: - Sheet 관련 (파일 선택창 및 파일 저장 하는 선택창 관련)
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


// MARK: - CustomAlertView와 관련하여 META 및 REM 데이터 수정 및 추가 기능
extension CueEditView {
    func AddCustomAlert() -> CustomAlertView {
        return CustomAlertView(item: self.$viewModel.addEvent, title: "추가",
                        ok: { viewModel.addItems(event: currentType, key: title, value: value); title = ""; value = ""  },
                        cancel: { title = ""; value = "" }) { i in
            VStack(alignment: .leading) {
                Text("Key")
                TextField("\(title)", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Value")
                TextField("\(value)", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding()
        }
    }
    
    func EditCustomAlert() -> CustomAlertView {
        return CustomAlertView(item: self.$viewModel.editEvent, title: "수정", ok: { title = ""; value = "" }, cancel: { title = ""; value = "" }) { i in
            VStack(alignment: .leading) {
                Text("Key")
                switch i {
                case .meta(let p):
                    Text("\(viewModel.meta.first(where: { item in item.id == p })?.key.caseName ?? "Error")")
                case .rem(let p):
                    Text("\(viewModel.rem.first(where: { item in item.id == p })?.key.caseName ?? "Error")")

                case .track(let p):
                    Text("\(viewModel.track.first(where: { item in item.id == p })?.title ?? "Error")")
                }
                Text("Value")
                TextField("\(value)", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding()
        }
    }
}



// MARK: -
struct CueEditView: View {
    @ObservedObject var viewModel = CueEditViewModel()
    
    @State var currentType: CueEditViewModel.Event? = nil
    
    @State var title: String = ""
    @State var value: String = ""
    
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
                EditSection(meta: $viewModel.meta, rem: $viewModel.rem, track: $viewModel.track)
                    .addMeta(   { uuid in currentType = .meta(uuid); viewModel.add.meta  (uuid) } )
                    .addRem(    { uuid in currentType = .rem(uuid); viewModel.add.rem   (uuid) } )
                    .addTrack(  { uuid in currentType = .track(uuid); viewModel.add.track (uuid) } )
                    .editMeta(  { uuid in currentType = .meta(uuid); viewModel.edit.meta (uuid) } )
                    .editRem(   { uuid in currentType = .rem(uuid); viewModel.edit.rem  (uuid) } )
                    .editTrack( { uuid in currentType = .track(uuid); viewModel.edit.track(uuid) } )
                
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
            .customAlertView([
                self.AddCustomAlert(),
                self.EditCustomAlert()
            ])
        }.sheet(item: self.$viewModel.sheetEvent, content: makeSheet)
    }
}

struct CueEditView_Previews: PreviewProvider {
    static var previews: some View {
        CueEditView()
    }
}
