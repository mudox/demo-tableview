import UIKit

import RxSwift
import RxCocoa
import RxSwiftExt

import MudoxKit

import JacKit
fileprivate let jack = Jack.usingLocalFileScope().setLevel(.verbose)

extension GitHubSearchViewController1 {

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
  }

  class ViewModel {

    var disposeBag = DisposeBag()

    // Outputs
    let title: Driver<String>
    let repositories: Driver<[GitHub.Repository]>
    let emptyDatasetReason = BehaviorRelay<EmptyDatasetReason>(value: .noInput)

    init(queryString: Driver<String>) {

      let queryResult: Driver<QueryResult> = queryString
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

      repositories = queryResult.map { $0.dataset }

      queryResult
        .asObservable()
        .filterMap {
          switch $0 {
          case .empty(let reason):
            return .map(reason)
          case .success:
            return .ignore
          }
        }
        .bind(to: emptyDatasetReason)
        .disposed(by: disposeBag)

      title = repositories.map {
        if $0.isEmpty {
          return "GitHub Search"
        } else {
          return "\($0.count) matches"
        }
      }

    } // init

  } // ViewModel
}
