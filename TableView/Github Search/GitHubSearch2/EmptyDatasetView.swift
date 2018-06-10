import UIKit

import RxSwift
import RxCocoa

import SwiftRichString

class EmptyDatasetView: UIView {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailTitle: UILabel!
  @IBOutlet weak var queryingIndicator: UIActivityIndicatorView!

  static func loadFromNib() -> EmptyDatasetView {
    let nib = UINib(nibName: "EmptyDatasetView", bundle: nil)
    return nib.instantiate(withOwner: nil, options: [:]).first as! EmptyDatasetView
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    reset()
  }

  func reset() {
    titleLabel.text = nil
    titleLabel.attributedText = nil

    detailTitle.text = nil
    detailTitle.attributedText = nil

    queryingIndicator.stopAnimating()
  }

  var reason: Binder<GitHubSearchViewController2.EmptyDatasetReason> {


    return Binder(self) { view, reason in
      view.reset()

      switch reason {
      case .noInput:
        view.titleLabel.attributedText = "GitHub Search".set(style: Style.title)
        view.detailTitle.attributedText = "Input text in the search bar to start searching".set(style: Style.detailBase)
      case .noMatch(let text):
        view.titleLabel.attributedText = "Oops!".set(style: Style.title)
        view.detailTitle.attributedText = "No match for <q>\(text)</q>".set(style: StyleGroup.detail)
      case .querying:
        view.queryingIndicator.startAnimating()
      case .error:
        view.titleLabel.attributedText = "Oops!".set(style: Style.error)
        view.detailTitle.attributedText = "An error occurred".set(style: Style.error)
      }
    }
  }

}
