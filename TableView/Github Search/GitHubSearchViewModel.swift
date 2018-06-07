import UIKit

import RxSwift
import RxCocoa

import MudoxKit

import JacKit
fileprivate let jack = Jack.usingLocalFileScope().setLevel(.verbose)

struct GitHubSearchViewModel {

  let navigationTitle: Driver<String>
  let repositories: Driver<[GitHub.Repository]>

  init(queryString: Driver<String>)
  {
    let queryResult = queryString
      .throttle(0.5)
      .distinctUntilChanged()
      .flatMapLatest ({ text -> Driver<[GitHub.Repository]> in
        if text.isEmpty {
          return .just([])
        } else {
          return GitHub.search(text)
            .asObservable()
            .track(Activity.githubSearch, by: The.activityCenter)
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
