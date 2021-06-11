//
//  CueSheetEditorEditFile.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/06.
//

import SwiftUI

class CueSheetEditorEditFileViewModel : ObservableObject {
    @Published var fileTitle = String()
    @Published var fileType = String()
    
    @Binding var cueFile: CueSheetFile
    @Binding var present: CueSheetAlertList?
    
    init(cueFile: Binding<CueSheetFile>, present: Binding<CueSheetAlertList?>) {
        self._cueFile = cueFile
        self._present = present
    }
    
    func okCallEvent() -> Void {
        print(fileTitle)
        print(fileType)
        if !fileTitle.isEmpty {
            cueFile.fileName = fileTitle
        }
        if !fileType.isEmpty {
            cueFile.fileType = fileType
        }
        
        cancelCallEvent()
    }
    
    func cancelCallEvent() -> Void {
        present = nil
        fileTitle = String()
        fileType = String()
    }
}

struct CueSheetEditorEditFile: View {
    @ObservedObject var viewModel: CueSheetEditorEditFileViewModel
    
    func getMe(_ callback: (Self) -> Void) -> Self {
        callback(self)
        return self
    }
    
    
    init(cueFile: Binding<CueSheetFile>, present: Binding<CueSheetAlertList?>) {
        viewModel = CueSheetEditorEditFileViewModel(cueFile: cueFile, present: present)
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(viewModel.fileTitle.isEmpty ? "File Name" : "File Name : \(viewModel.cueFile.fileName)")
                    Spacer()
                }
                TextField(viewModel.cueFile.fileName.isEmpty ? "Empty Data" : viewModel.cueFile.fileName, text: $viewModel.fileTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding([.top])
            
            VStack {
                HStack {
                    Text(viewModel.fileType.isEmpty ? "File Type" : "File Type : \(viewModel.cueFile.fileType)")
                    Spacer()
                }
                TextField(viewModel.cueFile.fileType.isEmpty ? "Empty Data" : viewModel.cueFile.fileType, text: $viewModel.fileType)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding()
    }
}
