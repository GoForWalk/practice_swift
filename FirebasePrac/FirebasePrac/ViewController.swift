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
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    // database connection
    let db = Database.database(url: "https://fir-prac-91fb9-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    
    // update 할때 활용
    // Read 후 memory에 data 저장

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
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
    
    @IBAction func createCustomer(_ sender: Any) {
        saveCustomers()
    }
    
    @IBAction func fetchCustomer(_ sender: Any) {
        displayFetchData()
    }
    
    @IBAction func updateCustomer(_ sender: Any) {
        updateCustomers()
    }
    
    @IBAction func deleteCustomer(_ sender: Any) {
        deleteCustomers()
    }
    
    
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
    func fetchCustomers(customersData: @escaping ([Customer]) -> Void) {
        
        db.child("customers").observeSingleEvent(of: .value) { snapshot in
            guard snapshot.hasChildren() else {
                print("---> Error : Customers Data가 존재 하지 않습니다.")
                return }
            print("--> \(snapshot.value!)")
            
            do {
                // NSArray -> Data(JSON) -> Codable
                let data = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
                let decoder = JSONDecoder()
                let customers: [Customer] = try decoder.decode([Customer].self, from: data)
                customersData(customers)
                
                print("---> customers: \(customers.count)")
                
            } catch let error {
                print("---> Error: \(error)")
            }
        }
        
    } // end func fetchCustomers
    
    func displayFetchData() {
        fetchCustomers { dic in
            print("---> dic : \(dic)")
            self.numOfCustomers.text = "# Of Customers: \(dic.count)"
        }
        
//        let dic: [Customer] = fetchCustomers(dataStoreCustomer: customersDic)
//        print("---> dic : \(dic)")
//        self.numOfCustomers.text = "# Of Customers: \(dic.count)"

    } // end func displayLabel()

} // end extension ViewController

// MARK: Update, Delete
extension ViewController {
    func updateBasicTypes() {
        //        db.child("int").setValue(3){{{
        //        db.child("double").setValue(3.5)
        //        db.child("str").setValue("Stri}}}ng value - 여러분 안녕")
        
        db.updateChildValues(["int": 6])
        db.updateChildValues(["double": 6.6])
        db.updateChildValues(["str": "It is updateed Str"])
    } // end updateBasicTypes()
    
    func updateCustomers() {
        
        fetchCustomers { dic in
            guard dic.isEmpty == false else { return }
            
            var customersArray: [Customer] = dic
            customersArray[0].name = "Min"
            
            let dictionary = customersArray.map { $0.toDictionary }
            self.db.updateChildValues(["customers": dictionary])
        }
        
//        var dic: [Customer] = fetchCustomers(dataStoreCustomer: customersDic)
//        guard dic.isEmpty == false else { return }
//        dic[0].name = "Min"
//
//        let dictionary = dic.map { $0.toDictionary }
//        db.updateChildValues(["customers": dictionary])
//        customers = [] // customer 초기화
//        dic = []
//        db.child("customers").child("\(customers[1].id)").updateChildValues(["name" : "newName"])
    } // end updateCustomers()
    
    func deleteBasicTypes() {
        db.child("int").removeValue()
        db.child("double").removeValue()
        db.child("str").removeValue()
    } // end deleteBasicTypes()
    
    func deleteCustomers() {
        db.child("customers").removeValue()
    } // end deleteCustomers()
}

struct Customer: Codable {
    let id: String
    var name: String
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
