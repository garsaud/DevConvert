import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var TextStr: UITextView!
    @IBOutlet weak var TextHex: UITextView!
    @IBOutlet weak var TextDec: UITextView!

    var currentTextView: UITextView? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        )

        TextStr.delegate = self
        TextHex.delegate = self
        TextDec.delegate = self
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        currentTextView = textView
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView != currentTextView {
            return
        }

        let textFrom = {
            switch (textView) {
            case TextStr:
                return textView.text;
            case TextHex:
                let hexString = textView.text.replacingOccurrences(of: "0x", with: "")
                guard let bytesData = Data(fromHexEncodedString: hexString) else {
                    return ""
                }
                return String(data: bytesData, encoding: .isoLatin1);
            case TextDec:
                let intArray: [UInt8] = textView.text.split(separator: " ").map { UInt8($0) ?? 0 }

                var bytesData = Data(capacity: intArray.count)
                intArray.forEach() { bytesData.append($0) }

                return String(data: bytesData, encoding: .isoLatin1);
            default:
                return nil
            }
        }() ?? ""

        if (textView != TextStr) {
            TextStr.text = textFrom
        }
        if (textView != TextHex) {
            TextHex.text = "0x"
            TextHex.insertText(
                textFrom.utf16.map{ String(format: "%x", $0) }.joined()
            )
        }
        if (textView != TextDec) {
            TextDec.text = textFrom.utf16.map{ String($0) }.joined(separator: " ")
        }
    }


}

