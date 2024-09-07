//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionScreen: View {
    // MARK: - PROPERTY
    @State var searchText: String = ""
    
    private var data  = Array(1...10)
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 30) {
            CustomAvatarHeader(name: "Nguyễn Văn An", image: Image("avatar"), withClose: false)
            
            HStack(spacing: 15) {
                SearchBar(searchText: $searchText)
                
                Button {
                    
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "message")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal)
            
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    Section {
                        ForEach(data, id: \.self) { item in
                            VStack(alignment: .leading, spacing: 10) {
                                Image("sample-bonsai-01")
                                    .resizable()
                                    .frame(width: 160, height: 100, alignment: .top)
                                    .scaledToFit()
                                    .clipped()
                                
                                VStack(alignment: .leading, spacing: 4){
                                    Text("Sen Đá Kim Cương Haworthia Cooperi")
                                        .font(.system(size: 12, weight: .regular, design: .rounded))
                                        .multilineTextAlignment(.leading)
                                    
                                    
                                    Text("50.000₫")
                                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.red)
                                    
                                    Text("Đã bán 301")
                                        .font(.system(size: 8, weight: .regular, design: .rounded))
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.gray)
                                    
                                }
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                            }
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .shadow(color: .black.opacity(0.5), radius: 2, y: 4)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionScreen()
}
