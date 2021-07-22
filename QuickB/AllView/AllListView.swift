import SwiftUI
import CoreData

struct AllListView: View{
    @ObservedObject var transactionModel: TransactionModel
    // didAddTransaction, didUpdateTransaction used for display Presentings Sheets
    @State var didAddTransaction: Bool = false // when the add button gets clicked
    @State var didUpdateTransaction: Bool = false // when the row is tapped
    
    // CoreData: Needed variables managedObjectContext, NSSortDescriptor
    @Environment(\.managedObjectContext) private var viewContext //Apple Class type =  NSManagedObjectContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]) //also Class: NSSortDescriptor sorts the fetch request by date
    private var budgetTransactions: FetchedResults<Transaction> //FetchResults to show all transactions
        
    var body: some View {
        NavigationView {
            List{
                ForEach(budgetTransactions){ oneTransaction in
                    HStack {
                        Text(oneTransaction.wrappedDate)
                        Text(oneTransaction.wrappedCategory)
                            .fontWeight(.bold)
                        Text(oneTransaction.wrappedName)
                        Spacer()
                        Text("$ ")
                        Text("\(oneTransaction.amount)")
                    }
                    .sheet(isPresented: $didUpdateTransaction) { // Shows Update Presenting Sheet
                        UpdateView(transactionModel: transactionModel, isPresented: $didUpdateTransaction)
                        }
                    .onTapGesture (count: 2, perform: {
                        updateOneTransaction(transaction: oneTransaction)
                    })
                }
                .onDelete(perform: deleteOneTransaction)
            }
            .navigationTitle("All Transactions")
            .navigationBarItems(trailing: Button ("Add Transaction") {
                addOneTransaction()
            }.sheet(isPresented: $didAddTransaction) { // Show Add Presenting Sheet
                AddTransactionView(isPresented: $didAddTransaction, transactionModel: transactionModel)
                }
            )
        }
    }
    
    //Deletes a transaction in CoreData
    func deleteOneTransaction(offsets: IndexSet){
        //adds animation each time a transaction is deleted
        withAnimation {
            offsets.map { budgetTransactions[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    //CoreData: Updates a transaction
    func updateOneTransaction(transaction: FetchedResults<Transaction>.Element){
        didUpdateTransaction = true;
        transactionModel.setCurrentTransaction(transactionID: Int32(transaction.transactionID),date: transaction.wrappedDate, category: transaction.wrappedCategory, name: transaction.wrappedName, amount: Int(transaction.amount)) //Updates the current transaction on the transaction Model Object
    }
    //CoreData: Saves the changes to the Core Data database
    private func saveContext(){
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
        
    }
    private func addOneTransaction(){
        didAddTransaction = true // To Show Add Presenting Sheet
    }
    
}

struct AllListView_Previews: PreviewProvider {
    static var previews: some View {
        AllListView(transactionModel: TransactionModel())
    }
}
