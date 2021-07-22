// Presenting Sheet to Add Transaction

import SwiftUI

struct AddTransactionView: View {
    @Binding var isPresented: Bool// var to display this View
    @ObservedObject var transactionModel: TransactionModel
    let categories:[Category] = [.food, .rent, .miscellaneous]
    @State var name:String = ""
    @State var date:String = ""
    @State var amount:Int = 1
    @State var category:Category = .food
    
    @State var didAddNew: Bool = false // to manage when the "Add" button is clicked
    @Environment(\.managedObjectContext) private var viewContext //CoreData: NSManagedObjectContext
    
    var body: some View {
        VStack{
            Spacer()
            PageTitleView(title: "Add Transaction")
                .onTapGesture (count: 2){
                    self.isPresented = false // dismisses the presenting sheet
                }

            Picker(selection:$category,label:Text("Category")){
                ForEach(categories, id:\.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            HStack{
                Text("Name: ")
                TextField("Type the name",text: $name)
                Spacer()
            }
            .padding()
            HStack{
                Text("Date: ")
                TextField("MM-DD",text: $date)
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
            Button(action: addNewTransaction) {
               Text("Add")
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
    
    func addNewTransaction(){
        // presenting sheet
        isPresented = false
        //adds animation each time a transaction is added
        withAnimation {
            let newTransaction = Transaction(context:viewContext)
            newTransaction.name = name
            newTransaction.date = date
            newTransaction.category = category.rawValue
            newTransaction.amount = Int32(amount) //wrapping to comply with CoreData
            newTransaction.transactionID = Int32(transactionModel.newID())
            saveContext() //saves the transaction in CoreData
        }
        transactionModel.updateSummaries() //Updates the summaries after the new value was added
    }
    private func saveContext(){
        //save to Core Data using the singleton context
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
        
    }
    
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(isPresented: .constant(true), transactionModel: TransactionModel())
    }
}
