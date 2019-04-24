//
//  EventsViewController.swift
//  FAMAApp
//
//  Created by João Pedro Aragão on 24/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var blurredBackground: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    
    var currentEventImageView: UIImageView!
    var nextEventImageView: UIImageView!
    
    var events = [String]()
    var currentPresentingIndex = -1
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ArtistTableViewCell", bundle: .main)
        eventsTableView.register(nib, forCellReuseIdentifier: "artistCell")
        eventsTableView.contentInsetAdjustmentBehavior = .never
        eventsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        imagesScrollView.delegate = self
        
        let blur = UIBlurEffect(style: .dark)
        let blurred = UIVisualEffectView(effect: blur)
        blurred.frame = blurredBackground.frame
        blurred.frame.origin = .zero
        blurredBackground.insertSubview(blurred, at: 0)
        
        statusLabel.text = "Apresentando agora"
        eventLabel.text = events.first ?? "Sem apresentações no momento"
        
        currentEventImageView = UIImageView(frame: imagesScrollView.frame)
        currentEventImageView.contentMode = .scaleAspectFill
        currentEventImageView.clipsToBounds = true
        
        nextEventImageView = UIImageView(frame: imagesScrollView.frame)
        nextEventImageView.contentMode = .scaleAspectFill
        nextEventImageView.clipsToBounds = true
        
        let screenWidth = UIScreen.main.bounds.width
        imagesScrollView.contentSize = CGSize(width: screenWidth * 2, height: imagesScrollView.frame.height)
        nextEventImageView.frame.origin.x = screenWidth
        imagesScrollView.addSubview(currentEventImageView)
        imagesScrollView.addSubview(nextEventImageView)
        
        loadJson()
    }
    
    func loadJson() {
        guard let path = Bundle.main.path(forResource: "Events", ofType: "json") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: []) else { return }
        guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] else { return }
        events = jsonResult
        eventsTableView.reloadData()
        reloadImages(currentIndex: 0)
        reloadLabels(page: 0)
    }
    
    func reloadImages(currentIndex: Int) {
        if !(currentIndex >= 0 && currentIndex < events.count) { return }
        currentPresentingIndex = currentIndex
        currentEventImageView.image = UIImage(named: "\(currentIndex + 1)")
        if currentIndex + 2 >= events.count { return }
        nextEventImageView.image = UIImage(named: "\(currentIndex + 2)")
    }
    
    func reloadLabels(page: Int) {
        if page < 0 { return }
        if page == 0 {
            statusLabel.text = "Apresentando agora"
            eventLabel.text = "Atração \(currentPresentingIndex + 1) - \(events[currentPresentingIndex])"
        } else {
            statusLabel.text = "Próxima apresentação"
            if currentPresentingIndex + 1 >= events.count {
                eventLabel.text = "Sem próximas apresentações"
            } else {
                let index = currentPresentingIndex + 1
                eventLabel.text = "Atração \(index + 1) - \(events[index])"
            }
        }
    }
    
    @IBAction func didPageChanged(_ sender: UIPageControl) {
        UIView.animate(withDuration: 0.7, delay: 0, options: .allowUserInteraction, animations: {
            self.reloadLabels(page: sender.currentPage)
            self.imagesScrollView.contentOffset.x = CGFloat(sender.currentPage) * UIScreen.main.bounds.width
        })
    }
    
    @IBAction func vote(_ sender: UIBarButtonItem) {
    }
    
}

extension EventsViewController: UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Todas as apresentações"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 43
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as! ArtistTableViewCell
        cell.selectionStyle = .none
        cell.populate(index: indexPath.item + 1, name: events[indexPath.item])
        let cellHeight = (UIScreen.main.bounds.height - imagesScrollView.frame.height)/3
        let imageViewHeight = cellHeight - 32
        let missingSpace = (imageViewHeight - cell.eventNumberLabel.frame.height - cell.eventNameLabel.frame.height)/2
        cell.eventNumberLabelTopConstraint.constant = cell.eventImageView.frame.origin.y + missingSpace
        cell.eventImageView.layer.cornerRadius = imageViewHeight/2 + 7
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height - imagesScrollView.frame.height)/3
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === imagesScrollView {
            let page = Int(scrollView.contentOffset.x/UIScreen.main.bounds.width)
            UIView.animate(withDuration: 0.7, delay: 0, options: .allowUserInteraction, animations: {
                self.pageControl.currentPage = page
                self.reloadLabels(page: page)
            })
        }
    }
}
