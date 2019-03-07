import UIKit

class SerieDetails: UIViewController{
    @IBOutlet var serieTitle: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var status: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var serieDescription: UILabel!
    @IBOutlet var channel: UILabel!
    
    var serie: Serie!
    
    func set(_ serie: Serie){
        
        self.serie = serie
        
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
}
