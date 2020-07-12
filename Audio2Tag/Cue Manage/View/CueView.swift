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

    let list = [1,2,3,4,5,6,7,8,9,0]
    
    var body: some View {
        
        NavigationView {
            List(list, id: \.self) { item in
                Text("\(item)")
            }
            .sheet(isPresented: self.$viewModel.isDocumentShow, content: self.viewModel.showDocument)
            .navigationBarTitle("Tracks")
            .navigationBarItems(trailing: Group {
                Button(action: self.viewModel.addItem) {
                    Text("+")
                }
            })
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}