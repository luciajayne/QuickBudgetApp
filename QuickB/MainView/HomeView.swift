import SwiftUI

struct HomeView: View {
    @ObservedObject var transactionModel: TransactionModel
    @State var didUpdateBudget: Bool = false // when the row is tapped
    var body: some View {
        VStack{
            ContentHeaderView()
            PageTitleView(title: "Summary")
            Spacer()
            BudgetProgressView(transactionModel: transactionModel)
            Spacer()
            HStack{
                Text("Your Budget Limit is ")
                    .font(.title2)
                    .padding(15)
                Text("$ \(transactionModel.currentBudgetLimit)")
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: setBudgetLimit) {
                   Text("Set")
                    .font(.body)
                        .fontWeight(.bold)
                        .padding(5)
                    .background(Color("G4"))
                        .foregroundColor(Color("IP"))
                        .cornerRadius(5)
                }
                .padding(15)
            }
            .background(Color("G1"))
            .sheet(isPresented: $didUpdateBudget) { // Shows Update Presenting Sheet
                BudgetDetailView(transactionModel: transactionModel, isPresented: $didUpdateBudget)
                }
            .onTapGesture (count: 2, perform: {
                updateBudgetLimit()
            })
            
            Spacer()
        }.onTapGesture(count: 1, perform: {
            transactionModel.updateSummaries() // to update the total amount after deletion of an item
        })
        .background(Color(red: 242 / 255, green: 242 / 255, blue: 246 / 255)) //Gray that matches Apple preset gray background color
    }
    
    func updateBudgetLimit() {
        didUpdateBudget = true;
    }
    
    func setBudgetLimit() {
        didUpdateBudget = true
        BudgetDetailView(transactionModel: transactionModel, isPresented: $didUpdateBudget)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(transactionModel: TransactionModel())
    }
}
