
import UIKit

class MessageCell: UITableViewCell {
  
  let messageLabel = UILabel()
  let dateLabel = UILabel()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = UIColor.white
    contentView.backgroundColor = UIColor.white
    
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(messageLabel)
    contentView.addSubview(dateLabel)
    
    messageLabel.font = UIFont.slimWithSize(fontSize: 17)
    messageLabel.textColor = UIColor.black
    
    dateLabel.font = UIFont.slimWithSize(fontSize: 15)
    dateLabel.textColor = UIColor.gray
    
    let viewsDict = [
      "text"  : messageLabel,
      "date"  : dateLabel
    ]
    
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[text(20)]-[date]-20-|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[text]-20-|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[date]-20-|", options: [], metrics: nil, views: viewsDict))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
