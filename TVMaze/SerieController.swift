import UIKit

class SerieController: UIViewController{
    //@IBOutlet weak var titleLabel: UILabel!
    
    var serie: Serie!
    
    
    @IBOutlet var serieTitle: UILabel!
    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var image: UIImageView!
    @IBOutlet var status: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var serieDescription: UILabel!
    @IBOutlet var channel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageUrl:URL = URL(string: serie.image.original)!
        
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
            
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let imageMC = UIImage(data: imageData as Data)
                self.image.image = imageMC
            }
        }
        
        
        var categories = ""
        for category in serie.genres {
            categories += category + " "
        }
        
        serieTitle.text = serie.name
        status.text = serie.status
        category.text = categories
        serieDescription.text = serie.summary
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TableController{
            
            destinationVC.serie = self.serie
        }
        
        if let destinationVC = segue.destination as? CastingTableController{
            print(self.serie)
            destinationVC.serie = self.serie
        }
    }
    
}
