
import UIKit

class SoundCell: UITableViewCell {
  
  let senderLabel = UILabel()
  let dateLabel = UILabel()
  let playImage = UIImageView()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = UIColor.white
    contentView.backgroundColor = UIColor.white
    
    senderLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    playImage.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(senderLabel)
    contentView.addSubview(dateLabel)
    contentView.addSubview(playImage)
    
    senderLabel.font = UIFont.slimWithSize(fontSize: 17)
    senderLabel.textColor = UIColor.black
    
    dateLabel.font = UIFont.slimWithSize(fontSize: 15)
    dateLabel.textColor = UIColor.gray
    
    playImage.image = UIImage(named: "play")
    playImage.contentMode = .center
    
    let viewsDict = [
      "sender"  : senderLabel,
      "date"    : dateLabel,
      "play"    : playImage
    ] as [String : Any]
    
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[sender(20)]-[date]-20-|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[sender]-60-|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[date]-60-|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[play]|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-1000@1-[play(60)]|", options: [], metrics: nil, views: viewsDict))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
