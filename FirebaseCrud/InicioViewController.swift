//
//  InicioViewController.swift
//  FirebaseCrud
//
//  Created by Jorge Maldonado Borbón on 02/10/17.
//  Copyright © 2017 Jorge Maldonado Borbón. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class InicioViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var cargador: UIActivityIndicatorView!
    
    @IBOutlet weak var juego: UITextField!
    @IBOutlet weak var genero: UITextField!
    @IBOutlet weak var vistaPicker: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    var plataforma:String = ""
    var imagen = UIImage()
    let plataformas = ["PLAYSTATION 4", "XBOX ONE","NINTENTO SWITCH", "PC"]
    var ref:DatabaseReference!
    var idFirebase = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        let correo = Auth.auth().currentUser?.email
        idFirebase = (Auth.auth().currentUser?.uid)!
        print(idFirebase)
        print("El correo electronico del usuario es: \(correo!)")
        ref = Database.database().reference()
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return plataformas[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return plataformas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        plataforma = plataformas[row]
        vistaPicker.text = plataformas[row]
    }


    @IBAction func guardar(_ sender: UIButton) {
            
        let id = ref.childByAutoId().key
            
        let storage = Storage.storage().reference()
        let nombreImagen = UUID()
        let directorio = storage.child("imagenes/\(nombreImagen)")
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        // Utilizamos una imagen por defecto
        if let imagenPorDefecto = UIImage(named: "videogame") {
            if let imageData = UIImagePNGRepresentation(imagenPorDefecto) {
                directorio.putData(imageData, metadata: metaData) { (data, error) in
                    if error == nil {
                        print("cargó la imagen por defecto")
                        self.cargador.stopAnimating()
                        self.cargador.isHidden = true
                        
                        let campos = ["nombre": self.juego.text!,
                                      "genero": self.genero.text!,
                                      "id": id,
                                      "portada": String(describing: directorio)]
                        
                        self.ref.child(self.idFirebase).child(self.plataforma).child(id).setValue(campos)
                        self.cargador.isHidden = false
                        self.cargador.startAnimating()
                        print("guardó")
                        self.limpiar()
                    } else {
                        if let error = error?.localizedDescription {
                            print("error al subir imagen por defecto en firebase", error)
                        } else {
                            print("error en el código")
                        }
                    }
                }
            } else {
                print("No se pudieron obtener los datos de la imagen por defecto.")
            }
        } else {
            print("No se pudo cargar la imagen por defecto.")
        }
    }

    
    @IBAction func salir(_ sender: UIButton) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "login", sender: self)
    }
    func limpiar() {
        juego.text = ""
        genero.text = ""
    }
        
    @IBAction func tomarFoto(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagenTomada = info[UIImagePickerControllerEditedImage] as? UIImage
        imagen = imagenTomada!
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
