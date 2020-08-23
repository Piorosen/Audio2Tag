//
//  CueView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueView: View {
    @ObservedObject var viewModel = CueMainViewModel()
    @State var stateShow = false
    
//    func update(urls:[URL]){
//        viewModel.selectFiles(urls)
//    }
//
    var body: some View {
        ZStack {
            CueSheetInfoView()
                .onReuqestOpenState(viewModel.reuqestOpenState)
                .onSplitStart(viewModel.splitStart)
                .blur(radius: self.viewModel.isShowing ? 5 : 0)
                .animation(.easeOut)
            
            SplitMusicView(bind: $viewModel.splitState, isPresented: self.$viewModel.isShowing)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                .animation(.spring())
        }
    }
}
