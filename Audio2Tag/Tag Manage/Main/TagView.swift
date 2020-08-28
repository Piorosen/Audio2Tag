//
//  TagView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

extension TagView {
    func makeSheet() -> some View {
        return Group {
            if viewModel.tagSheetEnum == .tagRequest {
                TagSearchView(kind: .MusicBrainz)
            }else if viewModel.tagSheetEnum == .documentAudio {
                DocumentPicker()
                    .setConfig(folderPicker: false, allowMultiple: true)
                    .setUTType(type: [.audio, .directory])
                    .onSelectFiles(completeHanlder: viewModel.selectAudioRequest)
            }else {
                EmptyView()
            }
        }
    }
    
    func makeActionSheet() -> ActionSheet {
        ActionSheet(title: Text("검색"), message: Text("Tag 정보를 검색합니다."), buttons: [
            .default(Text("VgmDB")) { },
            .default(Text("MusicBrainz")) { },
            .cancel()
        ])
    }
}

struct TagView: View {
    @ObservedObject var viewModel = TagViewModel()
    
    var body: some View {
        NavigationView{
            List {
                Section(header: Text(""), content: <#T##() -> _#>)
            }
            .navigationTitle("Tag Info")
            .navigationBarItems(trailing: TagNavigationTraillingView()
                                    .onTagReuqest(self.viewModel.tagRequest)
                                    .onAudioRequest(self.viewModel.audioRequest))
        }
        .sheet(isPresented: $viewModel.openSheet, content: makeSheet)
        .actionSheet(isPresented: $viewModel.openActionSheet, content: makeActionSheet)
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
    }
}
