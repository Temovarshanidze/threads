

import UIKit
class DDLockViewController: UIViewController {
    
    private let flagLabel1: UILabel = createLabel()
    private let flagLabel2: UILabel = createLabel()

    private let spinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶️ Spin Flag", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let wingleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶️ Wingle Flag", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private static func createLabel() -> UILabel {
        let label = UILabel()
        label.text = "🇬🇪"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 100, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    let resource1 = NSObject()
    let resource2 = NSObject()
    private let lockA = NSLock()
    private let lockB = NSLock()

    override func viewDidLoad() {
        super.viewDidLoad()
        callAllFuncs()
    }

    private func callAllFuncs() {
        view.backgroundColor = .white
        title = "DDLock"
        setupUI()
    }

    private func setupUI() {
        wingleButton.addTarget(self, action: #selector(animateWiggle), for: .touchUpInside)
        spinButton.addTarget(self, action: #selector(animateSpin), for: .touchUpInside)

        [flagLabel1, flagLabel2, spinButton, wingleButton].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            flagLabel1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flagLabel1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            spinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinButton.topAnchor.constraint(equalTo: flagLabel1.bottomAnchor, constant: 30),
            spinButton.widthAnchor.constraint(equalToConstant: 150),
            spinButton.heightAnchor.constraint(equalToConstant: 44),

            flagLabel2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flagLabel2.topAnchor.constraint(equalTo: spinButton.bottomAnchor, constant: 50),

            wingleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wingleButton.topAnchor.constraint(equalTo: flagLabel2.bottomAnchor, constant: 30),
            wingleButton.widthAnchor.constraint(equalToConstant: 250),
            wingleButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

   
    @objc func animateSpin() {
        DispatchQueue.global().async {
            self.lockA.lock()  // აქ დალოქა
            print("🔐 Spin: LockA დაკავებულია")
            Thread.sleep(forTimeInterval: 0.5)  // შეყოვნება
            
            objc_sync_enter(self.resource1)
            print("🔐 Spin: მიიღო resource1")
            
            self.lockB.lock() // დალოქა
            print("🔐 Spin: LockB დაკავებულია")
            
            objc_sync_enter(self.resource2)
            print("🔐 Spin: მიიღო resource2")
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 3.0, animations: {
                    self.flagLabel1.transform = self.flagLabel1.transform.rotated(by: CGFloat.pi)
                }) { _ in
                    UIView.animate(withDuration: 1.0, animations: {
                        self.flagLabel1.transform = .identity
                    }) { _ in
                        objc_sync_exit(self.resource1)
                        print("🔐 Spin: ათავისუფლებს resource1")
                        
                        objc_sync_exit(self.resource2)
                        print("🔐 Spin: ათავისუფლებს resource2")
                        
                        print("🔓 Spin: LockA და LockB თავისუფლდება")
                        
                        self.lockB.unlock()
                        self.lockA.unlock()
                        print("🔐 Spin: გაათავისუფლა ორივე")
                        print("🔓 Spin: LockA და LockB თავისუფალია")
                    }
                }
            }
        }
    }

    @objc func animateWiggle() {
        DispatchQueue.global().async {
            self.lockA.lock() // დალოქა
            print("🔐 Wiggle: LockA დაკავებულია")
            Thread.sleep(forTimeInterval: 0.5)  // შეყოვნება
            
            objc_sync_enter(self.resource1)
            print("🔐 Wiggle: მიიღო resource1")

            self.lockB.lock() // დალოქა
            print("🔐 Wiggle: LockB დაკავებულია")
            
            objc_sync_enter(self.resource2)
            print("🔐 Wiggle: მიიღო resource2")

            DispatchQueue.main.async {
                let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
                animation.values = [0.0, -0.1, 0.5, 0.0]
                animation.keyTimes = [0, 0.1, 0.7, 1]
                animation.duration = 5
                animation.repeatCount = 3
                self.flagLabel2.layer.add(animation, forKey: "wiggle")

                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    
                    objc_sync_exit(self.resource1)
                    print("🔐 Wiggle: ათავისუფლებს resource1")
                    
                    objc_sync_exit(self.resource2)
                    print("🔐 Wiggle: ათავისუფლებს resource2")
                    
                    print("🔓 Wiggle: LockA და LockB თავისუფლდება")
                    
                    self.lockB.unlock()
                    self.lockA.unlock()
                    
                    print("🔐 Wiggle: გაათავისუფლა ორივე")
                    print("🔓 Wiggle: LockA და LockB თავისუფალია")
                }
            }
        }
    }
}

// DDLOCK საშუალებას იძლევა ერთდორულად გაშვებული პროცესები რომლებცი იყენებს ერთსა და იმავე რესურს ან საჭირო  ელემენტს რიგში ჩააყენოს და ერთი პროცესი რომ დასრულდებ და გაატავისუფლებს საჭიორ ელემენტს ან რესურს ამის მერე დაიწყოს მეორე პროცესმა მუშაობა რადგან არ მოხდეს დაქრეშვა.
