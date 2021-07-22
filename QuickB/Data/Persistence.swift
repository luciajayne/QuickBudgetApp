import Foundation
import CoreData

/**
 *@Reference: www.youtube.com/watch?v=091Mdv_Rjb4
 *Using PersistenceContainer consolidates the creation of NSManagedObject,
 *NSPersistanceStoreCoordinator, and NSManagedOBjectContext
 */
struct PersistenceController{
    //@Pattern: Singleton because the application only needs one context
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer (name: "TransactionDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error)")
            } // if this success a coreData stack is ready to be used
        }
    }
}
