//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct MyChatBox: View {
    // MARK: - PROPERTY
    var textMessage: String
    var textState: String
    var textTime: Date
    
    @State var degreesRotating = 0.0
    
    @State var isShowingInformation: Bool = false
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Spacer(minLength: 60)
            
            HStack {
                VStack(alignment: .trailing) {
                    if isShowingInformation {
                        Text(textTime, format: .dateTime)
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                    }
                    
                    HStack {
                        if textState == "Sent" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            
                        } else if textState == "Received" {
                            Image(systemName: "checkmark.circle")
                        } else if textState == "Sending" {
                            Image(systemName: "paperplane")
                                .rotationEffect(.degrees(degreesRotating))
                                .onAppear {
                                    withAnimation(.linear(duration: 1).speed(1).repeatForever(autoreverses: false)) {
                                        degreesRotating = 360
                                    }
                                }
                        }
                        
                        Text(textMessage)
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .padding(8)
                            .multilineTextAlignment(.leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(
                                        LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                                    )
                            )
                            .shadow(radius: 3, x: -2, y: -2)
                        
                        
                    }
                }
                .padding(.trailing, 12)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isShowingInformation.toggle()
        }
        .animation(.easeInOut, value: isShowingInformation)
        .frame(alignment: .trailing)
    }
}

// MARK: - PREVIEW
#Preview {
    MyChatBox(textMessage: "A", textState: "Sent", textTime: Date())
}
