import MudoxKit

enum Activity: ActivityType {
  case githubSearch
}

extension The {
  static let activityCenter = ActivityTracker<Activity>()
}
