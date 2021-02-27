//
//  SignUpViewController.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {

    // constants
    enum Constants {
        static let successAlertTitle = "Usuario Guadado."
        static let failAlertTitle = "Usuario Guadado."
    }

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let registerViewModel = RegisterViewModel()
    var registerSubscriber: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpView()
    }

    // IBActions
    @IBAction func goToLogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func registerNewUser(_ sender: Any) {
        if validateFields() {
            registerSubscriber = registerViewModel.registerUser(
                name: nameTextField.text!,
                lastName: lastNameTextField.text!,
                email: emailTextField.text!,
                password: passwordTextField.text!
            ).sink(receiveValue: { [weak self] (registerResponse) in
                guard let self = self else { return}
                self.handleRegisterResponse(for: registerResponse)
            })
        }
    }

    // Private
    private func setUpView() {
        let attributedString = NSAttributedString(
            string: loginButton.titleLabel?.text ?? "",
            attributes: [.underlineStyle: 1]
        )

        loginButton.setAttributedTitle(attributedString, for: .normal)
    }

    private func validateFields() -> Bool {
        return true
    }

    private func handleRegisterResponse(for response: RegisterResponse) {
        if response.success {
            let alertController = UIAlertController(title: Constants.successAlertTitle, message: response.message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "A la aplicación.", style: .default) { [weak self] (_) in
                self?.presentMainTabbar()
            }
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: Constants.failAlertTitle, message: response.message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    private func presentMainTabbar() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabbarVC = mainStoryBoard.instantiateViewController(withIdentifier: "mainTabbar") as! UITabBarController
        if let mainWindow = UIApplication.shared.windows.first {
            mainWindow.rootViewController = mainTabbarVC
            mainWindow.makeKeyAndVisible()
        } else {
            fatalError("No Main windown")
        }
    }
}
