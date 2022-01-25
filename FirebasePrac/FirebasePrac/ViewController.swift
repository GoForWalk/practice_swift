//
//  ViewController.swift
//  FirebasePrac
//
//  Created by sae hun chung on 2022/01/25.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    @IBOutlet weak var dataInputField: UITextField!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var numOfCustomers: UILabel!
    
    // database connection
    let db = Database.database(url: "https://fir-prac-91fb9-default-rtdb.asia-southeast1.firebasedatabase.app").reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
//        saveBasicTypes()
//        saveCustomers()
        fetchCustomers()
    } // end viewDidLoad()
    
    func updateLabel() {
        db.child("firstData").observeSingleEvent(of: .value) { snapshot in
            print("---> snapshot:\(snapshot)")
            
            // snapshot을 원하는 형식으로 downcasting
            let value = snapshot.value as? String ?? ""
            
            DispatchQueue.main.async {
                self.dataLabel.text = value
            }
        }
    } // end updateLabel()
}// end class ViewController

// MARK: Save Data
extension ViewController {
    func saveBasicTypes() {
        // Firebase child ("key").setValue(Value)
        // - String, number, dictionary, array
        db.child("int").setValue(3)
        db.child("double").setValue(3.5)
        db.child("str").setValue("String value - 여러분 안녕")
        db.child("array").setValue(["a", "b", "c"])
        db.child("dict").setValue(["id": "anyID", "age": 10, "city" : "seoul"])
    }
    
    func saveCustomers() {
        // 책가게
        // 사용자 저장
        // 모델 Customer + Book
        
        let books = [
            Book(title: "Good to Great", author: "Someone"),
            Book(title: "Hacking Growth", author: "Somebody")
        ]
        
        let customer1 = Customer(id: "\(Customer.id)", name: "SampleBody", books: books)
        Customer.id += 1
        let customer2 = Customer(id: "\(Customer.id)", name: "Son", books: books)
        Customer.id += 1
        let customer3 = Customer(id: "\(Customer.id)", name: "kane", books: books)
        Customer.id += 1
        
        db.child("customers").child(customer1.id).setValue(customer1.toDictionary)
        db.child("customers").child(customer2.id).setValue(customer2.toDictionary)
        db.child("customers").child(customer3.id).setValue(customer3.toDictionary)
    }
} // end extention ViewController

// MARK: Read(Fetch) Data
extension ViewController {
    func fetchCustomers() {
        db.child("customers").observeSingleEvent(of: .value) { snapshot in
            print("--> \(snapshot.value!)")
            
            do {
                // NSArray -> Data(JSON) -> Codable
                let data = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let decoder = JSONDecoder()
                let customers: [Customer] = try decoder.decode([Customer].self, from: data)
                DispatchQueue.main.async {
                    self.numOfCustomers.text = "# Of Customers: \(customers.count)"
                }
                print("---> customers: \(customers.count)")
                
            } catch let error {
                print("---> Error: \(error)")
            }
        }
    } // end func fetchCustomers

} // end extension ViewController

struct Customer: Codable {
    let id: String
    let name: String
    let books: [Book]
    
    var toDictionary: [String: Any] {
        let booksArray = books.map { $0.toDictionary }
        let dict: [String: Any] = [
            "id" : id,
            "name" : name,
            "books" : booksArray
        ]
        return dict
    }
    
    static var id: Int = 0
} // end struct Customer

struct Book: Codable {
    let title: String
    let author: String
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = [
            "title" : title,
            "author" : author
        ]
        return dict
    }
} // end struct Book
