import UIKit

import MudoxKit

import RxSwift
import RxCocoa

import DZNEmptyDataSet

import SwiftRichString

class GitHubSearchViewController1: UIViewController {

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

    // tap to resign keyboard
    let tapBackground = UITapGestureRecognizer()
    tapBackground.rx.event
      .subscribe(onNext: { [weak self] _ in
        self?.view.endEditing(true)
      })
      .disposed(by: disposeBag)
    view.addGestureRecognizer(tapBackground)

    // table view
    tableView = UITableView(frame: view.bounds, style: .plain)
    with(tableView!) { tv in
      view.addSubview(tv)

      tv.register(UINib(nibName: "GitHubRepositoryCell1", bundle: nil), forCellReuseIdentifier: "cell")

      tv.mdx.hideSeparatorsForEmptyDataset()

      tv.emptyDataSetSource = self
      tv.emptyDataSetDelegate = self

      // Dynamic row height
      tv.estimatedRowHeight = 120
      tv.rowHeight = UITableViewAutomaticDimension
    }

    searchBar = UISearchBar()
    with(searchBar!) { bar in
      bar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 56)
      bar.searchBarStyle = .minimal
      tableView.tableHeaderView = bar
    }
    with(searchBar) { bar in
      bar.textContentType = .name
      bar.autocapitalizationType = .none
      bar.autocorrectionType = .no
      bar.spellCheckingType = .no
    }
  }

  func setupViewModel() {
    let queryString = searchBar.rx.text.orEmpty.asDriver()

    viewModel = ViewModel(queryString: queryString)

    viewModel.title
      .drive(navigationItem.rx.title)
      .disposed(by: disposeBag)

    viewModel.repositories
      .drive(tableView.rx.items(cellIdentifier: "cell", cellType: GitHubRepositoryCell1.self)) {
        row, repo, cell in
        cell.show(repo)
      }
      .disposed(by: disposeBag)

  }

}

extension GitHubSearchViewController1: DZNEmptyDataSetSource {
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    switch viewModel.emptyDatasetReason.value {
    case .noInput:
      return "No Input".set(style: Style.title)
    case .querying:
      return nil
    case .noMatch:
      return "Oops!".set(style: Style.title)
    case .error:
      return "Oops!".set(style: Style.error)
    }

  }

  func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    switch viewModel.emptyDatasetReason.value {
    case .noInput:
      return "Input in search bar to start searching".set(style: Style.detailBase)
    case .querying:
      return nil
    case .noMatch(let text):
      return "No match for <q>\(text)</q>".set(style: StyleGroup.detail)
    case .error:
      return "An error occurred".set(style: Style.error)
    }
  }

  func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
    return -searchBar.bounds.height / 2
  }

  func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
    switch viewModel.emptyDatasetReason.value {
    case .querying:
      let ai = UIActivityIndicatorView(activityIndicatorStyle: .gray)
      ai.startAnimating()
      return ai
    default:
      return nil
    }
  }

}

extension GitHubSearchViewController1: DZNEmptyDataSetDelegate {

}
