//
//  FilterViewController.swift
//  FilterRealmApp
//
//  Created by Maxim Lyashenko on 17.11.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


class FilterViewController: SUViewController {

    var presenter: FilterPresenter?
    var components: VFComponents?
    
    var defaultFilter: VFFilter?
    var customFilter: VFFilter?
    var currentFilter: VFFilter?
    
    var isCustom: Bool = false
    let menuHeight: CGFloat = 230.0
    var isPresenting = false
        
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var backdropView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    var filterName: String {
        guard let name = presenter?.requestFilterName() else {
            return ""
        }
        
        return name
    }
    
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
        presenter?.requestComponents()
    }
    
    //MARK: configuration
    private func setup() {
        configurePickerView()
        configureMenuView()
    }
    
    private func configureMenuView() {
        backdropView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FilterViewController.handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
    }
    
    private func configurePickerView() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        presenter?.dismiss(animated: true, needUpdate: false)
    }

    // helper
    
    var sectionCount: Int {
            guard let components = components else {
                return 0
            }
            return components.count
    }
    
    // presenter
    
    func updatedCompanents(components: VFComponents, and filter: VFFilter, customFilter: VFFilter, custom: Bool) {
        self.components = components
        self.defaultFilter = filter
        self.customFilter = customFilter
        self.isCustom = custom
        
        pickerView.reloadAllComponents()
        
        if isCustom == true {
            self.currentFilter = customFilter
            selectRows(filter: self.customFilter)
            
        } else {
             self.currentFilter = filter
            selectRows(filter: self.defaultFilter)
        }
        
        updateUI()
    }
    
    
    //MARK: action
    @IBAction func dismissAction(_ sender: Any) {
        presenter?.dismiss(animated: true, needUpdate: false)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        self.currentFilter = defaultFilter
        
        selectRows(filter: self.currentFilter)
        updateUI()
        
    }
    
    @IBAction func applyAction(_ sender: Any) {
        guard let currentFilter = currentFilter else {
            return
        }
        presenter?.applyFilter(customFilter: currentFilter)
    }
}


// MARK: - PickerViewDelegate
extension FilterViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return sectionCount
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        guard let components = components else {
            return 0
        }
        return components.countItems(by: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let components = components else {
            return ""
        }
        return components.item(by: component, and: row)
    }
}


//MARK: - UIPickerViewDelegate
extension FilterViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentFilter?.update(value: row, by: component)
        updateUI()
    }
}


// MARK: - UI Helper
extension FilterViewController {
    
    func updateUI() {
        updateResetButton()
        updateApplyButton()
    }
    
    func updateApplyButton()  {

        applyButton.isEnabled = false
        
        if currentFilter == customFilter && isCustom == true {
            applyButton.isEnabled = false
        } else if currentFilter == defaultFilter && isCustom == false {
            applyButton.isEnabled = false
        } else {
            applyButton.isEnabled = true
        }
    }
    
    func updateResetButton()  {
        
        if isCustom == true {
            if  currentFilter != customFilter  && currentFilter != defaultFilter {
                resetButton.isEnabled = true
            } else if currentFilter != defaultFilter {
                resetButton.isEnabled = true
            } else {
                resetButton.isEnabled = false
            }
        } else {
            if currentFilter != defaultFilter {
                resetButton.isEnabled = true
            } else {
                resetButton.isEnabled = false
            }
        }
    }
}


// MARK: - ViewModel Helper

extension FilterViewController {
    
    func selectRows(filter: VFFilter?) {
        guard let filter = filter else {
            return
        }
        
        for (num, item) in filter.selected.enumerated() {
            pickerView.selectRow(item, inComponent: num, animated: true)

        }
    }
}


// MARK: - Transitioning Delegate

extension FilterViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            menuView.frame.origin.y = self.view.frame.size.height - menuHeight
            
            menuView.frame.origin.y += menuHeight
            backdropView.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}



