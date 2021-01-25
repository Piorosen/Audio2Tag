//
//  MusicSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2021/01/23.
//

import SwiftUI

struct MusicSection: View {
    var body: some View {
        Section(header: Text("Music")) {
            HStack {
                Text("음원 길이")
                Spacer()
                Text("")
            }
            HStack {
                Text("채널 수")
                Spacer()
                Text("")
            }
            HStack {
                Text("샘플 레이트")
                Spacer()
                Text("")
            }
        }
    }
}

struct MusicSection_Previews: PreviewProvider {
    static var previews: some View {
        MusicSection()
    }
}
