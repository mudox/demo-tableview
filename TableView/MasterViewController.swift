import UIKit
import Eureka

import MudoxKit

import JacKit
fileprivate let jack = Jack.usingLocalFileScope().setLevel(.verbose)

class MasterViewController: FormViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Table View"
    
    mdx.setBackButtonTitleEmpty()

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
      It share the same underlying view model as Github Search #1
      """
    )

    <<< ButtonRow() {
      $0.title = "GitHub Search #2"
      $0.presentationMode = .show(GitHubSearchViewController2.init)
    }

    form +++ Section(footer: """
      Edting static single sectioned dateset.
      """
    )

    <<< ButtonRow() {
      $0.title = "⚠️ Editing Dataset #1"
      $0.presentationMode = .show(GitHubSearchViewController2.init)
    }

    form +++ Section(footer: """
      Edting static sectioned dateset.
      """
    )

    <<< ButtonRow() {
      $0.title = "⚠️ Editing Dataset #2"
      $0.presentationMode = .show(GitHubSearchViewController2.init)
    }
    
    form +++ Section(footer: """
      Talbe view cell expandable.
      """
      )
      
      <<< ButtonRow() {
        $0.title = "⚠️ Expandable cell"
        $0.presentationMode = .show(CellExpandableTableViewController.init)
    }
  }
}
