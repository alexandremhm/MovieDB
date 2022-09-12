import Foundation
import UIKit

class MoviePhotoViewController:  UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Backdrop>!
    var movieId: Int?
    var movieImages: MoviePosters?
    var movieService = MovieService()
    
    @IBOutlet var photoCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        guard let movieId = movieId else {
            return
        }

        movieService.getMovieImagesBy(id: movieId) { images in
            DispatchQueue.main.sync {
                self.movieImages = images
                self.configureDataSource()
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func comeBackDetailsController(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension MoviePhotoViewController {
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Backdrop>(collectionView: self.photoCollectionView) {
            (collectionView, indexPath, MoviePhotos) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotosCollectionViewCell else {
                fatalError("Cannot create new cell")
            }
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(MoviePhotos.filePath)") {
                cell.photosImageView.load(url: url, placeholder: UIImage(named: "movie"))
            }
            
            return cell
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Backdrop>()
        initialSnapshot.appendSections([.main])
        
        if let photos = movieImages?.backdrops {
           initialSnapshot.appendItems(photos)
        }
        
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
}
