//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct TimerView: View {
    // MARK: - PROPERTY
    @Binding var timeRemaining: Int
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: - BODY

    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("\(dayString(time: timeRemaining))")
                
                Text("Ngày")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
            .frame(width: 70)
            .background(Color(uiColor: UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            
            VStack {
                Text("\(hourString(time: timeRemaining))")
                
                Text("Giờ")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
            .frame(width: 70)
            .background(Color(uiColor: UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            
            VStack {
                Text("\(minuteString(time: timeRemaining))")
                
                Text("Phút")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
            .frame(width: 70)
            .background(Color(uiColor: UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            
            VStack {
                Text("\(secondString(time: timeRemaining))")
                
                Text("Giây")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
            .frame(width: 70)
            .background(Color(uiColor: UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            
        }
        .foregroundStyle(
            LinearGradient(colors: [.darkBlue, .mint, .blue], startPoint: .top, endPoint: .bottom)
        )
        .font(.system(size: 30))
        .fontWeight(.black)
        .fontDesign(.rounded)
        .shadow(radius: 4, x: 2, y: 2)
        .onReceive(timer) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer.upstream.connect().cancel()
            }
        }
    }
    
    //Convert the time into 24hr (24:00:00) format
    func timeString(time: Int) -> String {
        let days = Int(time) / (24*60*60)
        let hours = (Int(time) % (24*60*60)) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i:%02i", days, hours, minutes, seconds)
    }
    func dayString(time: Int) -> String {
        let days = Int(time) / (24*60*60)
        return String(format:"%02i", days)
    }
    
    func hourString(time: Int) -> String {
        let hours = (Int(time) % (24*60*60)) / 3600
        return String(format:"%02i", hours)
    }
    
    func minuteString(time: Int) -> String {
        let minutes = Int(time) / 60 % 60
        return String(format:"%02i", minutes)
    }
    
    func secondString(time: Int) -> String {
        let seconds = Int(time) % 60
        return String(format:"%02i", seconds)
    }
}

// MARK: - PREVIEW
#Preview {
    TimerView(timeRemaining: .constant(50*60*60))
}
