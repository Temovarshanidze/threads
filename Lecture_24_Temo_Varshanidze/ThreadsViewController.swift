import UIKit
import Lottie

class ThreadsViewController: UIViewController {
    
  //  let animationView =  LottieAnimationView(name: "animation")
    
    @IBOutlet weak var showModernList: UIButton!
    @IBOutlet weak var PickerScroll: UIPickerView!
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var pullDownButton: UIButton!
    
    // MARK: - Picker Data
    let pickerData: [(title: String, controller: UIViewController.Type)] = [
        ("Actor Example", ActorExampleViewController.self),
        ("Main Actor Example", MainActorViewController.self)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAllFunctions()
    }
    
    private func callAllFunctions() {
        PickerScroll.delegate = self
        PickerScroll.dataSource = self
        setupPullDownButton()
        setUpPopUpButton()
        setUpShowBTN()
        title = "Threads"
    }
    
    private func setUpShowBTN() {
        PickerScroll.isHidden = true
        
        showModernList.addAction(UIAction (handler: {[weak self] _ in
            self?.PickerScroll.isHidden = false
        }), for: .touchUpInside)
        
    }
    
    private func setupPullDownButton() {
        let createThreadExample = UIAction(title: "Thread Create Example") { [weak self] _ in
            self?.navigationController?.pushViewController(ThreadsCreateViewController(), animated: true)
        }
        
        let globalAndMainQueueExample = UIAction(title: "Global And Main Queue Example") { [weak self] _ in
            self?.navigationController?.pushViewController(GlobalAndMainQueueViewController(), animated: true)
        }
        
        let asyncAndSyncExample = UIAction(title: "Async And Sync Example") { [weak self] _ in
            self?.navigationController?.pushViewController(AsyncAndSyncViewController(), animated: true)
        }
        
        let menu = UIMenu(title: "Menu", children: [createThreadExample, globalAndMainQueueExample, asyncAndSyncExample])
        pullDownButton.menu = menu
        pullDownButton.showsMenuAsPrimaryAction = true
    }
    
    private func setUpPopUpButton() {
        popUpButton.setTitle("Pop Up Button", for: .normal)
        
        let serialQueueExample = UIAction(title: "Serial Queue Example") { [weak self] _ in
            self?.navigationController?.pushViewController(SerialQueueViewController(), animated: true)
        }
        
        let concurrentQueueExample = UIAction(title: "Concurrent Queue Example") { [weak self] _ in
            self?.navigationController?.pushViewController(ConcurrentQueueViewController(), animated: true)
        }
        
        let ddLockExample = UIAction(title: "DDLock Example") { [weak self] _ in
            self?.navigationController?.pushViewController(DDLockViewController(), animated: true)
        }
        
        let operationQueueExample = UIAction(title: "Operation Queue Example") { [weak self] _ in
            self?.navigationController?.pushViewController(OperationQueueViewController(), animated: true)
        }
        
        let menu = UIMenu(title: "Menu", children: [serialQueueExample, concurrentQueueExample, ddLockExample, operationQueueExample])
        popUpButton.menu = menu
        popUpButton.showsMenuAsPrimaryAction = true
    }
}

// MARK: - UIPickerView Delegate & DataSource

extension ThreadsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedVC = pickerData[row].controller.init()
        let navController = UINavigationController(rootViewController: selectedVC)
        present(navController, animated: true, completion: nil)
    }
}
