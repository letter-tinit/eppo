//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct RecomendGrid: View {
    // MARK: - PROPERTY
    @State private var segment = 0
    private var data  = Array(1...10)
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .purple
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.purple], for: .normal)
    }
    
    // MARK: - BODY
    
    var body: some View {
                LazyVGrid(columns: adaptiveColumn, spacing: 20, pinnedViews: [.sectionHeaders]) {
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
                    } header: {
                        Picker("Tab segments", selection: $segment) {
                            Text("Dành cho bạn").tag(0)
                            Text("Cho Thuê").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 50)
                        .padding(.top)
                    }
                }
//            }
            .background(.white)
    }
}

// MARK: - PREVIEW
#Preview {
    RecomendGrid()
}
