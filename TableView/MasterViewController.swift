import UIKit
import Eureka
import MudoxKit

class MasterViewController: FormViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    form +++ Section(footer: """
      User inputs in search bar trigger GitHub search requests.
      Show search bar in the table view.
      """
    )

    <<< ButtonRow() {
      $0.title = "GitHub Search #1"
      $0.presentationMode = .show(GitHubSearchViewController1.init)
    }

    form +++ Section(footer: """
      User inputs in search bar trigger GitHub search requests.
      Show search bar in navigation bar.
      """
    )

    <<< ButtonRow() {
      $0.title = "GitHub Search #2"
      $0.presentationMode = .show(GitHubSearchViewController2.init)
    }


  }
}
