import Foundation
import CoreData
import Combine

class TransactionModel: ObservableObject{
    let qbContext = PersistenceController.shared.container.viewContext // The Model Class NEEDS access to the CoreData Context
    let summaryFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Summary")
    // The array of String for testing purposes. Future implementation: switch to the Enum Category
    let categories: [String] = ["Food", "Rent", "Misc"]
    @Published var budgetTotal: Int = 0
    @Published var currentBudgetLimit: Int = 1
    // Future implementation: the following single variables for each current transaction attribute
    // need to be refactored into: var currentTransaction: Transaction
    var currentTransactionName: String = ""
    var currentTransactionID: Int32 = 0
    var currentTransactionAmount: Int = 0
    var currentTransactionCategory: String = ""
    var currentTransactionDate: String = ""

    func setBudgetLimit(newBudgetLimit: Int){
        if isBudgetLimitEmpty() {
        // checks if the budget limit hasn't been set before, the application only needs one budget limit
            addBudgetLimitCoreData(budgetLimit: newBudgetLimit)
        }
        else{
            let budgets = fetchBudgetObject()
            budgets[0].limit = Int32(newBudgetLimit)
        }
        currentBudgetLimit = newBudgetLimit
    }
    
    //Creates a fetch request to get the Budget object stored in Core Data
    func fetchBudgetObject () -> [Budget] {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        do {
            let budgets = try qbContext.fetch(fetchRequest)
            return budgets
         }
        catch {
           fatalError("Failed to fetch transaction: \(error)")
        }
    }
    
    // Stores the inital budget limit into a variable of Transaction Model for easier access
    func initBudgetLimit() {
        if isBudgetLimitEmpty() {
            currentBudgetLimit = 0
        }
        else{
            let budgets = fetchBudgetObject()
            currentBudgetLimit = Int(budgets[0].limit)
        }
    }
    
    // Verifies the Budget Entity in Core Data doesn't have any data.
    // The Budget entity will only be empty when the application is loaded on the device for the first time
    func isBudgetLimitEmpty () -> Bool {
        let fetchRequest: NSFetchRequest<Budget>
        fetchRequest = Budget.fetchRequest()
        let objects = try! qbContext.fetch(fetchRequest)
        if objects.isEmpty {
            return true
        }
        else {
            return false
        }
    }
    
    //Saves the first budget limit into Core Data.
    //Once is saved once, the limit will only be modified and no additional budget rows will be added to the Budget Entity
    func addBudgetLimitCoreData(budgetLimit: Int) {
        let budgetList = NSEntityDescription.insertNewObject(forEntityName: "Budget", into: qbContext) as! Budget
        budgetList.budgetID = Int32(newID())
        budgetList.limit = Int32(budgetLimit)
        try! qbContext.save() // try exception
    }
    
    //Creates a fetch Request on the Transaction Entity to find a row that matches the transactionID passed in the argument
    func deleteTransactionByID (transactionID: Int32) {
        let fetchRequest: NSFetchRequest<Transaction>
        fetchRequest = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "transactionID == %@", "\(transactionID)")
        fetchRequest.includesPropertyValues = false
        let context = qbContext
        let objects = try! context.fetch(fetchRequest)
        for object in objects {
            context.delete(object)
        }
        try! context.save()
    }
    func setCurrentTransaction(transactionID: Int32, date: String, category: String, name: String, amount: Int) {
        //Future Implementation: The application will use a Transaction object to save a current Transaction information
        //The assignment changes will be done using; i.e. currentTransaction.transactionID = transactionID
        currentTransactionName = name
        currentTransactionDate = date
        currentTransactionCategory = category
        currentTransactionAmount = amount
        currentTransactionID = transactionID
    }
    
    //Use to create a new ID for each new transaction
    //Future Implementation: Apple offers UUID for entity's ids and it is a Int-128 that creates a unique ID base on the timestamp
    func newID() -> Int{
        let newID = Int.random(in: 0..<2147483640)// MAX Int32 = 2147483647. For testing it is random, future implementation UUID()
        return newID
    }
    
    func setBudgetTotal(total: Int){
        budgetTotal = total
    }
    
    //Finds the transaction by ID and the replaces the new information
    func updateTransaction(transactionID:Int32 ,date: String, category: String, newName: String, amount: Int){
        let transactions = fetchTransactionByID(filter: transactionID)
        transactions[0].name = newName
        transactions[0].amount = Int32(amount)
        transactions[0].category = category
        transactions[0].date = date
        try! qbContext.save()
        updateSummaries() // Needed to have right amount displayed in the summary database
    }
    
    //Future implementation: The Summary Entity will have an ID attribute, so the summary table is updated instead
    //of being cleared and rewritten because it is inefficient
    //Possible cause of multi-threading issue
    func initSummaries() {
        clearAllSummaries()//It is inefficient to clear every time, it needs to be updated instead
        var total = 0
        for category in categories {
            let summaryList = NSEntityDescription.insertNewObject(forEntityName: "Summary", into: qbContext) as! Summary
            let categoryTotal = calculateSummary(context: qbContext, filter: category)
            summaryList.category = category
            summaryList.amount = Int32(categoryTotal)//The Database uses Int32
            total += categoryTotal
            try! qbContext.save()
        }
        setBudgetTotal(total: total) // The budgetTotal is updated after the summaries have been recalculated
    }
    
    func clearAllSummaries() {
        clearEntityByPredicate(entity: "Summary", predicate: "Food")
        clearEntityByPredicate(entity: "Summary", predicate: "Rent")
        clearEntityByPredicate(entity: "Summary", predicate: "Misc")
    }
    
    func updateSummaries() {
        //Updates summaries after the new value was added
        //Future Implementation: Update each line, rather than initialize Summaries
        initSummaries()
    }
    
    //@reference: www.advancedswift.com/batch-delete-everything-core-data-swift/
    func clearEntityByPredicate(entity: String, predicate: String ) {
        let fetchRequest: NSFetchRequest<Summary>
        fetchRequest = Summary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", predicate) // Create a fetch request with a predicate
        fetchRequest.includesPropertyValues = false // the fetch request only gets the ID of the objects
        let context = qbContext
        let objects = try! context.fetch(fetchRequest)
        for object in objects {
            context.delete(object) //deletes the objects in the fetch request
        }
        try! context.save()//save context is necessary to store the changes
    }
    
    func calculateAllSummaries() -> [Int]{
        var allSummaries: [Int] = [0,0,0]
        // For displaying purposing the only categories to choose from in the app are Food, Rent and Misc
        allSummaries[0] = calculateSummary(context: qbContext, filter: "Food")
        allSummaries[1] = calculateSummary(context: qbContext, filter: "Rent")
        allSummaries[2] = calculateSummary(context: qbContext, filter: "Misc")
        return allSummaries
    }
    
    // Calculates the summary in each category: "Food", "Rent", "Misc"
    func calculateSummary(context: NSManagedObjectContext, filter: String)-> Int {
        var summary = 0
        for transaction in allTransactions(context: qbContext, filter: filter) {
            summary += Int(transaction.amount)
        }
        return summary
    }
 
    // Creates a fetch request that finds a transaction with the matching ID
    func fetchTransactionByID (filter: Int32) -> [Transaction] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "transactionID == %@", "\(filter)")
        do {
            let transactions = try qbContext.fetch(fetchRequest)
            return transactions
         }
        catch {
           fatalError("Failed to fetch transaction: \(error)")
        }
    }
    
    // Creates a fetch request that finds a transaction with a matching name
    func fetchTransaction (filter: String) -> [Transaction] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", filter)
        do {
            let transactions = try qbContext.fetch(fetchRequest)
            return transactions
         }
        catch {
           fatalError("Failed to fetch transaction: \(error)")
        }
    }
    
    // In this case there will only be a single Summary with a matching category
    func fetchSummaries (filter: String) -> [Summary] {
        let fetchRequest: NSFetchRequest<Summary> = Summary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", filter)
        do {
            let summaries = try qbContext.fetch(fetchRequest)
            return summaries
         }
        catch {
           fatalError("Failed to fetch transaction: \(error)")
        }
    }
    
    //@referece: www.hackingwithswift.com/forums/swift/how-to-execute-core-data-nsfetchrequest-in-a-class-method/2345
    func allTransactions(context: NSManagedObjectContext, filter: String) -> [Transaction] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", filter)
        do {
            let transactions = try context.fetch(fetchRequest)
            return transactions
         }
        catch {
           fatalError("Failed to fetch transaction: \(error)")
        }
    }
    
    init() {
        initSummaries()
        initBudgetLimit()
    }
    
}
