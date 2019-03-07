import UIKit

class ViewController: UICollectionViewController, UISearchBarDelegate {
    var series = [Serie]()
    var searchedSeries = [Serie]()
    var searching = false

    //@IBOutlet weak var searchBar: UISearchBar!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let task = API.topSeries{ (series, error) in
            DispatchQueue.main.async {
                self.series = series
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SerieController,
            let cell = sender as? SerieCell{
            destinationVC.serie = cell.serie
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searching {
            return searchedSeries.count
        } else {
            return series.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SerieCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SerieCell

        if searching {
            let searchedSerie = self.searchedSeries[indexPath.row]
            cell.set(searchedSerie)
        } else {
            let serie = self.series[indexPath.row]
            cell.set(serie)
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText.lowercased())
        searchedSeries = self.series.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        self.collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.collectionView.reloadData()
    }
}

