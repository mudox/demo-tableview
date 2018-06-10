import UIKit

class ExpandableTableViewCell: UITableViewCell {

  typealias Content = ExpandableTableViewController.Section.Row

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!

  @IBOutlet weak var titleMessageSapcing: NSLayoutConstraint!

  override func awakeFromNib() {
    super.awakeFromNib()

    selectionStyle = .none
  }

  func show(_ content: Content) {
    titleLabel.text = content.title
    messageLabel.text = content.isExpanded ? content.message : ""

    titleMessageSapcing.constant = content.isExpanded ? 8 : 0
  }

}
