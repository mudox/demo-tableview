import SwiftRichString

extension Style {

  static let title = Style {
    $0.font = UIFont.boldSystemFont(ofSize: 20)
  }

  static let detailBase = Style {
    $0.font = UIFont.systemFont(ofSize: 17, weight: .light)
  }

  static let queryText = Style {
    $0.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    $0.color = UIColor.black
  }

  static let error = Style {
    $0.color = UIColor.red
  }

}

extension StyleGroup {
  
  static let detail = StyleGroup(base: Style.detailBase, [
    "q": Style.queryText,
  ])
  
}
