import UIKit

class TableController: UITableViewController{
    
    var episodes = [Episode]()
    var serie: Serie!
    
    @IBOutlet var episodeTitle: UILabel!
    @IBOutlet var id: UILabel!
    @IBOutlet var season: UILabel!
    @IBOutlet var number: UILabel!
    @IBOutlet var url: UILabel!
    @IBOutlet var airstamp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(serie.id)
        let task = API.episode(id: serie.id) { (episodes, error) in
            DispatchQueue.main.async {
                self.episodes = episodes ?? []
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
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath) as! EpisodeCell
        
        let episode = self.episodes[indexPath.row]
        cell.set(episode)
        return cell
    }
}
