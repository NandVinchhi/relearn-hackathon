import SwiftUI
import Charts

extension View {
    func fadeOutTop(fadeLength:CGFloat=20) -> some View {
        return mask(
            VStack(spacing: 0) {

                // Top gradient
                LinearGradient(gradient:
                   Gradient(
                       colors: [Color.black.opacity(0), Color.black]),
                       startPoint: .top, endPoint: .bottom
                   )
                   .frame(height: fadeLength)
                
                Rectangle().fill(Color.black)
                
                LinearGradient(gradient:
                   Gradient(
                       colors: [Color.black, Color.black.opacity(0)]),
                       startPoint: .top, endPoint: .bottom
                   )
                   .frame(height: fadeLength)
            }
        )
    }
}

struct ProgressGraphView: View {

    @EnvironmentObject var vm: RequestModel
    @State var likesData {
        return vm.getLikesData()
    }
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                Text("YOUR LAST WEEK")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                
                Chart {
                    ForEach(likesData) {item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("Likes", item.likes)
                        ).interpolationMethod(.catmullRom)
                            .foregroundStyle(Color.light)
                            .lineStyle(.init(lineWidth: 4))
                            
                    }
                }
            }.frame(width: 340, height: 180)
                .zIndex(10)
                .padding(10)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.white)
                .zIndex(2)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.dark)
                .offset(x: 4, y: 4)
                .zIndex(1)
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.dark, lineWidth: 2)
                .zIndex(2)
        }.frame(width: 350)
            .padding(.top, 8)
    }
}

struct TopicView: View {
    var topicName: String
    var unitList: [UnitType]
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                Text(topicName.uppercased())
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                
                ForEach(unitList, id: \.self) { unit in
                    VStack {
                        HStack {
                            Text(unit.text)
                                .fontWeight(.medium)
                                .font(.system(size: 18))
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(Color.dark)
                                    .frame(width: unit.number >= 100 ? 64: 52, height: 25)
                                    .zIndex(0)
                                Text(String(unit.number) + "%")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .font(.system(size: 16))
                                    .zIndex(1)
                            }
                        }
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: 17)
                                .stroke(Color.dark, lineWidth: 2)
                                .zIndex(2)
                            
                            let val = 3.4 * Double(unit.number)
                            RoundedRectangle(cornerRadius: 17)
                                .foregroundColor(unit.number == 100 ? Color.hundred : Color.light)
                                .frame(width: val, alignment: .leading)
                                .zIndex(1)
                        }.frame(width: 340, height: 15)
                    }.padding(.bottom, 12)
                }
                Spacer()
            }.zIndex(10)
            .padding(10)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.white)
                .zIndex(2)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.dark)
                .offset(x: 4, y: 4)
                .zIndex(1)
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.dark, lineWidth: 2)
                .zIndex(2)
            
        }
            .scaledToFit()
            .frame(width: 360)
            .padding(.top, 12)

    }
}

struct ProgressPage: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack (spacing: 5) {
            
            HStack() {
                Button(action: {
                    dismiss()
                }) {
                    Image("rightarrow")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.black)
                        .frame(height: 40)
                        .zIndex(1)
                        .rotationEffect(.degrees(180))
                }
                Spacer()
            }.padding(.leading, 16)
            
            Text("Progress")
                .fontWeight(.bold)
                .font(.system(size: 30))
                .padding(.top, -42)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    ProgressGraphView()
                        .padding(.top, 12)
                    
                    ForEach(likesData, id: \.self) { data in
                        TopicView(topicName: data.topic,
                                  unitList: data.unitList)
                    }
                    
                    
                    RoundedRectangle(cornerRadius: 72)
                        .frame(width: 70, height: 6)
                        .foregroundColor(Color.lightGray)
                        .padding(.top, 12)
                    
                }.padding(.trailing, 5)
                .padding(.bottom, 24)
            }.fadeOutTop(fadeLength: 10)
            Spacer()
        }
    }
}

#Preview {
    ProgressPage()
}
