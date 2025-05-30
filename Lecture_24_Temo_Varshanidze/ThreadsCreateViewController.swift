import UIKit
import TinyConstraints


class ThreadsCreateViewController: UIViewController {
    
    private let threadsServiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Click Me", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let commnetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true // ✅ თავიდან დამალული
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemBlue
        return label
    }()
    
    private let commnetLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Print ფუნქცია გაეშვა"
        label.isHidden = true // ✅ თავიდან დამალული
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemBlue
        return label
    }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAllThreads()
        
       // commnetLabel.edgesToSuperview()
        
    }
    
    private func callAllThreads() {
        title = "Create Thread Example"
        view.backgroundColor = .systemBackground
        setUpUI()
    }
    
    private func setUpUI() {
        view.addSubview(threadsServiceButton)
        view.addSubview(commnetLabel)
        view.addSubview(commnetLabel1)
        
        threadsServiceButton.addTarget(self, action: #selector(callThreadsService), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            threadsServiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            threadsServiceButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            threadsServiceButton.widthAnchor.constraint(equalToConstant: 120),
            threadsServiceButton.heightAnchor.constraint(equalToConstant: 44),
            
            commnetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            commnetLabel.topAnchor.constraint(equalTo: threadsServiceButton.bottomAnchor, constant: 30),
            
            commnetLabel1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            commnetLabel1.topAnchor.constraint(equalTo: commnetLabel.bottomAnchor, constant: 30)
        ])
    }
    
    @objc func callThreadsService() {
        //commnetLabel.isHidden = false // ✅ გამოჩნდება ღილაკზე დაჭერისას
        commnetLabel1.isHidden = false
        
        commnetLabel.alpha = 0
        commnetLabel.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.commnetLabel.alpha = 1
        }
        
        
        
        let threadOne = Thread {
            for i in 0...5 {
                DispatchQueue.main.async {
                    self.commnetLabel.text = "➡️ Thread 1 - \(i)"
                    print("Thread ✅ \(Thread.current.isMainThread) - \(i)")
                }
                sleep(1)
            }
        }
        
        let threadTwo = Thread {
            for i in 0...5 {
                
                    print("Thread ❌ \(Thread.current.isMainThread) - \(i)")
                }
            }
        
        
        threadOne.threadPriority = 0.2
        threadOne.start()
        threadTwo.start()
    }
}
// ანუ ჩვენ შეგვიძლია შევქმნათ არხი და მანდ გავუშვათ პრიცებსეი. პროცესების გაშვება ხდება პარალელურად. შეგვიძლია ჩავსცათ მეინ სრედში და ჩვენი არხი იქნება მეინი .  ხაზი 37

// ზოგადად ჩცვენ ხელიტ არ უნდა შევქმნათ და უნდა გამოვიყენოთ GCD - Grand Central Dispatch



