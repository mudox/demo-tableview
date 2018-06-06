import UIKit

import MudoxKit

class GitHubRepositoryCell: UITableViewCell {
  
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var starsLabel: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    with(starsLabel) { lb in
      // round corner
      lb.layer.cornerRadius = 3
      lb.layer.masksToBounds = true

      // color
      lb.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
      lb.textColor = .white
      
      // font
      lb.font = UIFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
    }
  }

  func reload(_ repo: GitHub.Repository) {
    nameLabel.text = repo.name
    starsLabel.text = " \(repo.stars) "
    descriptionLabel.text = repo.description
  }

}
