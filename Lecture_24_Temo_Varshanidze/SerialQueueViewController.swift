import UIKit

class SerialQueueViewController: UIViewController {
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progress = 0.0
        progress.trackTintColor = .darkGray
        progress.progressTintColor = .systemGreen
        progress.layer.cornerRadius = 5
        progress.clipsToBounds = true
        return progress
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶️ Start 1", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
       // button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let startButton2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶️ Start 2", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
       // button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let startButton3: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶️ Start 3", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        //button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let progressView1: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progress = 0.0
        progress.trackTintColor = .darkGray
        progress.progressTintColor = .systemOrange
        progress.layer.cornerRadius = 5
        progress.clipsToBounds = true
        return progress
    }()
    
    private let serialQueue = DispatchQueue(label: "serial.queue") // ჩვენს მიერ შექმნილი სერიალ ქიუ სრედი

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        title = "Serial Queue"

        view.addSubview(progressView)
        view.addSubview(progressView1)
        view.addSubview(startButton)
        view.addSubview(startButton2)
        view.addSubview(startButton3)


        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            progressView.widthAnchor.constraint(equalToConstant: 250),
            progressView.heightAnchor.constraint(equalToConstant: 10),

            progressView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView1.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 60),
            progressView1.widthAnchor.constraint(equalToConstant: 250),
            progressView1.heightAnchor.constraint(equalToConstant: 10),
            
            
            startButton.topAnchor.constraint(equalTo: progressView1.bottomAnchor, constant: 20),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton2.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            startButton2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton3.topAnchor.constraint(equalTo: startButton2.bottomAnchor, constant: 20),
            startButton3.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])

        startButton.addTarget(self, action: #selector(startBothProgresses), for: .touchUpInside)
        startButton2.addTarget(self, action: #selector(startBothProgresses1), for: .touchUpInside)
        startButton3.addTarget(self, action: #selector(startBothProgresses2), for: .touchUpInside)
    }

    @objc private func startBothProgresses() {
        progressView.progress = 0
        progressView1.progress = 0

        serialQueue.async {
            for i in 0..<6 {
                let progress = Float(i) / 5.0
                sleep(1)
                DispatchQueue.main.async {
                    self.progressView.progress = progress
                }
            }

            for i in 0..<6 {
                let progress = Float(i) / 5.0
                sleep(1)
                DispatchQueue.main.async {
                    self.progressView1.progress = progress
                }
            }
        }
    }
    
    @objc private func startBothProgresses1() {
        progressView.progress = 0
        progressView1.progress = 0

        serialQueue.async {
            for i in 0..<6 {
                let progress = Float(i) / 5.0
                sleep(1)
                DispatchQueue.main.async {
                    self.progressView.progress = progress
                }
            }
        }
        serialQueue.async {
            for i in 0..<6 {
                let progress = Float(i) / 5.0
                sleep(1)
                DispatchQueue.main.async {
                    self.progressView1.progress = progress
                }
            }
        }
    }
    
    @objc private func startBothProgresses2() {
        progressView.progress = 0
        progressView1.progress = 0

        serialQueue.sync {
            for i in 0..<6 {
                let progress = Float(i) / 5.0
                sleep(1)
                DispatchQueue.main.async {
                    self.progressView.progress = progress
                }
            }
        }
        serialQueue.async {
            for i in 0..<6 {
                let progress = Float(i) / 5.0
                sleep(1)
                DispatchQueue.main.async {
                    self.progressView1.progress = progress
                }
            }
        }
    }
}


// სერიალ ქიუ სრედის დროს იმ მასივიდან სადაც არის შესასრულებელი დავალებები ჩაყრილი(მე ასე გავიგე (სიყტყვა მასივს ჩემ პონტში ვიყენებ)) დავალებები ამოდის ტანმიმდევრობით და მერე GCD ზე უკვე სინქ და ასინქ აკონტოლებს .. ეს უნდა ვიკითხო ლექციაზე
