//
//  CueSheetEditorEditFile.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/06.
//

import SwiftUI

struct CueSheetEditorEditFile: View {
    @State var fileTitle = String()
    @State var fileType = String()
    
    @Binding var cueFile: CueSheetFile
    @Binding var present: CueSheetAlertList?
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(fileTitle.isEmpty ? "File Name" : "File Name : \(cueFile.fileName)")
                    Spacer()
                }
                TextField(cueFile.fileName.isEmpty ? "Empty Data" : cueFile.fileName, text: $fileTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding([.top])
            
            VStack {
                HStack {
                    Text(fileType.isEmpty ? "File Type" : "File Type : \(cueFile.fileType)")
                    Spacer()
                }
                TextField(cueFile.fileType.isEmpty ? "Empty Data" : cueFile.fileType, text: $fileType)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding()
        .navigationBarItems(trailing: Button(action: {
            if !fileTitle.isEmpty {
                cueFile.fileName = fileTitle
            }
            if !fileType.isEmpty {
                cueFile.fileType = fileType
            }
            present = nil
        }) {
            Text("Edit")
        })
    }
}
