//
//  CueInfoNavigationBarLeading.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/16.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueInfoNavigationBarLeading: View {
    private var start = { }
    private var state = { }
    
    func onSplitStart(_ action: @escaping () -> Void) -> CueInfoNavigationBarLeading {
        var copy = self
        copy.start = action
        return copy
    }
    
    func onSplitState(_ action : @escaping () -> Void) -> CueInfoNavigationBarLeading {
        var copy = self
        copy.state = action
        return copy
    }
    
    var body: some View {
        HStack {
            Button(action: self.start) {
                Image(systemName: "play").padding(10)
            }
            Button(action: self.state){
                Image(systemName: "doc.on.doc").padding(10)
            }
        }
    }
}

//.sheet(isPresented: self.$viewModel.showFolderSelection) {
//    DocumentPicker()
//        .setConfig(folderPicker: true)
//        .onSelectFile { url in
//            self.viewModel.musicOfSplit(url: url)
//    }.$viewModel.showLeadingAlert, content: self.makeAlert)
//}.alert(isPresented: self
