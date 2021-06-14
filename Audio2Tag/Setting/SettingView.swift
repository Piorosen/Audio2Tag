//
//  SettingView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/14.
//

import SwiftUI

struct SettingView: View {
    @State var test = false
    
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Cue")) {
                    HStack{
                        Toggle(isOn: $test) {
                            Text("AutoMobile")
                        }
                    }
                }
                Section(header: Text("Tag")) {
                    EmptyView()
                }
            }
            .navigationTitle("Setting")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
