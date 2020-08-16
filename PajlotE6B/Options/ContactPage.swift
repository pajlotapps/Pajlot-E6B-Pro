
import UIKit
import MessageUI


class ContactPage: UIViewController {
    
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var mailBtn: UIButton!
    @IBOutlet weak var instagramBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    
    @IBOutlet weak var ContactInfo1: UITextView!
    @IBOutlet weak var ContactInfo2: UITextView!
    
    let twitterUrl = URL(string: "http://twitter.com/pajlotapps")
    let instagramUrl = URL(string: "http://www.instagram.com/pajlotapps/")
    let facebookUrl = URL(string: "https://www.facebook.com/pajlot.apps")

    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ContactTitle", comment: "Title")
        ContactInfo1.text = NSLocalizedString("ContactInfo1", comment: "Info1")
        ContactInfo2.text = NSLocalizedString("ContactInfo2", comment: "Info2")

        let twitterLogo = UIImage(named: "twitter")
        let twitterTint = twitterLogo?.maskWith(color: mainColor)

        let instagramLogo = UIImage(named: "instagram")
        let instagramTint = instagramLogo?.maskWith(color: mainColor)

        let facebookLogo = UIImage(named: "facebook")
        let facebookTint = facebookLogo?.maskWith(color: mainColor)

        let mailLogo = UIImage(named: "mail")
        let mailTint = mailLogo?.maskWith(color: mainColor)

        twitterBtn.setImage(twitterTint, for: UIControlState.normal)
        instagramBtn.setImage(instagramTint, for: UIControlState.normal)
        facebookBtn.setImage(facebookTint, for: UIControlState.normal)
        mailBtn.setImage(mailTint, for: UIControlState.normal)
        
        twitterBtn.addTarget(self, action: #selector(didTapTwitter), for: .touchUpInside)
        instagramBtn.addTarget(self, action: #selector(didTapInstagram), for: .touchUpInside)
        facebookBtn.addTarget(self, action: #selector(didTapFacebook), for: .touchUpInside)

    }
    
    
    @IBAction func sendEmail(sender: AnyObject) {
        showMailComposer()
    }
    
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            //alert with info that cant send email
            print("alert with info that cant send email")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["pajlotapps@gmail.com"])
        composer.setSubject("Pajlot E6B PRO - HELP!")
        composer.setMessageBody("I love your app, but ... can You fix ...?", isHTML: false)
        
        present(composer, animated: true)

    }
 
    
    @objc func didTapTwitter(sender: AnyObject) {
        UIApplication.shared.open(twitterUrl!, options: [:], completionHandler: nil)
    }
    @objc func didTapInstagram(sender: AnyObject) {
        UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
    }
    @objc func didTapFacebook(sender: AnyObject) {
        UIApplication.shared.open(facebookUrl!, options: [:], completionHandler: nil)
    }
    
}

extension ContactPage: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        case .failed:
            print("Field to send")
        case .cancelled:
            print("Cancelled")
        }
        
        controller.dismiss(animated: true)
    }

}
