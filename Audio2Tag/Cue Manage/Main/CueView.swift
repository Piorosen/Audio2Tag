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
    
    func update(urls:[URL]){
        viewModel.selectFiles(urls)
    }
    
    var body: some View {
        ZStack {
            CueFileInfoView()
                .blur(radius: self.viewModel.isShowing ? 5 : 0)
                .animation(.easeOut)
            
            SplitMusicView(bind: self.$viewModel.status, isPresented: self.$viewModel.isShowing)
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
