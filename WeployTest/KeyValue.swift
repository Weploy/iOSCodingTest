import RealmSwift
import SwiftyJSON

public class KeyValue: Object {
    static let realm = try! Realm()
    
    @objc dynamic var key = ""
    @objc dynamic var value = ""
    
    private static func row(key: String) -> KeyValue? {
        return realm.objects(KeyValue.self).filter("key = %@", key).first
    }
    
    public static func put(_ key: String, _ obj: JSON) {
        if let str = obj.rawString() {
            try! realm.write {
                if let row = row(key: key) {
                    row.value = str
                }
                else {
                    let row = KeyValue()
                    row.key = key
                    row.value = str
                    realm.add(row)
                }
            }
        }
    }
    
    public static func get(_ key: String) -> JSON {
        if let row = row(key: key) {
            return JSON(parseJSON: row.value)
        }
        return JSON(NSNull())
    }
    
    public static func remove(_ key: String) {
        try! realm.write {
            if let row = row(key: key) {
                realm.delete(row)
            }
        }
    }
}

