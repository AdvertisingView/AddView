//
//  ErrorView.swift
//  OlimpicFind
//
//  Created by Senior Developer on 21.06.2023.
//
import UIKit
import Architecture

final class ErrorView: UIView, ViewProtocol {
    
    struct ViewProperties {
        var isHidden: Bool
        var didTapMain: ClosureEmpty
        var didTapSupport: ClosureEmpty
    }
    var viewProperties: ViewProperties?
    
    @IBOutlet weak private var errorImageView: UIImageView!
	@IBOutlet weak private var descriptionLabel: UILabel!
	@IBOutlet weak private var supportButton: UIButton!
	@IBOutlet weak private var mainScreenButton: UIButton!
    
    func update(with viewProperties: ViewProperties?) {
        guard let viewProperties = viewProperties else { return }
        self.viewProperties = viewProperties
        self.isHidden = viewProperties.isHidden
		setData()
    }
    
    func create(with viewProperties: ViewProperties?) {
        guard let viewProperties = viewProperties else { return }
        self.viewProperties = viewProperties
        self.isHidden = viewProperties.isHidden
        setData()
    }
    
    //MARK: -
    @IBAction func supportButton(button: UIButton){
        viewProperties?.didTapSupport()
    }
    
    @IBAction func mainGoButton(button: UIButton){
        viewProperties?.didTapMain()
    }
	
	private func setData(){
		descriptionLabel.text = "errorDescription".localizable()
		supportButton.setTitle("support".localizable(), for: .normal)
		mainScreenButton.setTitle("buttonTitle".localizable(), for: .normal)
		errorImageView.image = UIImage(named: "errorImage", in: Bundle.module, compatibleWith: nil)
		mainScreenButton.layer.cornerRadius = 4
		mainScreenButton.clipsToBounds = true
	}
}
