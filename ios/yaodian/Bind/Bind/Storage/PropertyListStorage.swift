
import UIKit

 final public class PropertyListStorage: NSObject {
    
     public var documentsPath: String {
         NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
     }
     
     public var cachesPath: String {
         NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
     }
     
     public var libraryPath: String {
         NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first ?? ""
     }
     
     private var _lock: pthread_rwlock_t = pthread_rwlock_t()
   
     public var path: String {
        switch directory {
        case .documentDirectory:
            return documentsPath
        case .cachesDirectory:
            return cachesPath
        case .libraryDirectory:
            return libraryPath
        default:
            return ""
        }
    }
    
    public var directory: FileManager.SearchPathDirectory = .documentDirectory
    
    private var fileManager: FileManager {
        return FileManager.default
    }
    
    public override init() {
        super.init()
        pthread_rwlock_init(&_lock, nil)
    }
    
    deinit {
        pthread_rwlock_destroy(&_lock)
    }
  
    func path(forKey key: String) -> String {
        path + "/" + key + ".plist"
    }
    
    public func withCriticalScope<T>(block: () -> T) -> T {
        pthread_rwlock_wrlock(&_lock)
        let value = block()
        pthread_rwlock_unlock(&_lock)
        return value
    }
}

extension PropertyListStorage {
    
    public subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        set {
            setObject(forKey: key, object: newValue as Any)
        }
    }
}

extension PropertyListStorage: Storageable {
    
    ///   只支持 NSDictionary 如果需要数组请参照 array(forKey:
    /// - Parameter key:
    /// - Returns:
    @objc public func object(forKey key: String) -> Any? {
        let path = path(forKey: key)
        if !fileManager.fileExists(atPath: path) {
            return [:]
        }
        return NSDictionary(contentsOfFile: path) as? [String: Any]
    }
    
    @objc public func array(forKey key: String) -> [Any]? {
        let path = path(forKey: key)
        if !fileManager.fileExists(atPath: path) {
            return []
        }
        return NSArray(contentsOfFile: path) as? [Any]
    }
    
    @objc public func setObject(forKey key: String, object: Any) {
        self.withCriticalScope { [weak self] in
            guard let self = self else { return }
            let path = self.path(forKey: key)
            if let array = object as? [Any] {
                NSArray(array: array).write(toFile: path, atomically: true)
            } else if let dictionary = object as? [String: Any] {
                NSDictionary(dictionary: dictionary).write(toFile: path, atomically: true)
            }
        }
    }
    
    @objc public func remove(forKey key: String) {
        self.withCriticalScope { [weak self] in
            guard let self = self else { return }
            if self.containsObject(forKey: key) {
                try? self.fileManager.removeItem(atPath: path(forKey: key))
            }
        }
    }
    
    @objc public func removeAll() {
        
    }
    
    @objc public func containsObject(forKey key: String) -> Bool {
        return self.withCriticalScope { [weak self] in
            guard let self = self else { return false}
            let path = path(forKey: key)
            return self.fileManager.fileExists(atPath: path)
        }
    }
 
}
