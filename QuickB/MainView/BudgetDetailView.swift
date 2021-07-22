import SwiftUI

struct BudgetDetailView: View {
    @ObservedObject var transactionModel: TransactionModel
    @Binding var isPresented: Bool //variable for Presenting this View
    @State var didUpdate: Bool = false // when the update button gets clicked
    @State var amount:Int = 1
    
    var body: some View {
        VStack{
            Spacer()
            PageTitleView(title: "Current Budget Limit")
                .onTapGesture (count: 2){
                    self.isPresented = false // dismisses the presenting sheet
                }
            HStack {
                Spacer()
                Text("$ \(transactionModel.currentBudgetLimit)").padding(11)
                    .font(.title3)
                    .background(Color(.clear))
                Spacer()
            }
            
            PageTitleView(title: "Enter New Budget Limit")
            HStack{
                Stepper(value: $amount, in: 1...100){
                    Text("Amount: $ \(amount)")
                }
                Spacer()
            }
            .padding()
            Button(action: updateBudgetLimit) {
               Text("Update")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                .background(Color("G4"))
                    .foregroundColor(Color("IP"))
                    .cornerRadius(5)
            }
            Spacer()
        }.background(Color(red: 242 / 255, green: 242 / 255, blue: 246 / 255)) //Apple gray color
    }
    
    func updateBudgetLimit(){
        isPresented = false //to dismiss the presenting sheet
        transactionModel.setBudgetLimit(newBudgetLimit: amount)
    }
}

struct BudgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetDetailView(transactionModel: TransactionModel(), isPresented: .constant(true))
    }
}
