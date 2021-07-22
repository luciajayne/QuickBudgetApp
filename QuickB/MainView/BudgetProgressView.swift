//@reference: www.simpleswiftguide.com/how-to-build-a-circular-progress-bar-in-swiftui/

import SwiftUI

struct BudgetProgressView: View {
    @State var progressValue: Float = 0.0
    @ObservedObject var transactionModel: TransactionModel
    
    var body: some View {
        VStack {
            ProgressBarView(progress: self.$progressValue)
                .frame(width: 150.0, height: 150.0)
                .padding(40.0)

            Button(action: {
                self.incrementProgress()
            }) {
                HStack {
                    //Image(systemName: "plus.rectangle.fill")
                    Text("Budget Remaining")
                        .foregroundColor(.white)
                        .bold()
                        .padding(10)
                }
                .background(Color("G4"))
                .foregroundColor(Color("IP"))
                .cornerRadius(5)
           }
        }.background(Color(red: 242 / 255, green: 242 / 255, blue: 246 / 255)) //Gray that matches Apple preset gray background color
    }
        //Calculates the percentage of the budget that has been used so far in relation to the Budget Limit
        func incrementProgress() {
            self.progressValue = Float(transactionModel.budgetTotal)/Float(transactionModel.currentBudgetLimit)
        }
}

struct BudgetProgressView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetProgressView(transactionModel: TransactionModel())
    }
}
