import UIKit

class ReceiptImagesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var receiptImages = [ReceiptImageModel]()
    var currentReceipt: ReceiptModel?
    
    
    override func viewDidLoad() {
        
        if (currentReceipt?.receiptImages.count > 0) {
            
            receiptImages = ReceiptImageModel.getReceiptImages(currentReceipt?.receiptImages as NSMutableArray);
            
        }
        
        self.title = currentReceipt?.alias;
        
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receiptImages.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as ReceiptImagesCollectionViewCell
        
        cell.layer.borderWidth=1.0;
        cell.layer.borderColor = UIColor.grayColor().CGColor
        
        let image = self.receiptImages[indexPath.row]
        let currentImage = UIImage(data: NSData(contentsOfURL: NSURL(string: image.imageURL)))
        cell.imageView?.image = currentImage;
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
        
    {
        if (segue.identifier == "receiptImageDetail") {

            let indexPaths: NSArray = self.collectionView.indexPathsForSelectedItems() as NSArray
            let indexPath : NSIndexPath = indexPaths[0] as NSIndexPath
            println(indexPath.row);
            
            let receiptDesController = segue.destinationViewController as ReceiptImageDetailViewController

            var selectedList = self.receiptImages[indexPath.row];
            receiptDesController.currentImage = selectedList;


        }
    }
    
    
    
    
    
}
