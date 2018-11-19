//
//  ViewController.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 14/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//


struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

struct unitData {
    var opened = Bool()
    var title = String()
    var data = [String]()
    var isOn = Bool()
    var height = CGFloat()
}


import UIKit

fileprivate var preCollectionLongPressGesture: UILongPressGestureRecognizer!
fileprivate var postCollectionLongPressGesture: UILongPressGestureRecognizer!

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource  {
    
    var tableViewData = [cellData]()        // VÄLIAIKAINEN MALLI
    var selectedUnitsData = [unitData]()    // VÄLIAIKAINEN MALLI
  
    

    
    private let parallaxLayout = ParallaxFlowLayout()
    private let postSnappingLayout = PostSnappingFlowLayout()
    private let preSnappingLayout = PreSnappingFlowLayout()

    @IBOutlet weak var availableUnits: UITableView!
    @IBOutlet weak var unitsAfter: UITableView!
    
    @IBOutlet weak var preCollection: UICollectionView!
    @IBOutlet weak var mainCollection: UICollectionView!
    @IBOutlet weak var postCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createCollectionViews()
        createTableViews()
        
        // VÄLIAIKAINEN MALLI
        tableViewData = [
                cellData(opened: false, title: "eka", sectionData: ["d", "ee"]),
                cellData(opened: false, title: "toinen", sectionData: ["d", "ee","ooo"]),
                cellData(opened: false, title: "kolmas", sectionData: ["d"]),
                cellData(opened: false, title: "neljäs", sectionData: ["d", "ee","rrr", "iiiii"]),
                cellData(opened: false, title: "viides", sectionData: ["d", "ee"])
                    ]
        
      // VÄLIAIKAINEN MALLI
        selectedUnitsData = [
            unitData(opened: false, title: "Delay", data: ["time 0.2, feedback 1.2, isOn true"], isOn: false, height: 90),
                unitData(opened: false, title: "Drive", data: ["value 0.2, gain 2, isOn false"], isOn: true, height: 30)
        
        ]
        
    }


    
     // MARK: TABLEVIEWS
    func createTableViews() {
        availableUnits.delegate = self
        availableUnits.dataSource = self
        unitsAfter.delegate = self
        unitsAfter.dataSource = self
        
        registerTableViewCells()
    }
    
    func registerTableViewCells() {
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        unitsAfter.register(nib, forCellReuseIdentifier: "TableViewCell")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         if tableView == availableUnits {
        return tableViewData.count
         } else {
            // unitsAfter List
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == availableUnits {
            if tableViewData[section].opened == true {
                return tableViewData[section].sectionData.count + 1
            } else {
                return 1
            }
        
         } else {
            // unitsAfter List
            return selectedUnitsData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if tableView == availableUnits {
            let dataIndex = indexPath.row - 1
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
                cell.textLabel?.text = tableViewData[indexPath.section].title
                return cell
            }
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
                cell.textLabel?.text = tableViewData[indexPath.section].sectionData[dataIndex]
                return cell
            }
      
         } else {
            // unitsAfter List
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.title.text = selectedUnitsData[indexPath.row].title
            if selectedUnitsData[indexPath.row].opened == true {
                cell.controllerHeight.constant = selectedUnitsData[indexPath.row].height
            } else {
                cell.controllerHeight.constant = 0
            }
            if selectedUnitsData[indexPath.row].isOn == true {
                cell.onOffButton.setTitle("OFF", for: .normal)
            } else {
                 cell.onOffButton.setTitle("ON", for: .normal)
            }
            
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == availableUnits {
            if indexPath.row == 0 {
                if tableViewData[indexPath.section].opened == true {
                    tableViewData[indexPath.section].opened = false
                    let sections = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(sections, with: .none)
                } else {
                    tableViewData[indexPath.section].opened = true
                    let sections = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(sections, with: .none)
                }
            }
        
        }
        else {
            // unitsAfter List
            if selectedUnitsData[indexPath.row].opened == true {
                selectedUnitsData[indexPath.row].opened = false
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .none)
            }
            else {
                selectedUnitsData[indexPath.row].opened = true
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .none)
            }
        }
    }
    
    

    
    // MARK: COLLECTION VIEWS
    
    func createCollectionViews() {
        preCollection.delegate = self
        postCollection.delegate = self
        mainCollection.delegate = self
        
        preCollection.dataSource = self
        postCollection.dataSource = self
        mainCollection.dataSource = self
        
        preCollection.collectionViewLayout = preSnappingLayout
        postCollection.collectionViewLayout = postSnappingLayout
        mainCollection.collectionViewLayout = parallaxLayout
        
        preCollection.clipsToBounds = false
        postCollection.clipsToBounds = false
        
        registerCollectionViewCells()
        
        
        preCollectionLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handlePreCollectionDrag(gesture:)))
        preCollection.addGestureRecognizer(preCollectionLongPressGesture)
        postCollectionLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handlePostCollectionDrag(gesture:)))
        postCollection.addGestureRecognizer(postCollectionLongPressGesture)
        
    }
    
    
    func registerCollectionViewCells() {
        
        /*
        for pedal in 0..<Effects.selectedEffects.count {
            
            let typeName = Effects.selectedEffects[pedal]
            
            let nib = UINib(nibName: typeName + "CollectionViewCell", bundle: nil)
            audioSignalView.register(nib, forCellWithReuseIdentifier: typeName)
            
        }
        for pedal in 0..<Effects.listOfEffects.count {
            
            let typeName = Effects.listOfEffects[pedal]
            
            let nib = UINib(nibName: typeName + "CollectionViewCell", bundle: nil)
            audioSignalView.register(nib, forCellWithReuseIdentifier: typeName)
        }
        */
        let nib = UINib(nibName: "SoundsCollectionViewCell", bundle: nil)
        postCollection.register(nib, forCellWithReuseIdentifier: "SoundsCollectionViewCell")
        
        let preNib = UINib(nibName: "LastCollectionViewCell", bundle: nil)
        preCollection.register(preNib, forCellWithReuseIdentifier: "LastCollectionViewCell")
        
        let mainNib = UINib(nibName: "DefaultMainCollectionViewCell", bundle: nil)
        mainCollection.register(mainNib, forCellWithReuseIdentifier: "DefaultMainCollectionViewCell")
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
      return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        if collectionView == preCollection {
            print("preCollection")
           itemCount = 4
        }
        else if collectionView == postCollection {
            print("postCollection")
            itemCount = 2
        }
        else if collectionView == mainCollection {
            print("mainCollection")
            itemCount = 2
        }
        print(itemCount)
        return itemCount

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var returnCell = UICollectionViewCell()
        if collectionView == preCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastCollectionViewCell", for: indexPath) as! LastCollectionViewCell
            //cell.addButton.addTarget(self, action: #selector(gotToList), for: .touchUpInside)
            
            returnCell = cell
            
        }
        else if collectionView == postCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoundsCollectionViewCell", for: indexPath) as! SoundsCollectionViewCell
            cell.effectsLabel.text = "iunsn \n onsdonnosnons uhdsu siubsd iuhowe wou\n oisndo on"
            
            returnCell = cell
            
        }
        else if collectionView == mainCollection  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultMainCollectionViewCell", for: indexPath) as! DefaultMainCollectionViewCell
            
            returnCell = cell
        }
        
        return returnCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
       /*
        if collectionView == audioSignalView {
            if indexPath.item == effectCellName.count - 1 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
         */
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        
        /*
        if proposedIndexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {
            return IndexPath(row: proposedIndexPath.row - 1, section: proposedIndexPath.section)
        } else {
            return proposedIndexPath
        }
        
        */
        return proposedIndexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        
        /*
        let removed = effectCellName.remove(at: sourceIndexPath.item)
        effectCellName.insert(removed, at: destinationIndexPath.item)
        
        let removedEffect = effect.remove(at: sourceIndexPath.item)
        effect.insert(removedEffect, at: destinationIndexPath.item)
        
        let removedName = Effects.selectedEffects.remove(at: sourceIndexPath.item)
        Effects.selectedEffects.insert(removedName, at: destinationIndexPath.item)
        
        resetEffectChain()
        
        */
        
        print("Starting Index: \(sourceIndexPath.item)")
        print("Ending Index: \(destinationIndexPath.item)")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == preCollection {
            print("PRE SELECTED CELL:  \(indexPath.item)")
        }
        else if collectionView == postCollection {
            print("POST SELECTED CELL:  \(indexPath.item)")
        }
        else if collectionView == mainCollection {
            print("MAIN SELECTED CELL:  \(indexPath.item)")
        }
        
        
    }
    
    
    @objc func handlePreCollectionDrag(gesture: UILongPressGestureRecognizer) {

        print(gesture)
        
         switch(gesture.state) {
           
        case .began:
            guard let selectedIndexPath = preCollection.indexPathForItem(at: gesture.location(in: preCollection)) else {
                break
            }
            preCollection.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            
            preCollection.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            
        case .ended:
            preCollection.endInteractiveMovement()
          
        default:
            preCollection.cancelInteractiveMovement()
        }
 
    }
    
    @objc func handlePostCollectionDrag(gesture: UILongPressGestureRecognizer) {
        
        print(gesture)
        
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = postCollection.indexPathForItem(at: gesture.location(in: postCollection)) else {
                break
            }
            postCollection.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            
            postCollection.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
          
        case .ended:
            postCollection.endInteractiveMovement()
        default:
            postCollection.cancelInteractiveMovement()
        }
        
    }
    
    
    
    // TODO: drag from pre to post and back???
    /*
    @objc func longPressGestureEnded(recognizer: UILongPressGestureRecognizer) {
        
        let globalLocation = recognizer.location(in: view)
        
        if preCollection.frame.contains(globalLocation) {
            
            //covering PRE collection view
            let point = view.convert(globalLocation, to: preCollection)
            if let indexPath = preCollection.indexPathForItem(at: point) {
                //cell in PRE collection view
                print("\(indexPath.item) at Pre Collection")
            } else {
                //NOT covering any of cells in PRE collection view
            }
            
        } else if postCollection.frame.contains(globalLocation) {
            
            //covering POST collection view
            let point = view.convert(globalLocation, to: postCollection)
            if let indexPath = postCollection.indexPathForItem(at: point) {
                //cell in POST collection view
                print("\(indexPath.item) at Post Collection")
            } else {
                //NOT covering any of cells in POST collection view
            }
            
        } else {
            
            print("Drag is outside both Collections")
            //NOT covering any of collection views
        }
    }
    
    @objc func longPressGestureChanged(recognizer: UILongPressGestureRecognizer) {
        
        let globalLocation = recognizer.location(in: view)
        
        if preCollection.frame.contains(globalLocation) {
            
            //covering PRE collection view
            let point = view.convert(globalLocation, to: preCollection)
            if let indexPath = preCollection.indexPathForItem(at: point) {
                //cell in PRE collection view
                print("\(indexPath.item) at Pre Collection")
            } else {
                //NOT covering any of cells in PRE collection view
            }
            
        } else if postCollection.frame.contains(globalLocation) {
            
            //covering POST collection view
            let point = view.convert(globalLocation, to: postCollection)
            if let indexPath = postCollection.indexPathForItem(at: point) {
                //cell in POST collection view
                print("\(indexPath.item) at Post Collection")
            } else {
                //NOT covering any of cells in POST collection view
            }
            
        } else {
            //NOT covering any of collection views
        }
    }
 */
}

