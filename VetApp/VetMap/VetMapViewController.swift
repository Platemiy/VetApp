//
//  VetMapViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 25.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit
import CoreData
import YandexMapKit
import YandexMapKitSearch

class VetMapViewController: UIViewController {
    
  
    @IBOutlet weak var mapView: YMKMapView!
    var searchManager: YMKSearchManager?
    var searchSession: YMKSearchSession?
    private var circleMapObjectTapListener: YMKMapObjectTapListener!
    lazy var userLocationLayer = YMKMapKit.sharedInstance().createUserLocationLayer(with: mapView.mapWindow)

    var isLaunched = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let scale = UIScreen.main.scale

        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = false
        userLocationLayer.setObjectListenerWith(self)
        //userLocationLayer.resetAnchor()
    
        userLocationLayer.setAnchorWithAnchorNormal(CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.5 * mapView.frame.size.height * scale),
        anchorCourse: CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.83 * mapView.frame.size.height * scale))
        
        
            searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
        
        searchManager = YMKSearch.sharedInstance()?.createSearchManager(with: .combined)
        mapView.mapWindow.map.addCameraListener(with: self)

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    class ObjectUserData {
        let phone: String
        let name: String
        let description: String
        init(phone: String, name: String, description: String) {
            self.phone = phone
            self.name = name
            self.description = description
        }
    }

    
}



