use_frameworks!
platform :ios, '10.0'

ENV["COCOAPODS_DISABLE_STATS"] = "true"

target 'TableView' do
  basePath = '/Users/mudox/Develop/Apple/Frameworks/'
  pod 'JacKit',                  :path => basePath + 'JacKit/'

  mudoxKitPath = basePath + 'MudoxKit/'
  pod 'MudoxKit',                :path => mudoxKitPath
  pod 'MudoxKit/ActivityCenter', :path => mudoxKitPath
  pod 'MudoxKit/MBProgressHUD',  :path => mudoxKitPath
  pod 'MudoxKit/Eureka',         :path => mudoxKitPath

  pod 'Eureka'
  pod 'RxSwift'
  pod 'RxCocoa'

  pod 'Moya/RxSwift'
  pod 'RxDataSources'

  pod 'DZNEmptyDataSet'
  pod 'SwiftRichString'
end
