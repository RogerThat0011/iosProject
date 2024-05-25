//
//  ViewController.swift
//  FirebaseCrud
//
//  Created by Jorge Maldonado Borbón on 02/10/17.
//  Copyright © 2017 Jorge Maldonado Borbón. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {
    @IBOutlet weak var control: UISegmentedControl!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
    }

    @IBAction func entrar(_ sender: UIButton) {
        
        if control.selectedSegmentIndex == 0 {
            iniciarSesion(correo: correo.text!, password: password.text!)
        }else{
            registrarse(correo: correo.text!, password: password.text!)
        }
        
    }
    
    func iniciarSesion(correo:String, password:String){
        Auth.auth().signIn(withEmail: correo, password: password) { (user, error) in
            
            if user != nil {
                self.performSegue(withIdentifier: "inicio", sender: self)
            }else{
                if let error = error?.localizedDescription {
                    print("error firebase de inciar sesion", error)
                }else{
                    print("error de codigo")
                }
            }
            
        }
    }
    
    func registrarse(correo:String, password:String){
        Auth.auth().createUser(withEmail: correo, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "inicio", sender: self)
            }else{
                if let error = error?.localizedDescription {
                    print("error firebase de registro", error)
                }else{
                    print("error de codigo")
                }
            }
        }
    }
    
    func login(){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil{
                print("no estamos logeados")
            }else{
                self.performSegue(withIdentifier: "inicio", sender: self)
                
            }
        }
    }
    
    
    
    
    
    
    
  
}

