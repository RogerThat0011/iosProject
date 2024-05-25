//
//  VistaViewController.swift
//  FirebaseCrud
//
//  Created by Jorge Maldonado Borbón on 03/10/17.
//  Copyright © 2017 Jorge Maldonado Borbón. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
class VistaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabla: UITableView!
    
    @IBOutlet weak var control: UISegmentedControl!
    var listaJuegos = [Juegos]()
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    var consola = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        
        ref = Database.database().reference()
        
        plataformas(plat: "PLAYSTATION 4")
        
        

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaJuegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Celda
        let juego : Juegos
        juego = listaJuegos[indexPath.row]
        cell.nombreFirebase.text = juego.nombre
        cell.generoFirebase.text = juego.genero
        if let urlFoto = juego.imagen {
            Storage.storage().reference(forURL: urlFoto).getData(maxSize: 5 * 512 * 512, completion: { (data, error) in
                if let error = error?.localizedDescription {
                    print("fallo al traer imagenes", error)
                }else {
                    cell.imagenFirebase.image = UIImage(data: data!)
                    cell.imagenFirebase.layer.masksToBounds = false
                    cell.imagenFirebase.layer.cornerRadius = cell.imagenFirebase.frame.height/2
                    cell.imagenFirebase.clipsToBounds = true
                    cell.imagenFirebase.layer.borderWidth = 2
                    self.tabla.reloadData()
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar" {
            if let id = tabla.indexPathForSelectedRow {
                let fila = listaJuegos[id.row]
                let destino = segue.destination as! EditarViewController
                destino.editarJuegos = fila
                destino.plataforma = consola
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let borrar = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexPath) in
            let juego : Juegos
            juego = self.listaJuegos[indexPath.row]
            let id = juego.id
            let url = juego.imagen
            let idFirebase = (Auth.auth().currentUser?.uid)!
            self.ref.child(idFirebase).child(self.consola).child(id!).setValue(nil)
            
            let borrarImagen = Storage.storage().reference(forURL: url!)
            borrarImagen.delete(completion: nil)
        }
        return [borrar]
    }
    
    
    @IBAction func atras(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
   
    
    @IBAction func controlButton(_ sender: Any) {
        
        if control.selectedSegmentIndex == 0 {
            plataformas(plat: "PLAYSTATION 4")
            consola = "PLAYSTATION 4"
        } else if control.selectedSegmentIndex == 1 {
            plataformas(plat: "XBOX ONE")
            consola = "XBOX ONE"
        } else if control.selectedSegmentIndex == 2 {
            plataformas(plat: "NINTENTO SWITCH")
            consola = "NINTENTO SWITCH"
        } else {
            plataformas(plat: "PC")
            consola = "PC"
           
        }
        
    }
    
    func plataformas(plat: String){
        guard let idFirebase = Auth.auth().currentUser?.uid else {
            return
        }
        handle = ref.child(idFirebase).child(plat).observe(DataEventType.value, with: { (snapshot) in
            
            self.listaJuegos.removeAll()
            
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let valores = item.value as? [String:AnyObject]
                let nombre = valores!["nombre"] as? String
                let genero = valores!["genero"] as? String
                let id = valores!["id"] as? String
                let url = valores!["portada"] as? String
                
                
                let juegos = Juegos(nombre: nombre, genero: genero, id: id, imagen: url)
                self.listaJuegos.append(juegos)
                
            }
            self.tabla.reloadData()
            
        })
        consola = "PLAYSTATION 4"
        
    }
    
    
    
}
