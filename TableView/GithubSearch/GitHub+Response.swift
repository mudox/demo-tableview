import Foundation

extension GitHub {

  struct SearchReponse: Decodable {

    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]

    private enum CodingKeys: String, CodingKey {
      case totalCount = "total_count"
      case incompleteResults = "incomplete_results"
      case items
    }

  }

  struct Repository: Decodable {

    let id: Int
    let name: String
    let fullName: String
    let stars: Int
    let url: String
    let description: String?

    private enum CodingKeys: String, CodingKey {
      case id
      case name
      case fullName = "full_name"
      case url = "html_url"
      case stars = "stargazers_count"
      case description
    }

  }
  
}
