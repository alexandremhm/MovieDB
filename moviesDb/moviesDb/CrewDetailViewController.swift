import UIKit

class CrewDetailViewController: UIViewController {
    
    @IBOutlet weak var crewTableView: UITableView!
    
    var crewDetail: [Crew]?
    var credits: Credits?
    var movieId: Int?
    var movieService = MovieService()
    
    override func viewWillAppear(_ animated: Bool) {
        crewTableView.dataSource = self

        guard let movieId = movieId else {
            return
        }

        movieService.getMovieCreditsBy(id: movieId) { credits in
            DispatchQueue.main.sync {
                self.credits = credits
                self.crewTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func comeBackDetailsViewController(_ sender: Any) {
        dismiss(animated: true)
    }

}

extension CrewDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let credits = credits else { return 0 }
        
        let section = self.numberOfSections(in: crewTableView)
               
        if section == 0 {
            return credits.cast.count
        } else {
            return credits.crew.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = crewTableView.dequeueReusableCell(withIdentifier: MovieDetailsTableViewCell.reuseIdentifier) as? MovieDetailsTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            cell.detailsActorNameLabel.text = credits?.cast[indexPath.row].name ?? ""
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(credits?.cast[indexPath.row].profilePath ?? "")") {
                cell.detailsActorImageView.load(url: url, placeholder: UIImage(named: "movie"))
            }
            cell.detailsCaracterLabel.text = credits?.cast[indexPath.item].character
            
            return cell
        } else {
            cell.detailsActorNameLabel.text = credits?.crew[indexPath.row].name ?? ""
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(credits?.crew[indexPath.row].profilePath ?? "")") {
                cell.detailsActorImageView.load(url: url, placeholder: UIImage(named: "movie"))
            }
            cell.detailsCaracterLabel.text = credits?.crew[indexPath.item].job
            
            return cell
        }
        
    }
}
