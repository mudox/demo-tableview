import MudoxKit

enum Activity {
  case githubSearch
}

extension Activity: ActivityType {
  
  var isNetworkActivity: Bool {
    return true
  }
  
}

extension The {
  static let activityCenter = ActivityCenter<Activity>()
}
