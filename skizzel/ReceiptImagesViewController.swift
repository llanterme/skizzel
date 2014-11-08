import UIKit

class ReceiptImagesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var receiptImages = [ReceiptImageModel]()
    var currentReceipt: ReceiptModel?
    
    var imageCache = [String : UIImage]()
    
    
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
        let imageCollection = self.receiptImages[indexPath.row]
        
        cell.layer.borderWidth=1.0;
        cell.layer.borderColor = UIColor.grayColor().CGColor
      //  cell.imageView?.image = UIImage(named: "placeholder.png");
        
        let urlString = imageCollection.imageURL as String
        var image = self.imageCache[urlString]
        
        if( image == nil ) {
            
            var imgURL: NSURL = NSURL(string: urlString)
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    self.imageCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let imageToUpdate = self.collectionView.cellForItemAtIndexPath(indexPath) {
                            cell.imageView?.image = image;
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let imageToUpdate = self.collectionView.cellForItemAtIndexPath(indexPath) {
                    cell.imageView?.image = image;
                }
            })
        }
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
        
    {
        
        if (segue.identifier == "receiptImageDetail") {
            
            let indexPaths: NSArray = self.collectionView.indexPathsForSelectedItems() as NSArray
            let indexPath : NSIndexPath = indexPaths[0] as NSIndexPath
            var selectedList = self.receiptImages[indexPath.row];
            
            let receiptDesController = segue.destinationViewController as ReceiptImageDetailViewController
            receiptDesController.currentImage = selectedList;
        }
        
    }
    
    
    
    @IBAction func uploadImageAction(sender: AnyObject) {
        
        var uploadImageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("uploadImage") as UploadImagesViewController
        uploadImageViewController.currentReceiptId = currentReceipt?.receiptId
        println(currentReceipt?.receiptId)
        
        self.presentViewController(uploadImageViewController, animated: true, completion: uploadControllerDismissed)
        
    }
    
    func uploadControllerDismissed() {
        
    }
    
    
    
    
    
    
    
    
}
