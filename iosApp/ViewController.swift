//
//  ViewController.swift
//  iosApp
//
//  Created by Rogelio on 4/19/24.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

   
    //@IBOutlet weak var control: UISegmentedControl!
    @IBOutlet weak var control: UISegmentedControl!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func entrar(_ sender: UIButton) {
        
        if control.selectedSegmentIndex == 0 {
            iniciarSesion(correo:correo.text!, password:password.text!)
        }else {
            registrarte(correo:correo.text!, password:password.text!)
        }
    }
        
        func iniciarSesion(correo:String, password:String){
            Auth.auth().signIn(withEmail: correo, password: password) { (user, error) in
                if user != nil{
                    self.performSegue(withIdentifier: "Inicio", sender: self)
                }else{
                    if let error = error?.localizedDescription {
                        print("Error SingIn FireBase: ", error)
                }else {
                    print("Error de codigo: ")
                    }
                }
            }
        }
        
        func registrarte(correo:String, password:String){
            Auth.auth().createUser(withEmail: correo, password: password){(user,error) in
                if user != nil {
                    self.performSegue(withIdentifier: "Inicio", sender: self)
                }else {
                    if let error = error?.localizedDescription{
                        print("Error SingUp FireBase: ", error)
                    }else {
                        print("Error de codigo: ")
                    }
                }
            }
        }
    
    

}
