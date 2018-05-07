//
//  RunningTimerController.swift
//  MyAppV2
//
//  Created by Joffrey Fortin on 07/05/2018.
//  Copyright © 2018 Joffrey Fortin. All rights reserved.
//

import UIKit

class RunningTimerController: UIViewController {
    
    var shapeLayer = CAShapeLayer()
    var timer: Timer?
    var timerValue: CGFloat = 30.00
    lazy var count = self.timerValue
    
    let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Temps restant".uppercased()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textAlignment = .center
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("stop", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(handleStop), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 0.0
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        return button
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ 30 seconds", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(handlePlus), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 0.0
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        return button
    }()
 
    
    @objc private func handleStop() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handlePlus() {
        timerValue += 30
        count += 30
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupObservers()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func handleTimer() {
        
        let percentage = count / CGFloat(timerValue)
        
        shapeLayer.strokeEnd = 1 - percentage
        
        let seconds: Int = Int(count + 1) % 60
        let minutes: Int = (Int(count + 1) / 60) % 60
        
        if minutes == 0 {
            timeLabel.text = "\(seconds)"
        } else if minutes == 0 && seconds < 10 {
            timeLabel.text = String(format: "%01d", seconds)
        } else {
            timeLabel.text = String(format: "%01d:%02d", minutes, seconds)
        }
        
        if count <= 0 && shapeLayer.strokeEnd >= 1.0 {
            timer?.invalidate()
            
            dismiss(animated: true, completion: nil)
            
            
            // send notification and dismiss timer from view
        } else {
            count -= 0.01
        }
    }
    
    
    
    func setupUI() {
        
        setupCircleLayers()
        
        view.backgroundColor = .white

        
        [timeLabel, remainingTimeLabel, stopButton, plusButton].forEach { view.addSubview($0) }

        
        NSLayoutConstraint.activate([timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     remainingTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     ])
        
        remainingTimeLabel.anchor(top: nil, left: nil, bottom: timeLabel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 20)
        
        stopButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: view.frame.width / 1.5, height: 50)
        stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        plusButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width / 3, height: 50)
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func setupCircleLayers() {
        
        let shapeRadius: CGFloat = 130
        let lineWidth: CGFloat = 25
        
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear, radius: shapeRadius, lineWidth: lineWidth)
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        _ = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .black, radius: (shapeRadius - lineWidth / 2) , lineWidth: 0)
    }
    
    func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor, radius: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = lineWidth
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.position = view.center
        view.layer.addSublayer(layer)
        return layer
    }
    
}
