//
//  OffCom @ Hackathon
//

import UIKit
import MultipeerConnectivity

class OffComMsg: NSObject {
  var message = ""
  var date = Date()
  var type = "message"
  
  init(message: String, date: Date, type: String) {
    self.message = message
    self.date = date
    self.type = type
  }
}

class MainTVC: UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
  
  var peerID: MCPeerID!
  var mcSession: MCSession!
  var mcAdvertiserAssistant: MCAdvertiserAssistant!
  
  var hostButton: UIButton!
  var joinButton: UIButton!
  
  var messages = [OffComMsg]()
  
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
//    tableView.showsVerticalScrollIndicator = false
    
    tableView.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
    
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    tableView.separatorColor = UIColor.lightGray
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 30
    tableView.tableFooterView = UIView()
    
    addMessage(msg: OffComMsg(message: "Waiting for people to join", date: Date(), type: "message"))
  }
  
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//  }
  
  // MARK: - UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("messages.count = \(messages.count)")
    return messages.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let msg = messages[indexPath.row]
    if msg.type == "message" {
      let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
      cell.messageLabel.text = msg.message
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss a"
      let convertedDateString = dateFormatter.string(from: Date())
      
      cell.dateLabel.text = convertedDateString
//      cell.dateLabel.text = "display date here :)"
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
      addMessage(msg: OffComMsg(message: "Connected: \(peerID.displayName)", date: Date(), type: "message"))
      dismiss(animated: true) // automatically dismiss join view
      
    case MCSessionState.connecting:
      print("Connecting: \(peerID.displayName)")
      addMessage(msg: OffComMsg(message: "Connecting: \(peerID.displayName)", date: Date(), type: "message"))
      
    case MCSessionState.notConnected:
      print("Failed to connect to: \(peerID.displayName)")
    }
  }
  
  func addMessage(msg: OffComMsg) {
    DispatchQueue.main.async {
      self.messages.append(msg)
      self.tableView.reloadData()
    }
  }
  
  
  func sendImage(img: UIImage) {
    if mcSession.connectedPeers.count > 0 {
      if let imageData = UIImagePNGRepresentation(img) {
        do {
          try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch let error as NSError {
          let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
        }
      }
    }
  }
  
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    if let image = UIImage(data: data) {
      DispatchQueue.main.async { [unowned self] in
        // do something with the image
      }
    }
  }

}

