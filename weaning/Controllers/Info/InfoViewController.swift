//
//  InfoViewController.swift
//  weaning
//
//  Created by Yuri Cavallin on 21/3/23.
//

import UIKit
import MessageUI

class InfoViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var explicationTextView: UITextView!
    @IBOutlet private weak var ewelinaImageView: UIImageView!
    @IBOutlet private weak var emailButtonView: ButtonView!
    @IBOutlet private weak var telegramButtonView: ButtonView!
    @IBOutlet private weak var telegramLock: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        explicationTextView.attributedText = "INFO_DESCRIPTION".localized().htmlToAttributedString()
        telegramLock.isHidden = RevenueCatService.shared.hasUnlockedPro

        emailButtonView.configureWith(.init(title: "INFO_EMAIL".localized(), tapHandler: {
            self.sendEmail()
        }))

        telegramButtonView.configureWith(.init(title: "INFO_TELEGRAM".localized(), tapHandler: {
            if RevenueCatService.shared.hasUnlockedPro {
                self.openTelegram()
            } else {
                NavigationService.present(viewController: NavigationService.subscriptionViewController())
            }
        }))

        DispatchQueue.main.async {
            self.viewDidLayoutSubviews()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        FirebaseAnalytics.shared.trackScreenView(className: self.className)
    }

    override func viewDidLayoutSubviews() {
        textViewHeightConstraint.constant = explicationTextView.contentSize.height
        contentViewHeightConstraint.constant = textViewHeightConstraint.constant
            + 400
        ewelinaImageView.roundCornersSimplified(cornerRadius: ewelinaImageView.frame.height/2)
    }

    func sendEmail() {
        let recipientEmail = "konsultacje.ewelina@gmail.com"
        let subject = "INFO_EMAIL_TITLE".localized()
        let body = "INFO_EMAIL_BODY".localized()

        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)

            present(mail, animated: true)
        // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }

    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }

        return defaultUrl
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    func openTelegram() {
        let appURL = NSURL(string: "tg://resolve?domain=ewelina84")!
        let webURL = NSURL(string: "https://t.me/ewelina84")!
        if UIApplication.shared.canOpenURL(appURL as URL) {
            UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
        }
    }

}
