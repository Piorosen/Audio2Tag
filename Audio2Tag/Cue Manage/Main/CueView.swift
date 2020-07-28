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
            CueFileInfoView(fileInfo: self.$viewModel.cueSheetModel)
                .sheet(isPresented: self.$viewModel.openSheet) { self.viewModel.makeSheet() }
            .alert(isPresented: self.$viewModel.openAlert) { self.viewModel.makeAlert() }
            .navigationBarTitle("Cue Info")
            .navigationBarItems(
            leading:
                Button(action: self.viewModel.navigationLeadingButton) { Text("Make") },
            trailing:
                Button(action: self.viewModel.navigationTrailingButton) { Image(systemName: "plus") }
            )
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
