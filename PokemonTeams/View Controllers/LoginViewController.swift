//
//  LoginViewController.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import UIKit
import Combine

class LoginViewController: UIViewController {

    // Constants
    enum Constants {
        static let successAlertTitle = "Bienvenido."
        static let failAlertTitle = "Lo sentimos."
    }

    // outlets

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // Properties

    var loginViewModel = LoginViewModel()
    var loginSubscriber: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = "alcantara0729@gmail.com"
        passwordTextField.text = "123456"
        // Do any additional setup after loading the view.
        setUpView()
    }

    private func setUpView() {
        let attributedString = NSAttributedString(
            string: signUpButton.titleLabel?.text ?? "",
            attributes: [.underlineStyle: 1]
        )

        signUpButton.setAttributedTitle(attributedString, for: .normal)
    }

    @IBAction func logIn(_ sender: Any) {
        if validateFields() {
            loginSubscriber = loginViewModel.login(user: emailTextField.text!, password: passwordTextField.text!)
                .sink(receiveValue: { [weak self] (loginResponse) in
                    guard let self = self else {return}
                    self.handleLoginResponse(for: loginResponse)
                })
        }
    }

    private func handleLoginResponse(for response: LoginResponse) {
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

    private func validateFields() -> Bool {
        return true
    }

}
