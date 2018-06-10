import UIKit

import MudoxKit

import RxSwift
import RxCocoa

class GitHubSearchViewController2: UIViewController {

  var disposeBag = DisposeBag()

  var tableView: UITableView!

  var searchBar: UISearchBar!
  
  var viewModel: ViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupSubviews()
    setupViewModel()
  }

  func setupSubviews() {
    
    tableView = UITableView(frame: view.bounds, style: .plain)
    with(tableView!) { tv in
      view.addSubview(tv)
      tv.register(UINib(nibName: "GitHubRepositoryCell2", bundle: nil), forCellReuseIdentifier: "cell")
      
      // Dynamic row height
      tv.estimatedRowHeight = 120
      tv.rowHeight = UITableViewAutomaticDimension
    }

    let searchController = UISearchController(searchResultsController: nil)
    with(searchController) { sc in
      sc.dimsBackgroundDuringPresentation = false
      sc.hidesNavigationBarDuringPresentation = false
      searchBar = sc.searchBar
    }
    
    // embed search bar into navigation bar
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    
    with(searchBar) { bar in
      bar.textContentType = .name
      bar.autocapitalizationType = .none
      bar.autocorrectionType = .no
      bar.spellCheckingType = .no
    }
  }

  func setupViewModel() {
    let queryString = searchBar.rx.text.orEmpty.asDriver()

    viewModel = ViewModel(
      input: (
        queryString: queryString,
        selectedIndexPath: tableView.rx.itemSelected.asDriver()
      )
    )
    
    viewModel.title
      .drive(navigationItem.rx.title)
      .disposed(by: disposeBag)

    viewModel.items
      .drive(tableView.rx.items(cellIdentifier: "cell", cellType: GitHubRepositoryCell2.self)) {
        row, item, cell in
        cell.show(item)
      }
      .disposed(by: disposeBag)

  }
}
