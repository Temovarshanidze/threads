import UIKit

class ActorExampleViewController: UIViewController {
    
    private let enterNumberOnetextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Number 1"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let enterNumberTwotextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Number 2"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Result will appear here"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        checkButton.addTarget(self, action: #selector(handleCheckButton), for: .touchUpInside)
     /*
        var name = "John".uppercased()
        print(name)
        name = "jimi"
        name = name.uppercased()
        print(name)
      
      ყოველთტვის აფერ ქეის რომ იყოს სტრინგი
      */
    }
    
    private func setupLayout() {
        view.addSubview(enterNumberOnetextField)
        view.addSubview(enterNumberTwotextField)
        view.addSubview(checkButton)
        view.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            enterNumberOnetextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            enterNumberOnetextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            enterNumberOnetextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            enterNumberOnetextField.heightAnchor.constraint(equalToConstant: 44),
            
            enterNumberTwotextField.topAnchor.constraint(equalTo: enterNumberOnetextField.bottomAnchor, constant: 20),
            enterNumberTwotextField.leadingAnchor.constraint(equalTo: enterNumberOnetextField.leadingAnchor),
            enterNumberTwotextField.trailingAnchor.constraint(equalTo: enterNumberOnetextField.trailingAnchor),
            enterNumberTwotextField.heightAnchor.constraint(equalToConstant: 44),
            
            checkButton.topAnchor.constraint(equalTo: enterNumberTwotextField.bottomAnchor, constant: 30),
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 120),
            checkButton.heightAnchor.constraint(equalToConstant: 44),
            
            resultLabel.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 30),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func handleCheckButton() {
        Task {
            await self.configure()
        }
    }
    
    func getNumb1Config() async -> Int {
        if let text = enterNumberOnetextField.text, let number = Int(text) {
            return number
        }
        return 0
    }
    
    func getNumb2Config() async -> Int {
        if let text = enterNumberTwotextField.text, let number = Int(text) {
            return number
        }
        return 0
    }
    
    func gettextConfig(with number1: Int, and number2: Int) async  -> String{
        let sum = number1 + number2
        let text = "Sum is \(sum)"
            self.resultLabel.text = text
        return text
    }
    
    func configure() async {
        let number1 = await getNumb1Config()
        let number2 = await getNumb2Config()
        let text = await gettextConfig(with: number1, and: number2)
        print(text)
        
        
    }
}

// Actor  პასუხისმგებელია თვაისი ბლოკის შიგნით სრედ სეიფს task ით უნდ ამოხდეს გაშვება  ავაით ქიბორდი ნიშნავს ფუქნციების ასიქნრონულ კონტესქსტში გამოძახებას  ხოლო თითონ ფუქნციის შექქმანისას უნდ აგავუწეროთ async რომ ასინქორნული იყოს


