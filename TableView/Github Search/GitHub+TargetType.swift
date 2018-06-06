import Moya

extension GitHub {

  enum MoyaTarget: Moya.TargetType {
    case search(String)

    public var method: Moya.Method {
      return .get
    }

    public var baseURL: URL {
      return URL(string: "https://api.github.com")!
    }

    public var path: String {
      switch self {
      case .search:
        return "/search/repositories"
      }
    }

    public var headers: [String: String]? {
      return nil
    }

    public var task: Task {
      switch self {
      case .search(let query):
        let parameters: [String: Any] = [
          "q": query,
          "sort": "stars",
          "order": "desc",
        ]
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
      }
    }

    public var validationType: ValidationType {
      return .successCodes
    }

    public var sampleData: Data {
      return Data()
    }

  }
}
