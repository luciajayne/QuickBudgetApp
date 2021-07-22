//@reference: www.youtube.com/watch?v=NkYcKI9t1S4&t=415s
import SwiftUI

struct SearchView: View {
    // SearchView needs a reference to transaction Model because it needs to be passed to FilterList so it can update a transaction details in Core Data.
    @ObservedObject var transactionModel: TransactionModel
    @State var nameFilter = ""
    
    var body: some View {
        VStack {
            Spacer()
            PageTitleView(title: "Search")
            TextField("Enter the name of the transaction: ", text: $nameFilter)
                .font(.title2)
                .padding()
            FilterList(transactionModel: transactionModel,filter: nameFilter)
            Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(transactionModel: TransactionModel())
    }
}
