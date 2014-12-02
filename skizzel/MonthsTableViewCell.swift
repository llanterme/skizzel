
import UIKit

class MonthsTableViewCell: UITableViewCell {

    @IBOutlet weak var receiptMonth: UILabel!

    @IBOutlet weak var receiptBlockImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    override func layoutSubviews() {
        receiptBlockImage.layer.cornerRadius = 10.0
        receiptBlockImage.clipsToBounds = true
    }

}
