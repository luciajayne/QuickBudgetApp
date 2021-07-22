//@reference: www.youtube.com/watch?v=NkYcKI9t1S4&t=415s
import CoreData
import SwiftUI

struct FilterList: View {
    @ObservedObject var transactionModel: TransactionModel
    var fetchRequest: FetchRequest<Transaction>
    
    @State var didTap: Bool = false
    var body: some View {
        NavigationView {
            List(fetchRequest.wrappedValue, id: \.self) { transaction in
                HStack{
                    Text(transaction.wrappedDate)
                    Text(transaction.wrappedCategory)
                        .fontWeight(.bold)
                    Text(transaction.wrappedName)
                    Spacer()
                    Text("$ ")
                    Text("\(transaction.amount)")
                }
                .onTapGesture (count: 2, perform: {
                        updateOneTransaction(transaction: transaction)
                    })
                    .sheet(isPresented: $didTap) { // It shows Update Presenting Sheet
                        UpdateView(transactionModel: transactionModel, isPresented: $didTap)
                        }
            }
            .navigationTitle("Matching Results")
            .navigationBarItems(trailing: Text(" "))
        }
    }
    
    func updateOneTransaction(transaction: FetchedResults<Transaction>.Element){
        didTap = true;
        //Updates the current transaction on the Transaction Model Object
        transactionModel.setCurrentTransaction(transactionID: transaction.transactionID,date: transaction.wrappedDate, category: transaction.wrappedCategory, name: transaction.wrappedName, amount: Int(transaction.amount))
    }
    
    init(transactionModel: TransactionModel, filter: String){
        self.transactionModel = transactionModel
        fetchRequest = FetchRequest<Transaction>(entity:Transaction.entity(), sortDescriptors:[], predicate: NSPredicate(format: "name CONTAINS %@", filter))
    }
}
