import SwiftUI
import CoreData

struct UpdateView: View {
    @ObservedObject var transactionModel: TransactionModel
    @Binding var isPresented: Bool //var for Presenting this View
    private let categories:[Category] = [.food, .rent, .miscellaneous]
    @State var name: String = ""
    @State var date:String = ""
    @State var amount:Int = 1
    @State var category:Category = .food
    @State var didUpdate: Bool = false // var to manage when the update button gets clicked
    
    var body: some View {
        VStack{
            Spacer()
            PageTitleView(title: "Current Transaction")
                .onTapGesture (count: 2){
                    self.isPresented = false // dismisses the presenting sheet
                }
            HStack {
                Text("\(transactionModel.currentTransactionDate)").padding(11)
                Text("\(transactionModel.currentTransactionCategory)")
                    .bold()
                Text("\(transactionModel.currentTransactionName)")
                Spacer()
                Text("$ \(transactionModel.currentTransactionAmount)")
                    .padding()
            }
            .font(.title3)
            .background(Color(.white))
            PageTitleView(title: "Enter New Details")
            Picker(selection:$category,label:Text("Category")){
                ForEach(categories, id:\.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            HStack{
                Text("Name: ")
                TextField("Enter New Name",text: $name)
                    //.background(Color("G1"))
                Spacer()
            }
            .padding()
            HStack{
                Text("Date: ")
                TextField("Enter New Date ",text: $date)
                Spacer()
            }
            .padding()
            HStack{
                Stepper(value: $amount, in: 1...100){
                    Text("Amount: $ \(amount)")
                }
                Spacer()
            }
            .padding()
            Button(action: updateTransaction) {
               Text("Update")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                .background(Color("G4"))
                    .foregroundColor(Color("IP"))
                    .cornerRadius(5)
            }
            Spacer()
        }.background(Color(red: 242 / 255, green: 242 / 255, blue: 246 / 255))
    }
    
    func updateTransaction(){ //Assuming all the fields have been changed
        isPresented = false //to dismiss the presenting sheet
        transactionModel.updateTransaction(transactionID:transactionModel.currentTransactionID ,date: date, category: category.rawValue, newName: name, amount: amount)
    }
    
    mutating func setAmount(newAmount: Int) {
        //mutating functions allow to the change the properties of UpdateView
        amount = newAmount 
    }
    
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateView(transactionModel: TransactionModel(), isPresented: .constant(true)) 
    }
}
