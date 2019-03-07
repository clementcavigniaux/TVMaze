import UIKit

class SerieCell: UICollectionViewCell{
    @IBOutlet var title: UILabel!
    @IBOutlet var image: UIImageView!
    
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
        
    }
}
