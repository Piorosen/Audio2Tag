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
            List {
                Section(header: Text("Meta")) {
                    ForEach (self.viewModel.metaData) { meta in
                        HStack {
                            Text(meta.value.key)
                            Spacer()
                            Text(meta.value.value)
                        }
                    }
                }
                Section(header: Text("Rem")) {
                    ForEach (self.viewModel.remData) { meta in
                        HStack {
                            Text(meta.value.key)
                            Spacer()
                            Text(meta.value.value)
                        }
                    }
                }
                Section(header: Text("File : \(self.viewModel.fileName)")) {
                    ForEach (0..<self.viewModel.track.count, id: \.self) { index in
                        NavigationLink(destination: CueDetailTrackView(self.viewModel.track[index])) {
                            Text("\(index + 1) : \(self.viewModel.track[index].track.title)")
                        }
                    }
                }
            }
            .navigationBarTitle("Cue Info")
            .navigationBarItems(leading: Group {
                Button(action: self.viewModel.splitFile) {
                    Text("Make")
                }.alert(isPresented: self.$viewModel.isSplitPresented) {
                    Alert(title: Text("파일 분리"),
                          message: Text("Cue File 기준으로 파일을 분리 하겠습니까?"),
                          primaryButton: .cancel(Text("취소")),
                          secondaryButton: .default(Text("확인"), action: self.viewModel.alertOK))
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
