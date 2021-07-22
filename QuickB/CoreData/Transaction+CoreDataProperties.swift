import Foundation
import CoreData


extension Transaction { // The Transaction class for the Class entity was generated by XCode

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Int32
    @NSManaged public var category: String?
    @NSManaged public var date: String?
    @NSManaged public var name: String?
    @NSManaged public var transactionID: Int32
    
    var wrappedName: String {
        name ?? "No Name"
    }
    
    var wrappedDate: String {
        date ?? "No Date"
    }
    
    var wrappedCategory: String {
        category ?? "No Category"
    }
}

extension Transaction : Identifiable {

}
