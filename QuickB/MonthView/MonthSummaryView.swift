import SwiftUI

struct MonthSummaryView: View {
    @ObservedObject var transactionModel: TransactionModel
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Summary.category, ascending: true)]) //sorts the fetch request on alphabetical order for the categories
    private var budgetSummaries: FetchedResults<Summary>
    @State var text: Int = 0
    @State var didTap: Bool = false
    
    var body: some View {
        NavigationView {
            List{
                ForEach(budgetSummaries){ summary in
                    HStack {
                        Text("\(summary.wrappedCategory)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$ ")
                        Text("\(summary.amount)")
                    }
                }
            }
            .navigationTitle("Summaries")
            .navigationBarItems(trailing: Button ("Refresh") {
                transactionModel.updateSummaries() 
            })
        }
    }

}

struct MonthSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        MonthSummaryView(transactionModel: TransactionModel())
    }
}
