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
                TagSearchView(kind: viewModel.searchEnum)
            }else if viewModel.tagSheetEnum == .documentAudio {
                DocumentPicker()
                    .setConfig(folderPicker: false, allowMultiple: true)
                    .setUTType(type: [.audio])
                    .onSelectFiles(completeHanlder: viewModel.selectAudioRequest)
            }else {
                EmptyView()
            }
        }
    }
    
    func makeActionSheet() -> ActionSheet {
        ActionSheet(title: Text("검색"), message: Text("Tag 정보를 검색합니다."), buttons: [
            .default(Text("VgmDB"), action: viewModel.selectVgmDb),
            .default(Text("MusicBrainz"), action: viewModel.selectMusicBrainz),
            .cancel()
        ])
    }
}

struct TagView: View {
    @ObservedObject var viewModel = TagViewModel()
    
    // File List -> 선택시 해당 파일 제목 -> 태그 정보 -> 태그정보 선택 -> 수정
    // 단일 파일 == 해당 파일 제목 -> 태그정보
    var body: some View {
        NavigationView{
            List {
                if viewModel.fileInfo.count == 0 {
                    EmptyView()
                }else if viewModel.fileInfo.count == 1 {
                    EmptyView()
                }else {
                    ForEach(viewModel.fileInfo.sorted(by: { $0.fileName < $1.fileName })) { item in
                        Section(header: Text("파일 정보")) {
                            NavigationLink(destination: TagFileDetailListView()) {
                                VStack {
                                    HStack {
                                        Text("\(item.fileName)")
                                        Spacer()
                                    }
                                    Divider()
                                    HStack {
                                        Text("\(item.haveID3Tag ? "ID3 태그 정상" : "ID3 태그 오류")")
                                        Spacer()
                                        Text("\(item.ext)")
                                    }
                                }
                            }
                        }
                    }
                }
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
