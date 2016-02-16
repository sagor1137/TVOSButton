//
//  ViewController.swift
//  TVOSButtonExample
//
//  Created by Cem Olcay on 11/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit
import TVOSButton

class ViewController: UIViewController {

  @IBOutlet var button: TVOSButton!
  @IBOutlet var toggleButton: TVOSToggleButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Setup button
    button.textLabelText = "TVOSButton"
    button.titleLabelText = "Title"
    button.addTarget(self, action: "tvosButtonPressed", forControlEvents: .PrimaryActionTriggered)

    // Setup toggleButton
    toggleButton.didToggledAction = toggleButtonDidToggledActionHandler
    toggleButton.toggleState = .Waiting(text: "...")
    requestSomething({
      self.toggleButton.toggleState = .On(text: "Add")
    }, failure: {
      self.toggleButton.toggleState = .Off(text: "Remove")
    })
  }

  func toggleButtonDidToggledActionHandler(
    currentState: TVOSToggleButtonState,
    updateNewState: (newState: TVOSToggleButtonState) -> Void) {
      switch currentState {
      case .Waiting(let text):
        toggleButton.textLabelText = text

      case .On(let text):
        toggleButton.textLabelText = text
        updateNewState(newState: .Waiting(text: "Adding"))
        removeSomething({
          updateNewState(newState: .Off(text: "Remove"))
        }, failure: {
          updateNewState(newState: .On(text: "Add"))
        })

      case .Off(let text):
        toggleButton.textLabelText = text
        updateNewState(newState: .Waiting(text: "Removing"))
        addSomethingToServer({
          updateNewState(newState: .On(text: "Add"))
        }, failure: {
          updateNewState(newState: .Off(text: "Remove"))
        })
      }
  }

  // Example request methods for simulate waiting for network

  func addSomethingToServer(success: () -> Void, failure: () -> Void) {
    requestSomething(success, failure: failure)
  }

  func removeSomething(success: () -> Void, failure: () -> Void) {
    requestSomething(success, failure: failure)
  }

  func requestSomething(success: () -> Void, failure: () -> Void) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(0.5 * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), success)
  }

  // Event handler
  func tvosButtonPressed() {
    print("tvos button pressed")
  }
}
