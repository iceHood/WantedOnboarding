
import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var loadButton: UIButton!
    
    var requestToggle: Bool = false
    var loadAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadButton.layer.cornerRadius = loadButton.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func loadTapped(_ sender: UIButton) {
        // Loading Images before loaded
        thumbnail.image = UIImage(systemName: Constants.sfSymbol) ?? UIImage()
        loadAction?()
    }
    

}

