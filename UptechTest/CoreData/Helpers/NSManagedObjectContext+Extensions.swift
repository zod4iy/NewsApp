// https://github.com/objcio/core-data

import CoreData

extension NSManagedObjectContext {
    
    public func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
    
    public func insertObject<A: Codable>(_ data: Data) -> A? where A: Managed {
        let obj = try? JSONDecoder(self).decode(A.self, from: data)
        return obj
    }
    
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    public func performSaveOrRollback() {
        perform {
            _ = self.saveOrRollback()
        }
    }
    
    public func performSaveOrRollback(completion: (() -> Void)?) {
        perform {
            _ = self.saveOrRollback()
            completion?()
        }
    }
    
    public func performChanges(block: @escaping () -> ()) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}
