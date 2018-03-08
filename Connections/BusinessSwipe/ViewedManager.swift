import Firebase

class ViewedManager {
    
    static let shared = ViewedManager()
    
    var uuids = [String]()
    
    private init() { }

    func configure(uuid: String) {
        let ref = Database.database().reference(withPath: "userViewed/\(uuid)")
        ref.observe(.value) { snapshot in
            for x in snapshot.children {
                let snap = x as! DataSnapshot
                self.uuids.append(snap.key)
                print("Viewed: \(snap.key)")
            }
        }
    }
    
}
