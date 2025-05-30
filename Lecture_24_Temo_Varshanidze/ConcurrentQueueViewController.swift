import UIKit

class ConcurrentQueueViewController: UIViewController {
    
    
    private let flagLabel: UILabel = createLabel()
    private let flagLabel1: UILabel = createLabel()
    
    
    private let flagLabel2: UILabel = createLabel()
    private let flagLabel3: UILabel = createLabel()
    
    
    private let asyncButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶️ Async Flip", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let syncButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶️ Sync Scale and Fade", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .brown
        title = "Concurrent Queue"
        
        asyncButton.addTarget(self, action: #selector(startAsyncFlip), for: .touchUpInside)
        syncButton.addTarget(self, action: #selector(startSyncScaleAndFade), for: .touchUpInside)
        
        [flagLabel, flagLabel1, flagLabel2, flagLabel3, asyncButton, syncButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            flagLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flagLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            flagLabel1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flagLabel1.topAnchor.constraint(equalTo: flagLabel.bottomAnchor, constant: 20),
            
            asyncButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            asyncButton.topAnchor.constraint(equalTo: flagLabel1.bottomAnchor, constant: 30),
            asyncButton.widthAnchor.constraint(equalToConstant: 150),
            asyncButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            flagLabel2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flagLabel2.topAnchor.constraint(equalTo: asyncButton.bottomAnchor, constant: 50),
            
            flagLabel3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flagLabel3.topAnchor.constraint(equalTo: flagLabel2.bottomAnchor, constant: 20),
            
            syncButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            syncButton.topAnchor.constraint(equalTo: flagLabel3.bottomAnchor, constant: 30),
            syncButton.widthAnchor.constraint(equalToConstant: 250),
            syncButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    
    
    @objc private func startAsyncFlip() {
        let concurrentQueue = DispatchQueue(label: "concurrent.queue", attributes: .concurrent)
        
        concurrentQueue.async {
            sleep(1)
            DispatchQueue.main.async {
                UIView.transition(
                    with: self.flagLabel,
                    duration: 1.5,
                    options: .transitionFlipFromLeft,
                    animations: nil,
                    completion: nil
                )
            }
        }
        
        concurrentQueue.async {
            sleep(1)
            DispatchQueue.main.async {
                UIView.transition(
                    with: self.flagLabel1,
                    duration: 2.5,
                    options: .transitionFlipFromRight,
                    animations: nil,
                    completion: nil
                )
            }
        }
    }
    
    @objc private func startSyncScaleAndFade() {
        let concurrentQueue = DispatchQueue(label: "concurrent.queue", attributes: .concurrent)
        
        concurrentQueue.sync {
            sleep(2)
            DispatchQueue.main.async {
                
                UIView.animate(withDuration: 1, animations: {
                    self.flagLabel2.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }) { _ in
                    UIView.animate(withDuration: 1) {
                        self.flagLabel2.transform = .identity
                    }
                }
            }
        }
        
        concurrentQueue.async {
                sleep(2)
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1, animations: {
                        self.flagLabel3.alpha = 0.0
                    }) { _ in
                        UIView.animate(withDuration: 1) {
                            self.flagLabel3.alpha = 1.0
                        }
                    }
                }
            }
    }
    
 
    private static func createLabel() -> UILabel {
        let label = UILabel()
        label.text = "🇬🇪"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}


import SwiftUI

#Preview{
    ConcurrentQueueViewController()
}


// კონკურენსის დროს  დროს იმ მასივიდან სადაც არის შესასრულებელი დავალებები ჩაყრილი(მე ასე გავიგე (სიყტყვა მასივს ჩემ პონტში ვიყენებ)) დავალებები ამოდის ერთდროულად და მერე GCD ზე უკვე სინქ და ასინქ აკონტოლებს .. ეს უნდა ვიკითხო ლექციაზე
// RaceCondition კონკურენს სრედია ანუ რომელი მიასწრებს ერთი და იგივე გარემოების დროს.
