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
      Use Moya/RxSwift to model network service layer.
      MVVM + RxSwift.
      Self-sizing table view cell with Auto Layout.
      """
    )

    <<< ButtonRow() {
      $0.title = "GitHub Search #1"
      $0.presentationMode = .show(GitHubSearchViewController1.init)
    }

    form +++ Section(footer: """
      Use UISearchController to embed search bar into navigation bar (instead of as table header view).
      Self-sizing expandable cell, click to unveal repository description.
      """
    )

    <<< ButtonRow() {
      $0.title = "GitHub Search #2"
      $0.presentationMode = .show(GitHubSearchViewController2.init)
    }

    form +++ Section(footer: """
      Use cell to simulate section, click to expand the "section", unvealing the rows of the section.
      Use traditional MVC way (Not MVVM with RxSwift).
      """
      )
      
      <<< ButtonRow() {
        $0.title = "Expandable cells #1"
        $0.presentationMode = .show(ExpandableTableViewController.init)
    }
    
    form +++ Section(footer: """
      Use RxDataSources animated table view source to expand cell with animation.
      Use MVVM + RxSwift.
      """
      )
      
      <<< ButtonRow() {
        $0.title = "Expandable cells #2"
        $0.presentationMode = .show(ExpandableTableViewController.init)
    }

  }
}
