//
//  LoginView.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import UIKit
import Combine


class FloatingTextField: UIView {
    let textField = UITextField()
    let placeholderLabel = UILabel()
    let bottomLine = CALayer()
    let iconImageView = UIImageView()
    
    
    
    init(placeholder: String, icon: UIImage?) {
        super.init(frame: .zero)
        iconImageView.image = icon
        setupUI(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(placeholder: String) {
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = .gray
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textAlignment = .left
        
        bottomLine.backgroundColor = UIColor.gray.cgColor
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .gray
        
        addSubview(textField)
        addSubview(placeholderLabel)
        addSubview(iconImageView)
        layer.addSublayer(bottomLine)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -10),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.frame = CGRect(x: 0, y: bounds.height - 5, width: bounds.width, height: 1)
    }
    
    @objc private func textFieldDidBeginEditing() {
        bottomLine.backgroundColor = UIColor.blue.cgColor
        UIView.animate(withDuration: 0.2) {
            self.placeholderLabel.transform = CGAffineTransform(translationX: 0, y: -20)
            self.placeholderLabel.font = UIFont.systemFont(ofSize: 12)
            self.placeholderLabel.textColor = .blue
            self.iconImageView.tintColor = .blue
        }
    }
    
    @objc private func textFieldDidEndEditing() {
        bottomLine.backgroundColor = UIColor.gray.cgColor
        if textField.text?.isEmpty ?? true {
            UIView.animate(withDuration: 0.2) {
                self.placeholderLabel.transform = .identity
                self.placeholderLabel.font = UIFont.systemFont(ofSize: 16)
                self.placeholderLabel.textColor = .gray
                self.iconImageView.tintColor = .gray
            }
        }
    }
}

protocol LoginView: AnyObject {
    
    func showLoginError(_ message: String)
}

class LoginViewController: UIViewController, LoginView {
    
    var presenter: LoginPresenterInput?
    private var interactor: LoginInteractorInput?
    private var router: LoginRouterInput?
    
    private var cancellables = Set<AnyCancellable>()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Definex\nCase Study"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .blue
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let customLoginButton: CustomButton = {
        let customButton = CustomButton()
        customButton.setButtonTitle(NSLocalizedString("login_button", comment: ""))
        customButton.setTitleColor(.white)
        customButton.setTitleFont(UIFont.boldSystemFont(ofSize: 18))
        customButton.startColor = UIColor(red: 114/255.0, green: 223/255.0, blue: 197/255.0, alpha: 1.0)
        customButton.endColor = UIColor(red: 29/255.0, green: 222/255.0, blue: 125/255.0, alpha: 1.0)
        customButton.customButtonType = .titleOnly
        customButton.setButtonBackgroundColor(.red)
        return customButton
    }()
    
    let customFacebookButton: CustomButton = {
        let customButton = CustomButton()
        customButton.setButtonTitle("FACEBOOK")
        customButton.setTitleColor(.white)
        customButton.setTitleFont(UIFont.boldSystemFont(ofSize: 18))
        customButton.startColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 153/255.0, alpha: 1.0)
        customButton.endColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 153/255.0, alpha: 1.0)
        customButton.customButtonType = .titleWithIconLeft
        customButton.setImageX(UIImage(named: "facebook")!.resized(to: .init(width: 12, height: 21)))
        customButton.setButtonBackgroundColor(.red)
        return customButton
    }()
    
    let customTwitterButton: CustomButton = {
        let customButton = CustomButton()
        customButton.setButtonTitle("TWITTER")
        customButton.setTitleColor(.white)
        customButton.setTitleFont(UIFont.boldSystemFont(ofSize: 18))
        customButton.startColor = UIColor(red: 85/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1.0)
        customButton.endColor = UIColor(red: 85/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1.0)
        customButton.customButtonType = .titleWithIconLeft
        customButton.setImageX(UIImage(named: "twitter")!.resized(to: .init(width: 20, height: 16)))
        customButton.setButtonBackgroundColor(.red)
        return customButton
    }()
    
    
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("forgot_pass", comment: ""), for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()
    
    let emailField = FloatingTextField(placeholder: NSLocalizedString("email", comment: ""), icon: UIImage(systemName: "envelope"))
    let passwordField = FloatingTextField(placeholder: NSLocalizedString("password", comment: ""), icon: UIImage(systemName: "lock"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        assembly()
        setupLayout()
        customLoginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        customFacebookButton.addTarget(self, action: #selector(facebookButtonTapped), for: .touchUpInside)
        customTwitterButton.addTarget(self, action: #selector(twitterButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func loginButtonTapped() {
        guard let email = emailField.textField.text, !email.isEmpty,
              let password = passwordField.textField.text, !password.isEmpty else {
            showLoginError(NSLocalizedString("enter_email_pass", comment: ""))
            return
        }
        
        presenter?.login(email: email, password: password)
    }
    
    @objc func facebookButtonTapped() {
        showComingSoon()
    }
    
    @objc func twitterButtonTapped() {
        showComingSoon()
    }
    
    private func assembly() {
        let interactor = LoginInteractor()
        let router = LoginRouter(viewController: self)
        let presenter = LoginPresenter(view: self, interactor: interactor, router: router)
        
        self.presenter = presenter
        interactor.output = presenter
        self.interactor = interactor
        self.router = router
    }
    
    func customButtonSetup() {
        
    }
    
    func setupLayout() {
        
        
        let socialStackView = UIStackView(arrangedSubviews: [customFacebookButton, customTwitterButton])
        socialStackView.axis = .horizontal
        socialStackView.spacing = 10
        socialStackView.distribution = .fillProportionally
        
        let bottomStackView = UIStackView(arrangedSubviews: [customLoginButton, forgotPasswordButton, socialStackView])
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 20
        
        let textFieldsStackView = UIStackView(arrangedSubviews: [emailField, passwordField])
        textFieldsStackView.axis = .vertical
        textFieldsStackView.spacing = 20
        
        
        
        view.addSubview(titleLabel)
        view.addSubview(bottomStackView)
        view.addSubview(textFieldsStackView)
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        customLoginButton.translatesAutoresizingMaskIntoConstraints = false
        customFacebookButton.translatesAutoresizingMaskIntoConstraints = false
        customTwitterButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            customLoginButton.heightAnchor.constraint(equalToConstant: 50),
            customFacebookButton.heightAnchor.constraint(equalToConstant: 50),
            customTwitterButton.heightAnchor.constraint(equalToConstant: 50),
            textFieldsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textFieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: textFieldsStackView.topAnchor, constant: -60),
            
            bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        if let bottomLine = textField.layer.sublayers?.last {
            bottomLine.backgroundColor = UIColor.blue.cgColor
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if let bottomLine = textField.layer.sublayers?.last {
            bottomLine.backgroundColor = UIColor.gray.cgColor
        }
    }
    
    func showComingSoon() {
        let alert = UIAlertController(title: NSLocalizedString("coming_soon", comment: ""), message: NSLocalizedString("stay_tuned", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func showLoginError(_ message: String) {
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

