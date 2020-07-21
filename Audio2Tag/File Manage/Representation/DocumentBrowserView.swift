//
//  DocumentBrowserView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/12.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import UIKit
import SwiftUI
import MobileCoreServices

class DocumentPickerCoordinator : NSObject, UIDocumentPickerDelegate {
    var parent: DocumentPicker
    
    init(_ parent:DocumentPicker){
        self.parent = parent
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if urls.count != 0 {
            parent.oneFile?(urls[0])
            parent.multiFile?(urls)
        }
    }
}

struct DocumentPicker : UIViewControllerRepresentable {
    let isFolderPicker: Bool
    var oneFile: ((URL) -> Void)? = nil
    var multiFile: (([URL]) -> Void)? = nil
    
    
    func onSelectFile(completeHanlder: @escaping (URL) -> Void) -> DocumentPicker {
        var copy = self
        copy.oneFile = completeHanlder
        return copy
    }
    func onSelectFiles(completeHanlder: @escaping ([URL]) -> Void) -> DocumentPicker {
        var copy = self
        copy.multiFile = completeHanlder
        return copy
    }
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: isFolderPicker ?
            [String(kUTTypeFolder)] :
            ["com.aoikazto.Auido2Tag.cue", String(kUTTypeAudio), String(kUTTypeText)], in: .open)
        
        picker.allowsMultipleSelection = true
        picker.delegate = context.coordinator
        
        return picker
    }
    
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
    
}
