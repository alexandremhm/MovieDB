import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var stackDescription: UIStackView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textViewLabel: UILabel!
    @IBOutlet weak var movietableView: UITableView!
    @IBOutlet weak var showMoreBtn: UIButton!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var photoViewCollection: UICollectionView!
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Backdrop>!
    var movieDetail: Movie?
    var movieViewModel = MovieViewModel()
    var movieService = MovieService()
    var crews: [Crew]?
    var photos: [MoviePhotos]?
    var isExpanded: Bool = false
    var genres: [Int:String]?
    var movieExtraInfos: MovieDetails?
    var credits: Credits?
    var movieImages: MoviePosters?
    
    override func viewWillAppear(_ animated: Bool) {
        guard let movieDetail = movieDetail else {
            return
        }
        
        movieService.getMovieImagesBy(id: movieDetail.id) { images in
            DispatchQueue.main.sync {
                self.movieImages = images
                self.configureDataSource()
                self.photoViewCollection.reloadData()
            }
        }
        
        movieService.getMovieCreditsBy(id: movieDetail.id) { credit in
            DispatchQueue.main.sync {
                self.credits = credit
                self.movietableView.reloadData()
            }
        }
        
        movieService.getMovieGenres { genres in
            DispatchQueue.main.sync {
                let genresTuple = genres.genres.map { genre in
                    (genre.id, genre.name)
                }
                self.genres = genresTuple.reduce(into: [:]) { $0[$1.0] = $1.1 }
                self.setupData()
            }
        }
        
        movieService.getMovieDetailsBy(id: movieDetail.id) { movie in
            DispatchQueue.main.sync {
                self.movieExtraInfos = movie
                self.setupData()
            }
        }
        
        createSpinnerView()
    }

        
    override func viewDidLoad() {
        super.viewDidLoad()

        showMoreBtn.setTitle("Show more", for: .normal)
        textViewLabel.numberOfLines = 4
        
        movietableView.dataSource = self
                
        setupHeightTextSynopsis()
        configureDataSource()
    }
    
    func waitForDataStoreReady(movieId: Int) async throws {
        let lock = NSLock()
        
        return try await withCheckedThrowingContinuation { continuation in
            
            var nillableContinuation: CheckedContinuation<Void, Error>? = continuation
            
            movieService.getMovieImagesBy(id: movieId) { result in
                lock.lock()
                defer { lock.unlock() }
                
                nillableContinuation?.resume()
                self.movieImages = result
                nillableContinuation = nil
                
            }
        }
    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    private func configureHourMinutes(runtime: Int?) -> String {
           guard let runtime = runtime else { return "" }
           let hour = runtime / 60
           let minutes = runtime % 60

           return "\(hour)hr \(minutes)m"
       }
    
    func setupData() {
        guard let movieDetail = movieDetail else {
            return
        }
        
        movieTitleLabel.text = movieDetail.title
        rateLabel.text = movieDetail.voteAverage.description
        textViewLabel.text = movieDetail.overview
        genresLabel.text = "\(movieDetail.genres.map { genres?[$0] ?? "" }.joined(separator: ", ") )"
        durationLabel.text = configureHourMinutes(runtime: movieExtraInfos?.runtime ?? 0)
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movieDetail.backdropPath ?? "")") {
            bannerImageView.load(url: url, placeholder: UIImage(named: "movie"))
        }
    }
    
    @IBAction func presentPhotoViewController(_ sender: Any) {
        if let listPhotoViewController = storyboard?.instantiateViewController(withIdentifier: "MoviePhotoViewController") as? MoviePhotoViewController {
            listPhotoViewController.movieId = movieDetail?.id
            listPhotoViewController.modalPresentationStyle = .fullScreen
            present(listPhotoViewController, animated: true)
        }
    }
    
    @IBAction func presentCrewDetailViewController(_ sender: Any) {
        if let listPhotoViewController = storyboard?.instantiateViewController(withIdentifier: "CrewDetailViewController") as? CrewDetailViewController {
            listPhotoViewController.movieId = movieDetail?.id
            listPhotoViewController.modalPresentationStyle = .fullScreen
            present(listPhotoViewController, animated: true)
        }
    }
    
    
    @IBAction func toogleShow(_ sender: Any) {
        if (isExpanded == false) {
            textViewLabel.numberOfLines = 0
            isExpanded = true
            showMoreBtn.setTitle("Show less", for: .normal)
        }
        else {
            textViewLabel.numberOfLines = 4
            isExpanded = false
            showMoreBtn.setTitle("Show more", for: .normal)
        }
    }
    
    private func setupHeightTextSynopsis() {
        guard let credits = credits else {
            return
        }
        let numberOfCrew = credits.crew.count
            let height = min(4 * 81, numberOfCrew * 81)

            movietableView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        }
    
}

extension MovieDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let credits = credits else { return Swift.Int() }
        return credits.crew.count < 4 ? credits.crew.count : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = movietableView.dequeueReusableCell(withIdentifier: MovieDetailsTableViewCell.reuseIdentifier) as? MovieDetailsTableViewCell else { return UITableViewCell() }
        
        guard let credits = credits else { fatalError() }
            
        cell.detailsActorNameLabel.text = credits.cast[indexPath.row].name
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(credits.cast[indexPath.row].profilePath ?? "")") {
            cell.detailsActorImageView.load(url: url, placeholder: UIImage(named: "movie"))
        }
        cell.detailsCaracterLabel.text = credits.cast[indexPath.row].character
        return cell
    }
}

extension MovieDetailsViewController {
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.30), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(72.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Backdrop>(collectionView: self.photoViewCollection) {
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
