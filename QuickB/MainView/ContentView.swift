import SwiftUI

struct ContentView: View {
    @ObservedObject var transactionModel: TransactionModel
    var body: some View {
        
        AllListView(transactionModel: transactionModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(transactionModel: TransactionModel())
// Settings for Dark Mode
        ContentView(transactionModel: TransactionModel())
            .colorScheme(.dark)
            .background(Color.black)
    }
}
