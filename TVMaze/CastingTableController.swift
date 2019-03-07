import UIKit

class CastingTableController: UITableViewController{
    
    var serie: Serie!
    var casting = [Casting]()
    
    @IBOutlet var personName: UILabel!
    @IBOutlet var characterName: UILabel!
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let task = API.casting(id: serie.id) { (casting, error) in
            DispatchQueue.main.async {
                self.casting = casting ?? []
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return casting.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CastingCell", for: indexPath) as! CastingCell
        
        let casting = self.casting[indexPath.row]
        cell.set(casting)
        return cell
    }
}
