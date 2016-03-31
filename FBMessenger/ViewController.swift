//
//  ViewController.swift
//  FBMessenger
//
//  Created by heron on 3/31/16.
//  Copyright © 2016 Heron Yang. All rights reserved.
//

import Cocoa
import WebKit

extension String {
	subscript (i: Int) -> Character {
		return self[self.startIndex.advancedBy(i)]
	}
}

class ViewController: NSViewController, WebUIDelegate {

	@IBOutlet weak var webView: WebView!
	
	private var windowTitle: String?;
	private var latestNotification: String?;
	
	override func viewDidLoad() {
		super.viewDidLoad();
		let url = NSURL(string: "https://messenger.com")
		let request = NSURLRequest(URL: url!);
		webView.preferences.setValue(true, forKey: "developerExtrasEnabled");
		webView.applicationNameForUserAgent = "Safari/601.2.7";
		webView.mainFrameURL = "https://messenger.com";

		webView.mainFrame.loadRequest(request);
		
		setupUpdateTitleTimer();
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	func setupUpdateTitleTimer() {
		NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.updateWindowTitle), userInfo: nil, repeats: true);
	}
	
	func updateWindowTitle() {
		if let windowTitle = webView.stringByEvaluatingJavaScriptFromString("document.title") {
			handleDifferentTitle(windowTitle);
		} else {
			self.view.window!.title = "Messenger";
		}
	}
	
	func handleDifferentTitle(title: String) {
		if title == "Messenger" || title == "" {
			self.view.window!.title = "Heron's Messenger";
		} else if (isTitleContainsUnreadCount(title)) {
			self.view.window!.title = title;
		} else {
			self.view.window!.title = title;
			showNotificationIfNew(title);
		}
	}
	
	func isTitleContainsUnreadCount(title: String)-> Bool {
		if title[0] == "(" {
			return true;
		} else {
			return false;
		}
	}
	
	func showNotificationIfNew(content: String) {
		if latestNotification != content {
			showNotification(content);
			latestNotification = content;
		}
	}

	func webView(sender: WebView!, runOpenPanelForFileButtonWithResultListener resultListener: WebOpenPanelResultListener!, allowMultipleFiles: Bool) {
		let openDialog = NSOpenPanel()
		if (openDialog.runModal() == NSFileHandlingPanelOKButton) {
			let fileName: String = (openDialog.URL?.path)!
			resultListener.chooseFilename(fileName);
		}
	}
	
	func showNotification(content: String) -> Void {
		let notification = NSUserNotification();
		notification.title = content;
		notification.informativeText = "Heron's Messenger";
		notification.soundName = NSUserNotificationDefaultSoundName;
		NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification);
	}

}

