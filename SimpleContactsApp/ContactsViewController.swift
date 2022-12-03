import UIKit
import CoreData

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contactsArray: [NSManagedObject] = []
    let cellReuseIdentifier = "cell"
        
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addContactButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.backgroundImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshData()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addContact" {
                if let viewController = segue.destination as? AddContactsViewController {
                    viewController.ref = self
                    }
            }
    }
    
    func refreshData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        
        do {
           let temp = try managedContext.fetch(fetchRequest)
            contactsArray = temp.reversed()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addContactButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addContact", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactsArray.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell:ContactsCustomCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ContactsCustomCell
        let contact = contactsArray[indexPath.row]
        
        let firstName = contact.value(forKeyPath: "firstName") as! String
        let lastName = contact.value(forKeyPath: "lastName") as! String
        cell.nameLabel.text = firstName + " " + lastName
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }


}

