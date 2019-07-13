import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var touchButton: UIButton!
    @IBOutlet private weak var myLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var myActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var numberOfClicks: Int = 0
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.myActivityIndicator.stopAnimating()
        }
    }
    
    private func configureUI(){
        touchButton.layer.cornerRadius = 6
        startButton.layer.cornerRadius = 6
        stopButton.layer.cornerRadius = 6
        myLabel.text = String(numberOfClicks)
        myActivityIndicator.startAnimating()
    }
    
    // MARK: - Actions
    
    @IBAction private func touchCounterButton() {
        numberOfClicks += 1
        myLabel.text = String(numberOfClicks)
    }
    
    @IBAction private func startTouchButton() {
        myActivityIndicator.startAnimating()
    }
    
    @IBAction private func stopTouchButton() {
        myActivityIndicator.stopAnimating()
    }
}
