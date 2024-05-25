//
//  Juegos.swift
//  FirebaseCrud
//
//  Created by Jorge Maldonado Borbón on 03/10/17.
//  Copyright © 2017 Jorge Maldonado Borbón. All rights reserved.
//

import Foundation
import UIKit
class Juegos {
    
    var nombre:String?
    var genero:String?
    var id : String?
    var imagen : String?

    init(nombre:String?, genero:String?, id: String?, imagen:String?) {
        self.nombre = nombre
        self.genero = genero
        self.id = id
        self.imagen = imagen
    }
    
}
