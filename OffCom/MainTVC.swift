//
//  OffCom @ Hackathon
//

import UIKit
import MultipeerConnectivity

class OffComMsg: NSObject {
  var message: String?
  var date: Date!
  var type: String!
  var image: UIImage?
  
  init(message: String?, date: Date, type: String, image: UIImage?) {
    self.message = message
    self.date = date
    self.type = type
    self.image = image
  }
}

class MainTVC: UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var peerID: MCPeerID!
  var mcSession: MCSession!
  var mcAdvertiserAssistant: MCAdvertiserAssistant!
  
  var hostButton: UIButton!
  var joinButton: UIButton!
  
  var messages = [OffComMsg]()
  
  var buttonPic: UIButton!
  var buttonText: UIButton!
  
  let picker = UIImagePickerController()
  var imagePicked: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "OffCom"
    view.backgroundColor = .white
    
    peerID = MCPeerID(displayName: UIDevice.current.name)
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession.delegate = self
    
    let joinButton = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(joinSession))
    self.navigationItem.rightBarButtonItem  = joinButton
    
    startHosting() // everyone is hosting by default
    
    setupView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupView() {
    tableView.backgroundColor = UIColor.white

    tableView.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
    tableView.register(ImageCell.self, forCellReuseIdentifier: "imageCell")
    
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    tableView.separatorColor = UIColor.lightGray
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 30
    tableView.tableFooterView = UIView()
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 130, right: 0)
    
    buttonPic = UIButton(frame: CGRect(x: 20, y: view.frame.height - 80 - 10, width: 80, height: 80))
    buttonPic.setTitle("PIC", for: .normal)
    buttonPic.backgroundColor = UIColor.init(hexString: "#2980b9")
    buttonPic.layer.cornerRadius = 40
    buttonPic.setTitleColor(UIColor.white, for: .normal)
    buttonPic.setTitleColor(UIColor.black, for: .highlighted)
    buttonPic.addTarget(self, action: #selector(tappedPic), for: .touchUpInside)
    appNav.view.addSubview(buttonPic)
    
    buttonText = UIButton(frame: CGRect(x: view.frame.width/2-40, y: view.frame.height - 80 - 10, width: 80, height: 80))
    buttonText.setTitle("TEXT", for: .normal)
    buttonText.backgroundColor = UIColor.init(hexString: "#c0392b")
    buttonText.layer.cornerRadius = 40
    buttonText.setTitleColor(UIColor.white, for: .normal)
    buttonText.setTitleColor(UIColor.black, for: .highlighted)
    buttonText.addTarget(self, action: #selector(tappedText), for: .touchUpInside)
    appNav.view.addSubview(buttonText)
    
    addMessage(msg: OffComMsg(message: "Waiting for people to join", date: Date(), type: "message", image: nil))
  }
  
  // MARK: actions
  
  func tappedPic() {
    print("tapped pic")
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.allowsEditing = false
      picker.sourceType = .camera
      picker.cameraCaptureMode = .photo
      picker.modalPresentationStyle = .fullScreen
      picker.delegate = self
      present(picker, animated: true, completion: nil)
    }
  }
  
  func tappedText() {
    print("tapped text")
    
    let alert = UIAlertController(title: nil, message: "send message", preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.text = ""
    }
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
      let textField = alert.textFields![0]
      self.sendText(txt: textField.text!)
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  func addMessage(msg: OffComMsg) {
    DispatchQueue.main.async {
      self.messages.append(msg)
      self.tableView.reloadData()
      
      let ip = IndexPath(row: self.messages.count-1, section: 0)
      self.tableView.scrollToRow(at: ip, at: .bottom, animated: true)
    }
  }
  
  
  func sendImage(img: UIImage) {
    print("send image")
    addMessage(msg: OffComMsg(message: nil, date: Date(), type: "image", image: img))
    if mcSession.connectedPeers.count > 0 {
      if let imageData = UIImageJPEGRepresentation(img, 0.75) {
        do {
          try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch let error as NSError {
          print("failed")
          let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
        }
      }
    }
  }
  
  func sendText(txt: String) {
    print("send text")
    addMessage(msg: OffComMsg(message: "ME: \(txt)", date: Date(), type: "message", image: nil))
    if mcSession.connectedPeers.count > 0 {
      if let textData = txt.data(using: .utf8) {
        do {
          try mcSession.send(textData, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch let error as NSError {
          print("failed")
          let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
        }
      }
    }
  }
  
  
  // MARK: image picker delegate
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    print("image picked")
//    imagePicked.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
    dismiss(animated: true, completion: nil)
    sendImage(img: info[UIImagePickerControllerOriginalImage] as! UIImage!)
  }
  
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//  }
  
  // MARK: - UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let msg = messages[indexPath.row]
    if msg.type == "message" {
      let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
      cell.messageLabel.text = msg.message
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss a"
      let convertedDateString = dateFormatter.string(from: msg.date)
      
      cell.dateLabel.text = convertedDateString
      return cell
    }
    
    if msg.type == "image" {
      let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell
      cell.imgView.image = msg.image
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss a"
      let convertedDateString = dateFormatter.string(from: msg.date)
      cell.dateLabel.text = convertedDateString
      return cell
    }
    
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  // Multipeer stuff
  
  func startHosting() {
    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "OffCom", discoveryInfo: nil, session: mcSession)
    mcAdvertiserAssistant.start()
  }
  
  func joinSession() {
    let mcBrowser = MCBrowserViewController(serviceType: "OffCom", session: mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
  }
  
  
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    //
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    //
  }
  
  func session(_ session:MCSession, didFinishReceivingResourceWithName resourceName:String, fromPeer peerID:MCPeerID, at localURL:URL, withError error:Error?){
    //
  }
  
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case MCSessionState.connected:
      print("Connected: \(peerID.displayName)")
      addMessage(msg: OffComMsg(message: "Connected: \(peerID.displayName)", date: Date(), type: "message", image: nil))
      dismiss(animated: true) // automatically dismiss join view
      
    case MCSessionState.connecting:
      print("Connecting: \(peerID.displayName)")
      addMessage(msg: OffComMsg(message: "Connecting: \(peerID.displayName)", date: Date(), type: "message", image: nil))
      
    case MCSessionState.notConnected:
      print("Failed to connect to: \(peerID.displayName)")
      addMessage(msg: OffComMsg(message: "Lost: \(peerID.displayName)", date: Date(), type: "message", image: nil))
    }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    print("got data")
    if let image = UIImage(data: data) {
      print("data is an image")
      DispatchQueue.main.async {
        print("displaying data")
        self.addMessage(msg: OffComMsg(message: nil, date: Date(), type: "image", image: image))
      }
    }
    
    else if let str = String.init(data: data, encoding: .utf8) {
      print("data is a string")
      DispatchQueue.main.async {
        print("displaying data")
        self.addMessage(msg: OffComMsg(message: "\(peerID.displayName): \(str)", date: Date(), type: "message", image: nil))
      }
    }
  }

}

