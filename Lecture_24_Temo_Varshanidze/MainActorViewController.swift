import UIKit

class MainActorViewController: UIViewController {
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Main Actor DispatchQueue"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let globalLabel: UILabel = {
        let label = UILabel()
        label.text = "Actor DispatchQueue"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let imageViewOne = UIImageView()
    private let imageViewTwo = UIImageView()
    
    private let downloadButtonOne: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download Image (Main)", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButtonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download Image (actor)", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sliderOne = UISlider()
    private let sliderTwo = UISlider()
    
    private let mainStackView = UIStackView()
    private let globalStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        title = "MainActor Queue"
        setupUI()
    }
    
    private func setupUI() {
        imageViewOne.translatesAutoresizingMaskIntoConstraints = false
        imageViewTwo.translatesAutoresizingMaskIntoConstraints = false
        sliderOne.translatesAutoresizingMaskIntoConstraints = false
        sliderTwo.translatesAutoresizingMaskIntoConstraints = false
        
        imageViewOne.contentMode = .scaleAspectFit
        imageViewTwo.contentMode = .scaleAspectFit
        
        sliderOne.minimumValue = 0
        sliderOne.maximumValue = 1
        sliderOne.value = 0.5
        sliderOne.backgroundColor = .black
        
        sliderTwo.minimumValue = 0
        sliderTwo.maximumValue = 1
        sliderTwo.value = 0.5
        sliderTwo.backgroundColor = .black
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        globalStackView.axis = .vertical
        globalStackView.spacing = 10
        globalStackView.alignment = .center
        globalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.addArrangedSubview(mainLabel)
        mainStackView.addArrangedSubview(imageViewOne)
        mainStackView.addArrangedSubview(downloadButtonOne)
        mainStackView.addArrangedSubview(sliderOne)
        
        globalStackView.addArrangedSubview(globalLabel)
        globalStackView.addArrangedSubview(imageViewTwo)
        globalStackView.addArrangedSubview(downloadButtonTwo)
        globalStackView.addArrangedSubview(sliderTwo)
        
        view.addSubview(mainStackView)
        view.addSubview(globalStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            globalStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 50),
            globalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageViewOne.widthAnchor.constraint(equalToConstant: 150),
            imageViewOne.heightAnchor.constraint(equalToConstant: 150),
            
            imageViewTwo.widthAnchor.constraint(equalToConstant: 150),
            imageViewTwo.heightAnchor.constraint(equalToConstant: 150),
            
            sliderOne.widthAnchor.constraint(equalToConstant: 200),
            sliderTwo.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        downloadButtonOne.addTarget(self, action: #selector(getImage), for: .touchUpInside)
        downloadButtonTwo.addTarget(self, action: #selector(getImage1), for: .touchUpInside)
    }
    
    @objc private func getImage() {
        Task {
            await MainActor.run {
                // <-- სპეციალურად Main Thread-ის დაბლოკვა
                let start = Date()
                while Date().timeIntervalSince(start) < 5 {
                    // მძიმე ლუპი (ბლოკავს UI-ს)
                }
            }
            
            do {
                let data = try await fetchImage(url: "https://picsum.photos/200/300")
                 setImage(using: data)
            } catch {
                print("Error fetching image: \(error)")
            }
        }
    }
    
    @objc private func getImage1() {
        Task {
            do {
                try await Task.sleep(nanoseconds: 3 * 1_000_000_000) // არ ბლოკავს UI-ს
                let data = try await fetchImage(url: "https://picsum.photos/200/300")
                 setImage1(using: data)
            } catch {
                print("Error fetching image: \(error)")
            }
        }
        
        Task {
            setImage(using: Data())
        }


        Task {
            setImage1(using: Data())
        }
    }
    
    private func fetchImage(url: String) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        return data
    }
    
 
    
    @MainActor
    func setImage(using data: Data) {
        imageViewOne.image = UIImage(data: data)
    }
    
    @MainActor
    func setImage1(using data: Data) {
        imageViewTwo.image = UIImage(data: data)
    }
}



/*
მაინ აქტორით ხდება მტავრ ნაკადზე გაშვება მაგრამ შესაძლებელია ისე გაეშვას რომ არ დაბლოკოს ანუ ასინქორულად გაეშვას მეინზე
ეს ანწილი აკეტებს დაბლოკვას
 
 await MainActor.run {
     // <-- სპეციალურად Main Thread-ის დაბლოკვა
     let start = Date()
     while Date().timeIntervalSince(start) <5 {
         // მძიმე ლუპი (ბლოკავს UI-ს)
     }
 }
*/
