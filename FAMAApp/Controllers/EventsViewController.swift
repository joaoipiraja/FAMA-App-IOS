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
    
    var artists = [Artist]()
    
    var currentArtist: Artist?
    var reloadTable = 0
    var cellHeight: CGFloat = 100
    var tableOffset: [CGFloat] = []
    
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
        eventsTableView.layer.masksToBounds = true
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        imagesScrollView.delegate = self
        
        statusLabel.text = "Apresentando agora"
        eventLabel.text = artists.first?.eventName ?? "Sem apresentações no momento"
        
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
        guard let path = Bundle.main.path(forResource: "Artists", ofType: "json") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: []) else { return }
        guard let artists = try? JSONDecoder().decode([Artist].self, from: data) else { return }
        self.artists = artists
        self.currentArtist = artists[4]
        self.eventsTableView.reloadData()
        self.reloadImages()
        self.reloadLabels(page: 0)
    }
    
    func reloadImages() {
        if let artist = currentArtist {
            currentEventImageView.image = UIImage(named: "\(artist.number)")
            nextEventImageView.image = UIImage(named: "\(artist.number + 1)")
        } else if let first = artists.first {
            nextEventImageView.image = UIImage(named: "\(first.number)")
        }
    }
    
    func reloadLabels(page: Int) {
        if page < 0 { return }
        if page == 0 {
            statusLabel.text = "Apresentando agora"
            if let artist = currentArtist {
                eventLabel.text = artist.eventName
            } else {
                eventLabel.text = "Sem apresentações no momento"
            }
        } else {
            statusLabel.text = "Próxima apresentação"
            if let artist = currentArtist {
                if artist.number == artists.count {
                    eventLabel.text = "Sem apresentações futuras"
                } else {
                    eventLabel.text = artists[artist.number].eventName
                }
            } else {
                eventLabel.text = artists.first?.eventName
            }
        }
    }
    
    @IBAction func didPageChanged(_ sender: UIPageControl) {
        UIView.animate(withDuration: 0.7, delay: 0, options: [.allowUserInteraction, .showHideTransitionViews], animations: {
            self.reloadLabels(page: sender.currentPage)
            self.imagesScrollView.contentOffset.x = CGFloat(sender.currentPage) * UIScreen.main.bounds.width
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanQrCode" {
            let destination = segue.destination as? QrCodeScannerViewController
            destination?.delegate = self
        }
        if segue.identifier == "vote" {
            let destination = segue.destination as? VoteViewController
            destination?.artist = currentArtist
        }
    }
    
    @IBAction func scanQrCode(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "scanQrCode", sender: currentArtist)
    }
    
}

extension EventsViewController: QrCodeScannerDelegate {
    func didScan(with state: QrCodeScannerStates) {
        switch state {
        case .success:
            performSegue(withIdentifier: "vote", sender: currentArtist)
        case .failure:
            break
        }
    }
}

extension EventsViewController: UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Todas as atrações"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(rgb: 0xE48A41)

        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        headerView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false

        headerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true

        label.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        label.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.5).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 43
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as! ArtistTableViewCell
        cell.selectionStyle = .none
        cell.populate(artist: artists[indexPath.item])
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
            let isGoingUp = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
            
            var offset: CGFloat = 0
            tableOffset.forEach { offset += $0 }
            
            if scrollView.frame.origin.y > minY && isGoingUp {
                animateTableRadius(with: 20)
                offset += scrollView.contentOffset.y
                tableOffset.append(scrollView.contentOffset.y)
                scrollView.contentOffset.y = 0
            }
            if scrollView.frame.origin.y >= minY && !isGoingUp && scrollView.contentOffset.y <= 0 {
                offset += scrollView.contentOffset.y
                tableOffset.removeAll()
                tableOffset.append(offset)
            }
            if scrollView.frame.origin.y >= maxY && !isGoingUp && scrollView.contentOffset.y <= 0 {
                animateTableRadius(with: 0)
                offset = 0
                tableOffset.removeAll()
                return
            }
            if scrollView.frame.origin.y >= minY && scrollView.frame.origin.y < maxY && !isGoingUp && scrollView.contentOffset.y <= 0 {
                scrollView.contentOffset.y = 0
            }
            
            var ratio = offset/maxY
            if ratio > 1 { ratio = 1 }
            if ratio < 0 { ratio = 0 }
            let newY = maxY * (1 - ratio)
            if newY <= minY && eventsTableView.frame.origin.y == minY { return }
            animateScroll({ self.eventsTableView.frame.origin.y = newY > minY ? newY : minY })
        }
    }
    
    func animateScroll(_ animations: @escaping (() -> Void), _ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            animations()
        }) { flag in
            self.eventsTableView.frame.size.height = UIScreen.main.bounds.height - self.eventsTableView.frame.origin.y
            self.view.layoutIfNeeded()
            completion?(flag)
        }
    }
    
    func animateTableRadius(with radius: CGFloat) {
        UIView.animate(withDuration: 1.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.allowUserInteraction, .showHideTransitionViews], animations: {
            self.eventsTableView.layer.cornerRadius = radius
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === imagesScrollView {
            let page = Int(scrollView.contentOffset.x/UIScreen.main.bounds.width)
            self.reloadLabels(page: page)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                self.pageControl.currentPage = page
            })
        }
    }
}
