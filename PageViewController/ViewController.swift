//
//  ViewController.swift
//  PageViewController
//
//  Created by Jaedoo Ko on 2020/06/17.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let backgroundColors: [UIColor] = [.green, .blue, .brown, .yellow, .lightGray]

    private let pageViewController = UIPageViewController(transitionStyle: .pageCurl,
                                                          navigationOrientation: .horizontal,
                                                          options: nil)
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .magenta
        pc.currentPageIndicatorTintColor = .black
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPageViewController()
        setPageControl()
    }
    
    private func setPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let firstVC = instantiateViewController(index: 0, color: backgroundColors[0])
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        didMove(toParent: self)
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = backgroundColors.count
        
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func instantiateViewController(index: Int, color: UIColor) -> UIViewController {
        let vc = UIViewController()
        vc.view.tag = index
        vc.view.backgroundColor = color
        return vc
    }
}

extension ViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        let nextIndex = index > 0 ? index - 1 : backgroundColors.count - 1
        let nextVC = instantiateViewController(index: nextIndex, color: backgroundColors[nextIndex])
        return nextVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        
        guard let index = pageViewController.viewControllers?.first?.view.tag else {
            return nil
        }
        let nextIndex = (index + 1) % backgroundColors.count
        let nextVC = instantiateViewController(index: nextIndex, color: backgroundColors[nextIndex])
        return nextVC
    }
}

extension ViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool
    ) {
        guard completed else { return }
        if let vc = pageViewController.viewControllers?.first {
            pageControl.currentPage = vc.view.tag
        }
    }
}
