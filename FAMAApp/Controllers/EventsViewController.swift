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
    var reloadTable = 0
    var cellHeight: CGFloat = 100
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cellHeight = (UIScreen.main.bounds.height - imagesScrollView.frame.height)/2.5
        if reloadTable < 2 {
            eventsTableView.reloadData()
            reloadTable += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ArtistTableViewCell", bundle: .main)
        eventsTableView.register(nib, forCellReuseIdentifier: "artistCell")
        eventsTableView.contentInsetAdjustmentBehavior = .never
        eventsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        imagesScrollView.delegate = self
        
        statusLabel.text = "Apresentando agora"
        eventLabel.text = events.first ?? "Sem apresentações no momento"
        
        let imageFrame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.65))
        currentEventImageView = UIImageView(frame: imageFrame)
        currentEventImageView.contentMode = .scaleAspectFill
        currentEventImageView.clipsToBounds = true
        currentEventImageView.backgroundColor = .clear
        
        nextEventImageView = UIImageView(frame: imageFrame)
        nextEventImageView.contentMode = .scaleAspectFill
        nextEventImageView.clipsToBounds = true
        nextEventImageView.backgroundColor = .clear
        
        let blur = UIBlurEffect(style: .dark)
        let blurred = UIVisualEffectView(effect: blur)
        let blurFrame = CGRect(origin: .zero, size: CGSize(width: imageFrame.width, height: imageFrame.height * 0.23))
        blurred.frame = blurFrame
        blurredBackground.insertSubview(blurred, at: 0)
        
        imagesScrollView.contentSize = CGSize(width: imageFrame.width * 2, height: imageFrame.height)
        nextEventImageView.frame.origin.x = imageFrame.width
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
        reloadImages(currentIndex: -1)
        reloadLabels(page: 0)
    }
    
    func reloadImages(currentIndex: Int) {
        if currentIndex >= events.count { return }
        currentPresentingIndex = currentIndex < 0 ? -1 : currentIndex
        currentEventImageView.image = UIImage(named: "\(currentIndex + 1)")
        if currentIndex + 2 >= events.count { return }
        nextEventImageView.image = UIImage(named: "\(currentIndex + 2)")
    }
    
    func reloadLabels(page: Int) {
        if page < 0 { return }
        if page == 0 {
            statusLabel.text = "Apresentando agora"
            if currentPresentingIndex == -1 {
                eventLabel.text = "Sem apresentações no momento"
            } else {
                eventLabel.text = "Atração \(currentPresentingIndex + 1) - \(events[currentPresentingIndex])"
            }
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
    
    @IBAction func scanQrCode(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "scanQrCode", sender: nil)
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
        let imageViewHeight = cellHeight - 16
        let missingSpace = (imageViewHeight - cell.eventNumberLabel.frame.height - cell.eventNameLabel.frame.height)/2
        cell.eventNumberLabelTopConstraint.constant = cell.eventImageView.frame.origin.y + missingSpace
        cell.eventImageView.layer.cornerRadius = imageViewHeight/2
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 && scrollView === imagesScrollView {
            scrollView.contentOffset.y = 0
        }
                
        if scrollView === eventsTableView {
            let minY = UIApplication.shared.statusBarFrame.height
            let maxY = imagesScrollView.frame.height
            var ratio = scrollView.contentOffset.y/maxY
            if ratio > 1 { ratio = 1 }
            if ratio < 0 { ratio = 0 }
            let newY = maxY * (1 - ratio)
            if newY <= minY && eventsTableView.frame.origin.y == minY { return }
            eventsTableView.frame.origin.y = newY > minY ? newY : minY
            eventsTableView.frame.size.height = UIScreen.main.bounds.height - newY
            view.layoutIfNeeded()
        }
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
