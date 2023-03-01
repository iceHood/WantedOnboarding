import UIKit

protocol ThumbnailManagerDelegate {
    func didUpdateThumbnailImage(_ thumbnailManager: ThumbnailManager, rowAt: Int, thumbnailImage: UIImage)
    func didFailWithError(error: Error)
}

struct ThumbnailManager {
    
    static let main: ThumbnailManager = ThumbnailManager()
    
    var thumbnails: [Thumbnail] = []
    
    var thumbnailCounts: Int {
        thumbnails.count
    }
    
    var delegate: ThumbnailManagerDelegate?
    
    func requestThumbnailImage(rowAt idx: Int) {
        guard let url = URL(string: thumbnails[idx].url) else {return}
        
        URLSession(configuration: .default).dataTask(with: url) { data, response, error in
            
            if let e = error {
                delegate?.didFailWithError(error: e)
                return
            }
            
            if let safeData = data {
                guard let thumbnail = UIImage(data: safeData) else {
                    print("Error has been occured generating tumbnail")
                    return
                }
                DispatchQueue.main.async {
                    // 여러 스레드에서 접근하려고 하면 터짐
                    delegate?.didUpdateThumbnailImage(self, rowAt: idx, thumbnailImage: thumbnail)
                }
            }
        }.resume()
    }
    
    mutating func setTestCases() {
        thumbnails = [
            Thumbnail(url: "https://cdn.pixabay.com/photo/2017/08/30/01/05/milky-way-2695569_1280.jpg"),
            Thumbnail(url: "https://cdn.pixabay.com/photo/2016/02/13/12/26/aurora-1197753_1280.jpg"),
            Thumbnail(url: "https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_1280.jpg"),
            Thumbnail(url: "https://cdn.pixabay.com/photo/2014/04/13/20/49/cat-323262_1280.jpg"),
            Thumbnail(url: "https://cdn.pixabay.com/photo/2016/11/23/13/48/beach-1852945_1280.jpg"),
        ]
    }
}

