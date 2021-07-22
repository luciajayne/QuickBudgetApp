
import SwiftUI

struct ContentHeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            Image("QB Logo")
                .cornerRadius(10)
            Text("QuickBudget")
                .font(.title)
                .foregroundColor(Color("G4"))
            Spacer()
        }
        .background(Color(.clear))
        .padding()
    }
}

struct ContentHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ContentHeaderView()
    }
}
