import MudoxKit

extension Activity {

  static let githubSearch = Activity(
    identifier: "githubSearch",
    isNetworkActivity: true,
    maxConcurrency: 1,
    isLoggingEnbaled: false
  )

}
