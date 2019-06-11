//
//  DatosPerrosTableViewController.swift
//  doghause
//
//  Created by MacBook on 5/23/19.
//  Copyright © 2019 UNAM. All rights reserved.
//

import UIKit
import Firebase

class DatosTableViewController: UITableViewController, UISearchBarDelegate{
    
    var perritos: [mascota] = []
    var backUpperritos: [mascota] = []
    
    var ref: DocumentReference!
    var getRef: Firestore!
    
    
    @IBOutlet var buscador: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRef = Firestore.firestore()
        //buscador.delegate = self as UISearchBarDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getperrito()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perritos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        let perrito = perritos[indexPath.row]
        
        cell.textLabel!.text = perrito.nombre
        cell.detailTextLabel?.text = perrito.sexo
        
        return cell
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editView"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let editView = segue.destination as! EditViewController
                editView.perrito = perritos [indexPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Borrar") { (action, indexPath) in
            let mascota: mascota!
            mascota = self.perritos [indexPath.row]
            self.getRef.collection("mascotas").document(mascota.id!).delete()
        }
        
        return [delete]
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            perritos = backUpperritos
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
            return
        }
        
        perritos = backUpperritos.filter({ (perrito) -> Bool in
            (perrito.nombre?.lowercased().contains(searchText.lowercased()))!
        })
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    
    func getperrito(){
        
        getRef.collection("mascotas").addSnapshotListener { (querySnapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                self.perritos.removeAll()
                for document in querySnapshot!.documents{
                    let values = document.data()
                    let id = document.documentID
                    let nombre = values["nombre"] as? String ?? "Nombre"
                    let sexo = values["sexo"] as? String ?? "falta llenar campo"
                    let subir = mascota(id: id, sexo: sexo, nombre: nombre)
                    self.perritos.append(subir)
                }
                self.backUpperritos = self.perritos
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func regresar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
