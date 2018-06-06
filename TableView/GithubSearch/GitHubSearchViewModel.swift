import UIKit

import RxSwift
import RxCocoa

import MudoxKit

import JacKit
fileprivate let jack = Jack.with(levelOfThisFile: .verbose)

struct GitHubSearchViewModel {

  let navigationTitle: Driver<String>
  let repositories: Driver<[GitHub.Repository]>
  let networkActivity: Driver<Bool>

  init(queryString: Driver<String>)
  {
    let activity = ActivityTracker()
    networkActivity = activity
      .executing(of: "search")
      .asDriver(onErrorJustReturn: false)

    let queryResult = queryString
      .throttle(0.5)
      .distinctUntilChanged()
      .flatMapLatest ({ text -> Driver<[GitHub.Repository]> in
        if text.isEmpty {
          return .just([])
        } else {
          return GitHub.search(text)
            .do(
              onSuccess: { _ in
                activity.sucess("search")
              },
              onError: {
                jack.error("GitHub.search error: \($0)")
                activity.failure("search")
              },
              onSubscribe: {
                activity.start("search")
              }
            )
            .asDriver(onErrorJustReturn: [])
            .startWith([]) // when starting refresh data, clear the table view first.
        }
      })
    
    repositories = queryResult
    navigationTitle = queryResult.map {
      if $0.isEmpty {
        return "GitHub Search"
      } else {
        return "\($0.count) matches"
      }
    }
  }

}
