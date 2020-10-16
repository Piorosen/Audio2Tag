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
        ZStack {
            CueSheetView()
                .onReuqestOpenState(viewModel.reuqestOpenState)
                .onSplitStart(viewModel.splitStart)
                .blur(radius: self.viewModel.isShowing ? 5 : 0)
                .animation(.easeOut)
            
            CueSplitView(bind: $viewModel.splitState, isPresented: self.$viewModel.isShowing)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.spring())
                .alert(isPresented: $viewModel.openAlert) {
                    Alert(title: Text("오류"), message: Text("태그를 저장할 수 있는 포맷이 아닙니다. 저장하지 않고 계속 진행하시겠습니까?"), primaryButton: .default(Text("예"), action: { viewModel.splitRun(b: true) }), secondaryButton: .cancel(Text("아니요"), action: { viewModel.splitRun(b: false) }))
                }
            
        }
    }
}
