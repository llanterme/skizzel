
import UIKit

class MillageDetailsCell: UITableViewCell {
    

    @IBOutlet weak var millageDate: UILabel!
    @IBOutlet weak var millageAlias: UILabel!
    @IBOutlet weak var millageCategory: UILabel!
    @IBOutlet weak var millageBlockImage: UIImageView!
    @IBOutlet weak var millageTotal: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        millageBlockImage.layer.cornerRadius = 10.0
        millageBlockImage.clipsToBounds = true
        
    }

}
