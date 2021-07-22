import Foundation
import CoreData


extension Summary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Summary> {
        return NSFetchRequest<Summary>(entityName: "Summary")
    }

    @NSManaged public var category: String?
    @NSManaged public var amount: Int32

    var wrappedCategory: String {
        category ?? "No Category"
    }
}

extension Summary : Identifiable {

}
