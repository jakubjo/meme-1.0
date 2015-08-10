//
//  ViewController.swift
//  MemeMe
//
//  Created by Jakub on 02.08.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import UIKit

class SentMemesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createNewMeme(sender: AnyObject?) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MemeEditorViewController = storyboard.instantiateViewControllerWithIdentifier("MemeEditorView") as! MemeEditorViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }

}

