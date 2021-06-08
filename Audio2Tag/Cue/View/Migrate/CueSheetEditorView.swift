//
//  CueSheetEditorView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/03.
//

import SwiftUI
import SwiftCueSheet
import Combine
import Introspect


fileprivate extension  UITextField {
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
        self.resignFirstResponder()
    }
}


extension TextField {
    func customToolBar() -> some View {
        return self.introspectTextField { (textField) in
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
            toolBar.items = [flexButton, doneButton]
            toolBar.setItems([flexButton, doneButton], animated: true)
            textField.inputAccessoryView = toolBar
        }
    }
}

struct CueSheetEditorView: View {
    let item: CueSheetSheetList
    
    @Binding var cueRem:[CueSheetRem]
    @Binding var cueMeta:[CueSheetMeta]
    @Binding var cueTrack:[CueSheetTrack]
    
    @Binding var cueFile: CueSheetFile
    @Binding var present: CueSelectMode?
    
    var body: some View {
        NavigationView {
            Group {
                switch item {
                case .metaAdd:
                    CueSheetEditorAddMeta(cueMeta: $cueMeta, present: $present)
                case .remAdd:
                    CueSheetEditorAddRem(cueRem: $cueRem, present: $present)
                case .trackAdd:
                    CueSheetEditorAddTrack(cueTrack: $cueTrack, present: $present)
                    
                case .trackMetaAdd(let trackUUID):
                    CueSheetEditorTrackAddMeta(cueTrack: $cueTrack, present: $present, uuid: trackUUID)
                    
                case .trackRemAdd(let trackUUID):
                    CueSheetEditorTrackAddRem(cueTrack: $cueTrack, present: $present, uuid: trackUUID)
                    
                //                case .file:
                //                    CueSheetEditorEditFile(cueFile: $cueFile, present: $present)
                //
                //                case .metaEdit(let uuid):
                //                    CueSheetEditorEditMeta(cueMeta: $cueMeta, present: $present, uuid: uuid)
                //
                //                case .remEdit(let uuid):
                //                    CueSheetEditorEditRem(cueRem: $cueRem, present: $present, uuid: uuid)
                
                //                case .trackRemEdit(let track, let rem):
                //                    CueSheetEditorTrackEditRem(cueTrack: $cueTrack, present: $present, trackUUID: track, remUUID: rem)
                //
                //
                //                case .trackMetaEdit(let track, let meta):
                //                    CueSheetEditorTrackEditMeta(cueTrack: $cueTrack, present: $present, trackUUID: track, metaUUID: meta)
                
                case .trackTimeEdit(let track):
                    CueSheetEditorEditTime(cueTrack: $cueTrack, present: $present, trackUUID: track)
                    
                default:
                    EmptyView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct CueSheetAlertView: View {
    init(item: CueSheetAlertList,
         cueRem: Binding<[CueSheetRem]>,
         cueMeta: Binding<[CueSheetMeta]>,
         cueTrack: Binding<[CueSheetTrack]>,
         cueFile: Binding<CueSheetFile>,
         present: Binding<CueSheetAlertList?>,
         _ callback: @escaping (@escaping () -> Void, @escaping () -> Void) -> Void) {
        self.item = item
        self._cueRem = cueRem
        self._cueMeta = cueMeta
        self._cueTrack = cueTrack
        self._cueFile = cueFile
        self._present = present
        
        callback(okCallEvent, cancelCallEvent)
    }
    
    let item: CueSheetAlertList
    
    @Binding var cueRem:[CueSheetRem]
    @Binding var cueMeta:[CueSheetMeta]
    @Binding var cueTrack:[CueSheetTrack]
    
    @Binding var cueFile: CueSheetFile
    @Binding var present: CueSheetAlertList?
    
    func okCallEvent() -> Void {
        print("!!!!!!!")
    }
    
    func cancelCallEvent() -> Void {
        print("@@@@@@")
    }
    
    var body: some View {
        Group {
            switch item {
            
            case .file:
                CueSheetEditorEditFile(cueFile: $cueFile, present: $present)
                
            case .metaEdit(let uuid):
                CueSheetEditorEditMeta(cueMeta: $cueMeta, present: $present, uuid: uuid)
                
            case .remEdit(let uuid):
                CueSheetEditorEditRem(cueRem: $cueRem, present: $present, uuid: uuid)
                
            case .trackRemEdit(let track, let rem):
                CueSheetEditorTrackEditRem(cueTrack: $cueTrack, present: $present, trackUUID: track, remUUID: rem)
                
            case .trackMetaEdit(let track, let meta):
                CueSheetEditorTrackEditMeta(cueTrack: $cueTrack, present: $present, trackUUID: track, metaUUID: meta)
                
            }
        }
    }
}

