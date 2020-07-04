//
//TagMainView.swift
//Audio2Tag
//
//CreatedbyAoikaztoon2020/06/22.
//Copyright©2020Aoikazto.Allrightsreserved.
//

import SwiftUI

struct TagMainView : View{
    @ObservedObject var viewModel = TagMainViewModel()
    @State var isActive = false
    
    var body :some View {
        VStack {
            HStack {
                Button(action: self.viewModel.openFile) {
                    Text("Open")
                }
                
                Button(action: self.viewModel.runTagging) {
                    Text("Tagging")
                }
                Button(action: self.viewModel.downloadFreeDB) {
                    Text("FreeDB")
                }
                Button(action: { self.isActive = true; self.viewModel.downloadVgmDB() }) {
                    Text("VgmDB")
                }.sheet(isPresented: self.$isActive) {
                    TagSearchModalView()
                }
                
                Spacer()
            }
            
            HStack {
                ScrollView {
                    VStack {
                        TagElementView("Artist", text: self.$viewModel.artist)
                        TagElementView("Album", text: self.$viewModel.album)
                        TagElementView("Year", text: self.$viewModel.year)
                        Group {
                            TagElementView("Track", text: self.$viewModel.track)
                            TagElementView("Genre", text: self.$viewModel.genre)
                            TagElementView("Comment", text: self.$viewModel.comment)
                        }
                        TagElementView("Directory", text: self.$viewModel.directory)
                        TagElementView("AlbumArtist", text: self.$viewModel.albumArtist)
                        TagElementView("Composer", text: self.$viewModel.composer)
                        TagElementView("DiscNum", text: self.$viewModel.discNum)
                    }
                }.frame(maxWidth: 250, maxHeight: .infinity)
                
                NavigationView {
                    List {
                        Section(header: Text("id")) {
                            ForEach (0..<self.viewModel.item.count, id: \.self) { index in
                                NavigationLink(destination: TagListInformationView(item: self.$viewModel.item[index])) {
                                    Text("\(self.viewModel.item[index].directory)")
                                }
                            }
                        }
                    }
                }
            }
        }.frame(maxWidth:.infinity,maxHeight:.infinity)
    }
}

struct TagMainView_Previews: PreviewProvider{
    static var previews: some View{
        TagMainView()
    }
}
