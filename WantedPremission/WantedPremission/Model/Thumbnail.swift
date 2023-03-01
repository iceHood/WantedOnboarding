import UIKit


struct Thumbnail {
    let url: String
    var image: UIImage = UIImage(systemName: Constants.sfSymbol) ?? UIImage()
}
