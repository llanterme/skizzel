
import UIKit

class ReceiptImageDetailViewController: UIViewController {


    var currentImage: ReceiptImageModel?

    
    @IBOutlet weak var imageDetails: UIImageView!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        var url = NSURL(string:currentImage!.imageURL)
        var err: NSError?
        
        var imageData : NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
        var bgImage = UIImage(data:imageData)
        
        
        imageDetails.image = UIImage(data:imageData)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    
    

    
}
