import UIKit

import MudoxKit

import RxSwift
import RxCocoa

class GitHubSearchViewController2: UIViewController {

  var disposeBag = DisposeBag()

  var tableView: UITableView!

  var searchBar: UISearchBar!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupSubviews()
    setupViewModel()
  }

  func setupSubviews() {
    tableView = UITableView(frame: view.bounds, style: .plain)
    with(tableView!) { tv in
      view.addSubview(tv)
      tv.register(UINib(nibName: "GitHubRepositoryCell", bundle: nil), forCellReuseIdentifier: "cell")
      // Dynamic row height
      tv.estimatedRowHeight = 120
      tv.rowHeight = UITableViewAutomaticDimension
    }

    navigationController?.navigationBar.prefersLargeTitles = false
    let searchController = UISearchController(searchResultsController: nil)
    with(searchController) { sc in
      sc.dimsBackgroundDuringPresentation = false
      navigationItem.searchController = sc
      navigationItem.hidesSearchBarWhenScrolling = false
      searchBar = sc.searchBar
    }
  }

  func setupViewModel() {
    let queryString = searchBar.rx.text.orEmpty.asDriver()

    let vm = GitHubSearchViewModel(queryString: queryString)

    vm.navigationTitle
      .drive(navigationItem.rx.title)
      .disposed(by: disposeBag)

    vm.repositories
      .drive(tableView.rx.items(cellIdentifier: "cell", cellType: GitHubRepositoryCell.self)) {
        row, repository, cell in
        cell.reload(repository)
      }
      .disposed(by: disposeBag)

    vm.networkActivity
      .drive(The.app.rx.isNetworkActivityIndicatorVisible)
      .disposed(by: disposeBag)

  }
}
