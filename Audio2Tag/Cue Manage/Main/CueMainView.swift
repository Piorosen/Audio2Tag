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
    
//    func update(urls:[URL]){
//        viewModel.selectFiles(urls)
//    }
//
    var body: some View {
        ZStack {
            CueSheetInfoView()
                .blur(radius: self.viewModel.isShowing ? 5 : 0)
                .animation(.easeOut)
            
            SplitMusicView(bind: self.$viewModel.status, isPresented: self.$viewModel.isShowing)
        }
    }
}
