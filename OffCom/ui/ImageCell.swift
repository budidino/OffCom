
import UIKit

class ImageCell: UITableViewCell {
  
  let imgView = UIImageView()
  let dateLabel = UILabel()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = UIColor.white
    contentView.backgroundColor = UIColor.white
    
    imgView.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(imgView)
    contentView.addSubview(dateLabel)
    
    imgView.layer.cornerRadius = 10
    imgView.layer.borderWidth = 1
    imgView.layer.borderColor = UIColor.lightGray.cgColor
    imgView.clipsToBounds = true
    imgView.contentMode = .scaleAspectFill
    
    dateLabel.font = UIFont.slimWithSize(fontSize: 15)
    dateLabel.textColor = UIColor.gray
    
    let viewsDict = [
      "img"   : imgView,
      "date"  : dateLabel
    ] as [String : Any]
    
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[img(300)]-[date]-20-|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[img]-20-|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[date]-20-|", options: [], metrics: nil, views: viewsDict))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
