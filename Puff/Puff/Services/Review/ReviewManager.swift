//
//  ReviewManager.swift
//  Puff
//
//  Created by Никита Куприянов on 04.10.2024.
//

import SwiftUI

final class ReviewManager: ObservableObject {
    @AppStorage("hasSeenReviewRequestAfterFirstSuccessDay") var hasSeenReviewRequestAfterFirstSuccessDay: Bool = false
    @AppStorage("hasSeenReviewRequestAfterFirstSuccessDay") var hasSeenReviewRequestOn5Day: Bool = false
}
