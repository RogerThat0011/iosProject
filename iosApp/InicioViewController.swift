//
//  InicioViewController.swift
//  iosApp
//
//  Created by Rogelio on 4/19/24.
//

import UIKit
import FirebaseAuth

class InicioViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let correo = Auth.auth().currentUser?.email
        print("Correo del usuario es: \(correo!)")
    }

    
    @IBAction func salir(_ sender: Any) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "login", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
