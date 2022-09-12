import UIKit

class MovieListViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var arrayMovies: [Movie]?
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    var movie: Movie?
    
    var upcomingMovies: [Movie]?
    var nowPlayingMovies: [Movie]?
    var genreDict: [Int: String]?
    
    var movieService = MovieService()
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var movieSegmentControll: UISegmentedControl!
    
    @IBOutlet weak var searchTextView: UITextField! {
        didSet {
            let placeholderText = NSAttributedString(
                string: "CI&T Movie DB",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ])
            searchTextView.attributedPlaceholder = placeholderText
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        movieService.getMovieGenres { genres in
            DispatchQueue.main.sync {
                let genresTuple = genres.genres.map { genre in
                    (genre.id, genre.name)
                }
                self.genreDict = genresTuple.reduce(into: [:]) { $0[$1.0] = $1.1 }
            }
        }
        
        createSpinnerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        movieService.delegate = self
        
        movieService.fetchMovies(moviePath: "now_playing")
        movieService.fetchMovies(moviePath: "upcoming")
        
        movieCollectionView.delegate = self
        
        movieSegmentControll.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        movieCollectionView.collectionViewLayout = configureLayout()
        movieListToggle(movieSegmentControll!)
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueListViewController = segue.destination as? MovieDetailsViewController {
            segueListViewController.movieDetail = sender as? Movie
        }
    }
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(340.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: self.movieCollectionView) {
            (collectionView, indexPath, Movie) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieCollectionViewCell else {
                fatalError("Cannot create new cell")
            }
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(Movie.posterPath ?? "")") {
                cell.movieImageView.load(url: url, placeholder: UIImage(named: "movie"))
            }
            
            cell.movieTitleLabel.text = Movie.title
            cell.movieDescriptionLabel.text = "\(self.genreDict?[Movie.genres[0]] ?? "") • \(Movie.releaseDate) | \(Movie.voteAverage)"
            
            return cell
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        initialSnapshot.appendSections([.main])
        
        initialSnapshot.appendItems(arrayMovies ?? [])
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    @IBAction func movieListToggle(_ sender: Any) {
        switch movieSegmentControll.selectedSegmentIndex {
        case 0:
            self.arrayMovies = nowPlayingMovies
            configureDataSource()
            movieCollectionView.reloadData()
        case 1:
            self.arrayMovies = upcomingMovies
            configureDataSource()
            movieCollectionView.reloadData()
        default:
            break
        }
    }
}

extension MovieListViewController: MoviesManagerDelegate {
  
    func setUpcomingMovies(movies: [Movie]) {
        DispatchQueue.main.async {
            self.upcomingMovies = movies
            self.configureDataSource()
            self.movieCollectionView.reloadData()
        }
    }
    
    func setNowPlayingMovies(movies: [Movie]) {
        DispatchQueue.main.async {
            self.arrayMovies =  movies
            self.nowPlayingMovies = movies
            self.configureDataSource()
            self.movieCollectionView.reloadData()
        }
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch movieSegmentControll.selectedSegmentIndex {
        case 0:
            movie = arrayMovies?[indexPath.item]
            performSegue(withIdentifier: "movieDetailsSegue", sender: movie)
            
        case 1:            
            movie = arrayMovies?[indexPath.item]
            performSegue(withIdentifier: "movieDetailsSegue", sender: movie)
        default:
            break
        }
    }
}

