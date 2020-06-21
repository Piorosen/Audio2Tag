//
//  CueView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueView: View {
    @ObservedObject var viewModel = CueViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.viewModel.onOpenFile()
                }, label: {
                    Text("Load")
                })
                Button(action: {
                    self.viewModel.onSplitFile()
                }, label: {
                    Text("Split")
                })
                
            }
            Text("\(viewModel.fileName)")
            
//            ScrollView {
                List (viewModel.listOfCue) { item in
                    VStack (alignment: .leading) {
                        Text("\(item.fileName)")
                        Text("\(item.duration)")
                        Text("\(item.interval)")
                    }
                }
//            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
