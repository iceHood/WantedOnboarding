import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loadingTable: UITableView!
    
    @IBOutlet weak var loadAllButton: UIButton!
    
    var thumbnailManager = ThumbnailManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        
        // Set loadAllButton UI
        loadAllButton.layer.cornerRadius = loadAllButton.frame.height / 5
        
        // Set loadingTable
        loadingTable.dataSource = self
        loadingTable.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        // Set thumbnailManager
        thumbnailManager.setTestCases()
        thumbnailManager.delegate = self
    }

    @IBAction func loadAllTapped(_ sender: UIButton) {
        for i in 0..<thumbnailManager.thumbnailCounts {
            thumbnailManager.thumbnails[i].image = UIImage(systemName: Constants.sfSymbol) ?? UIImage()
        }
        loadingTable.reloadData()
        for i in 0..<thumbnailManager.thumbnailCounts {
            thumbnailManager.requestThumbnailImage(rowAt: i)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thumbnailManager.thumbnailCounts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        cell.thumbnail.image = thumbnailManager.thumbnails[indexPath.row].image
        // 함수 자체를 넘긴다는 아이디어에 대해 더 생각해 보아야 할듯.
        cell.loadAction = { [weak self] in
            self?.thumbnailManager.requestThumbnailImage(rowAt: indexPath.row)
        }
        
        return cell
    }
}


extension ViewController: ThumbnailManagerDelegate {
    func didUpdateThumbnailImage(_ thumbnailManager: ThumbnailManager, rowAt: Int, thumbnailImage: UIImage) {
        
        DispatchQueue.main.async { [weak self] in
            self?.thumbnailManager.thumbnails[rowAt].image = thumbnailImage
            self?.loadingTable.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
