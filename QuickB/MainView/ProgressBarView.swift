import SwiftUI
//@reference: www.simpleswiftguide.com/how-to-build-a-circular-progress-bar-in-swiftui/
struct ProgressBarView: View {
    @Binding var progress: Float
       
   var body: some View {
       ZStack {
           Circle()
               .stroke(lineWidth: 20.0)
               .opacity(0.3)
               .foregroundColor(Color("G2"))
           
           Circle()
               .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
               .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
               .foregroundColor(Color("G4"))
               .rotationEffect(Angle(degrees: 270.0))
               .animation(.linear)

           Text(String(format: "%.0f %%", min((1-self.progress), 1.0)*100.0))
               .font(.largeTitle)
               .bold()
       }
   }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(progress: .constant(0.0))
    }
}
