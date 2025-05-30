import UIKit

class OperationQueueViewController: UIViewController {
    
    let labelCountOne: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "🔢 Count One"
        return label
    }()
    
    let labelCountTwo: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "🔢 Count Two"
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶️ Start Both Counters", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let labelCountThree: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "🔢 Count Three"
        return label
    }()
    
    let labelCountFour: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "🔢 Count Four"
        return label
    }()
    
    let startButtonSec: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶️ Start Both Counters", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .systemYellow
        title = "Operation Queue"
    }
    
    private func setupUI() {
        view.addSubview(labelCountOne)
        view.addSubview(labelCountTwo)
        view.addSubview(startButton)
        
        view.addSubview(labelCountThree)
        view.addSubview(labelCountFour)
        view.addSubview(startButtonSec)
        
        
        startButton.addTarget(self, action: #selector(startBothCountersQualityOfService), for: .touchUpInside)
        startButtonSec.addTarget(self, action: #selector(startBothCountersQueuePriority), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            labelCountOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelCountOne.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            labelCountTwo.topAnchor.constraint(equalTo: labelCountOne.bottomAnchor, constant: 40),
            labelCountTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton.topAnchor.constraint(equalTo: labelCountTwo.bottomAnchor, constant: 60),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 220),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
            labelCountThree.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 50),
            labelCountThree.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            labelCountFour.topAnchor.constraint(equalTo: labelCountThree.bottomAnchor, constant: 40),
            labelCountFour.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButtonSec.topAnchor.constraint(equalTo: labelCountFour.bottomAnchor, constant: 60),
            startButtonSec.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButtonSec.widthAnchor.constraint(equalToConstant: 220),
            startButtonSec.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func startBothCountersQualityOfService() {
        let operationOne = BlockOperation()
        
        operationOne.qualityOfService = .userInteractive
        operationOne.addExecutionBlock
        {
            for i in 0...50 {
                DispatchQueue.main.async {
                    self.labelCountOne.text = "🔵 Count One: \(i)"
                }
                sleep(1)
            }
        }
        
        let operationTwo = BlockOperation()
        operationTwo.qualityOfService = .background
        operationTwo.addExecutionBlock
        {
            for i in 0...50 {
                DispatchQueue.main.async {
                    self.labelCountTwo.text = "🟢 Count Two: \(i)"
                }
                sleep(1)
            }
        }
        
        let queue = OperationQueue()
        queue.addOperations([operationOne, operationTwo], waitUntilFinished: false)
    }
    
    
    @objc private func startBothCountersQueuePriority() {
        let operationOne = BlockOperation()
        
        operationOne.queuePriority = .veryHigh
        operationOne.addExecutionBlock
        {
            for i in 0...50 {
                DispatchQueue.main.async {
                    self.labelCountThree.text = "🔵 Count Three: \(i)"
                }
                sleep(1)
            }
        }
        
        let operationTwo = BlockOperation()
        operationTwo.queuePriority = .veryLow
        operationTwo.addExecutionBlock
        {
            for i in 0...50 {
                DispatchQueue.main.async {
                    self.labelCountFour.text = "🟢 Count Four: \(i)"
                }
                sleep(1)
            }
        }
        
        let queue = OperationQueue()
        queue.addOperations([operationOne, operationTwo], waitUntilFinished: false)
    }
}



// ოპერეიშენ ქიუ უფრო მარლა დგას ვიდრე GCD, ანუ operationTwo.qualityOfService = .background აქ მიუთიტებ ისე დააპრიორიტეტებს საქმეს ანუ რესურს დაუთმობს ძირიტადად იმას რომელიც უფრო პრიორიტეტულია, ანუ დივაისის რესურსის  დონეზე აკეტებს პრიორიტეს ანუ რას მოახმაროს უფორ მეტი რესურსი. 
