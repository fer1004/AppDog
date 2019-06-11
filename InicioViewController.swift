//
//  InicioViewController.swift
//  doghause
//
//  Created by MacBook on 5/3/19.
//  Copyright © 2019 UNAM. All rights reserved.
//

import UIKit
import FirebaseAuth

class InicioViewController: UIViewController {
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var contraseña: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isLogged()
    }
    @IBAction func Iniciarsecion(_ sender: Any) {

        
        guard let userEmail = correo.text,userEmail != "", let userPass = contraseña.text, userPass != "" else {
            return
        }
        
        Auth.auth().signIn(withEmail: userEmail, password: userPass) { (user, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            if let user = user {
                self.performSegue(withIdentifier: "passLogin", sender: self)
            }
        }
    }
    
    func isLogged(){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil{
                print("No esta loggeado")
            }else{
                print("Si esta loggeado")
                self.performSegue(withIdentifier: "passLogin", sender: self)
            }
        }
    }
    
}
