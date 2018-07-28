//
//  ViewController.swift
//  Sound Board
//
//  Created by Jon Moon on 26/06/2018.
//  Copyright © 2018 Jon Moon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sounds :[Sound] = []
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try sounds = context.fetch(Sound.fetchRequest())
            tableView.reloadData()
        } catch {}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        do {
            try audioPlayer = AVAudioPlayer(data: sound.audio! as Data)
            audioPlayer?.play()
        } catch {}
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete{
    //            let sound = sounds[indexPath.row]
    //            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //            context.delete(sound)
    //            (UIApplication.shared.delegate as! AppDelegate).saveContext()
    //            do {
    //                try sounds = context.fetch(Sound.fetchRequest())
    //                tableView.reloadData()
    //            } catch {}
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let sound = self.sounds[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(sound)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                try self.sounds = context.fetch(Sound.fetchRequest())
                tableView.reloadData()
            } catch {}
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { (action, indexPath) in
            // share item at indexPath
            let sound = self.sounds[indexPath.row]
            let shareText = sound.name
            
            if let soundFile = sound.audio {
                let vc = UIActivityViewController(activityItems: [shareText, soundFile], applicationActivities: [])
                self.present(vc, animated: true)
            }
        }
            share.backgroundColor = UIColor.blue
            
            return [delete, share]
        }
        
}

