import Moya
import RxSwift

enum GitHub {

  static private let _provider = MoyaProvider<GitHub.MoyaTarget>().rx

  static func search(_ query: String) -> Single<[Repository]> {
    return _provider.request(.search(query))
      .map(SearchReponse.self)
      .map { $0.items }
  }

}
