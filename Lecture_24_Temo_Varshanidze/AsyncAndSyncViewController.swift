

import UIKit

class AsyncAndSyncViewController: UIViewController {

    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "DispatchQueue.Sync"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()

    private let globalLabel: UILabel = {
        let label = UILabel()
        label.text = "DispatchQueue.Async"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()

    private let imageViewOne = UIImageView()
    private let imageViewTwo = UIImageView()

    private let downloadButtonOne: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download Image (Sync)", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let downloadButtonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download Image (Async)", for: .normal)
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
        title = "Sync vs Async Queue"
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

        // Main StackView
        mainStackView.addArrangedSubview(mainLabel)
        mainStackView.addArrangedSubview(imageViewOne)
        mainStackView.addArrangedSubview(downloadButtonOne)
        mainStackView.addArrangedSubview(sliderOne)

        // Global StackView
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

        downloadButtonOne.addTarget(self, action: #selector(downloadImageMain), for: .touchUpInside)
        downloadButtonTwo.addTarget(self, action: #selector(downloadImageGlobal), for: .touchUpInside)
    }

    @objc private func downloadImageMain() {
        guard let url = URL(string: "https://picsum.photos/200/300") else { return }
        DispatchQueue.global(qos: .default).sync {
            sleep(3)
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.imageViewOne.image = UIImage(data: data)
                }
            }.resume()
        }
    }

    @objc private func downloadImageGlobal() {
        guard let url = URL(string: "https://picsum.photos/200/300") else { return }
        DispatchQueue.global(qos: .default).async {
            sleep(3)
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.imageViewTwo.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}


// კი გლობალზეა გაშვებული მაგრამ სინქრონულად არის (ხაზი 122) და ეგ ნიშნავს რომ სანამ არ მორჩება ეს პრიცესი მანამდე ყველა  შედმეგი პრიცესი იქნება დაბლოკილი

// ანუ სინქი და ასინქი  GCD -ზე გადასულ პროცესებზე მოქმედებს.
