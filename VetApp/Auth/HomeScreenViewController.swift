//
//  HomeScreenViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 15.12.2019.
//  Copyright © 2019 Artemiy Platonov. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var yourImageView: UIImageView!

    @IBOutlet weak var logo: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let maskLayer = CALayer()
        let mask = UIImage(named: "mask")
        maskLayer.contents = mask?.cgImage!
        maskLayer.frame = yourImageView.bounds
        yourImageView.layer.mask = maskLayer
        //self.navigationController?.navigationBar.isHidden = true
        //self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setLogo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }
    
    func setLogo() {
        let logoImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "VetApp.png").stroked())
        let backgroundView: UIView = UIView(frame: logo.bounds)
        backgroundView.addGradient(from: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), to: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        logo.addSubview(backgroundView)
        logo.addSubview(logoImage)
        logoImage.center = CGPoint(x: logo.frame.size.width  / 2,
        y: logo.frame.size.height / 2)
        logo.layer.borderWidth = 2
        logo.layer.borderColor = UIColor.white.cgColor
        logo.layer.cornerRadius = logo.frame.height / 2
        logo.clipsToBounds = true

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
