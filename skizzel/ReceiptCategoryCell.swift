import UIkit

class ReceiptCategoryCell: UITableViewCell {
    
    @IBOutlet weak var receiptCategory: UILabel!
    @IBOutlet weak var blockImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    override func layoutSubviews() {
        blockImage.layer.cornerRadius = 10.0
        blockImage.clipsToBounds = true
    }

}
