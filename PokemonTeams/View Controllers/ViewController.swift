//
//  ViewController.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import UIKit
import Combine

class ViewController: UIViewController {

    // Constants
    enum Constants {
        static let loginSegueIdentifier = "launchToLoginSegue"
        static let homeSegueIdentifier = "launchToHomeSegue"
    }

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var centerYLogoConstraint: NSLayoutConstraint!

    @Published var didEndAnimation = false
    var animationSubscriber: AnyCancellable?
    var loginViewModel = LoginViewModel()
    var loginSubscriber: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.centerYLogoConstraint.constant = 0.5

        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        } completion: { [weak self] (_) in
            self?.didEndAnimation = true
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationSubscriber = self.$didEndAnimation.sink  { [weak self] (animationEnded) in
            if animationEnded {
                self?.validateLogin()
            }
        }
    }

    private func validateLogin() {
        let keychain = Keychain()
        if let data = keychain.getData(for: Keychain.Constants.userKey) {
            if let user = try? JSONDecoder().decode(User.self, from: data) {
                loginSubscriber = loginViewModel.login(user: user.email, password: user.password)
                    .sink(receiveValue: {[weak self] (response) in
                    guard let self = self else { return }
                    if response.success {
                        self.performSegue(withIdentifier: Constants.homeSegueIdentifier, sender: self)
                    } else {
                        self.performSegue(withIdentifier: Constants.loginSegueIdentifier, sender: self)
                    }
                })
            }
        } else {
            performSegue(withIdentifier: Constants.loginSegueIdentifier, sender: self)
        }
    }
}
