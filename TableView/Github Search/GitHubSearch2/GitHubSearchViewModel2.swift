import UIKit

import RxSwift
import RxCocoa
import RxSwiftExt

import MudoxKit

import JacKit
fileprivate let jack = Jack.usingLocalFileScope().setLevel(.verbose)

extension GitHubSearchViewController2 {

  enum EmptyDatasetReason {
    case noInput
    case querying(String)
    case noMatch(String)
    case error(Error)
  }

  enum QueryResult {
    case empty(reason: EmptyDatasetReason)
    case success([GitHub.Repository])

    var dataset: [GitHub.Repository] {
      switch self {
      case .empty:
        return []
      case .success(let dataset):
        return dataset
      }
    }

    var isQuerying: Bool {
      if case .empty(reason: .querying) = self {
        return true
      } else {
        return false
      }
    }
  }

  struct ViewModel {

    var disposeBag = DisposeBag()

    struct Item {
      var isExpanded: Bool = false
      let repository: GitHub.Repository

      init(repository: GitHub.Repository) {
        self.repository = repository
      }
    }

    // Outputs
    let title: Driver<String>
    let items: Driver<[Item]>
    let emptyDatasetReason: Driver<EmptyDatasetReason>

    init(
      input: (
        queryString: Driver<String>,
        selectedIndexPath: Driver<IndexPath>
      )
    )
    {
      let itemsSubject = BehaviorSubject<[Item]>(value: [])

      let queryResult: Driver<QueryResult> = input.queryString
        .throttle(0.5)
        .distinctUntilChanged()
        .flatMapLatest ({ text -> Driver<QueryResult> in
          if text.isEmpty {
            return .just(.empty(reason: .noInput))
          } else {
            return GitHub.search(text)
              .asObservable()
              .trackActivity(.githubSearch)
              .map { list -> QueryResult in
                if list.isEmpty {
                  return .empty(reason: .noMatch(text))
                } else {
                  return .success(list)
                }
              }
              .asDriver { error in
                return .just(.empty(reason: .error(error)))
              }
              .startWith(.empty(reason: .querying(text))) // when starting refresh data, clear the table view first.
          }
        })

      queryResult
        .map { $0.dataset.map(Item.init) }
        .drive(itemsSubject)
        .disposed(by: disposeBag)

      input.selectedIndexPath
        .asObservable()
        .withLatestFrom(itemsSubject) {
          (indexPath: IndexPath, items: [Item]) -> [Item] in
          var newItems = items
          newItems[indexPath.row].isExpanded.toggle()
          return newItems
        }
        .bind(to: itemsSubject)
        .disposed(by: disposeBag)

      items = itemsSubject.asDriver(onErrorJustReturn: [])

      title = queryResult
        .map ({
          switch $0 {
          case .empty(reason: .querying):
            return "Querying ..."
          case .empty:
            return "GitHub Search"
          case .success(let list):
            return "\(list.count) matches"
          }
        })

      emptyDatasetReason = queryResult
        .flatMap ({
          switch $0 {
          case .empty(let reason):
            return .just(reason)
          case .success:
            return .empty()
          }
        })

    } // init

  } // ViewModel
}
