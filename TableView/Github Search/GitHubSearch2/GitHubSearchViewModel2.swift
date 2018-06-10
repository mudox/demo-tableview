import UIKit

import RxSwift
import RxCocoa

import MudoxKit

import JacKit
fileprivate let jack = Jack.usingLocalFileScope().setLevel(.verbose)

extension GitHubSearchViewController2 {
  
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

    init(
      input: (
        queryString: Driver<String>,
        selectedIndexPath: Driver<IndexPath>
      )
    )
    {
      let itemsSubject = BehaviorSubject<[Item]>(value: [])

      let matchedRepos = input.queryString
        .throttle(0.5)
        .distinctUntilChanged()
        .flatMapLatest ({ text -> Driver<[GitHub.Repository]> in
          if text.isEmpty {
            return .just([])
          } else {
            return GitHub.search(text)
              .asObservable()
              .trackActivity(.githubSearch)
              .asDriver(onErrorJustReturn: [])
              .startWith([]) // when starting refresh data, clear the table view first.
          }
        })

      matchedRepos
        .map { $0.map(Item.init) }
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

      title = matchedRepos.map {
        if $0.isEmpty {
          return "GitHub Search"
        } else {
          return "\($0.count) matches"
        }
      }
      
    } // init

  } // ViewModel
}
