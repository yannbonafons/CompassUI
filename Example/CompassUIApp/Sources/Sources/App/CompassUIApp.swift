//
//  ExampleNavigationApp.swift
//  CompassUI
//
//  Created by Yann Bonafons on 15/03/2026.
//

import SwiftUI
import CompassUI

@main
struct ExampleNavigationApp: App {
    /// Drives the onboarding, which has no tab bar.
    @State private var appCoordinatorLite = AppCoordinatorLite()
    /// Created when the onboarding ends; its presence swaps the onboarding for the tab bar.
    @State private var appCoordinator: AppCoordinator?

    var body: some Scene {
        WindowGroup {
            rootView
        }
    }

    private var rootView: some View {
        Group {
            if let appCoordinator {
                MainTabView(appCoordinator: appCoordinator)
            } else {
                onboardingView
            }
        }
        // Sheets and alerts are attached once: the tab-enabled coordinator reuses the lite one's coordinators.
        .stackableSheetsAndAlert(sheetCoordinator: appCoordinatorLite.sheetCoordinator,
                                 alertCoordinator: appCoordinatorLite.alertCoordinator)
    }

    private var onboardingView: some View {
        NavigationContainerView { navigationCoordinator in
            OnboardingBuilder.createView(
                with: OnboardingPayload(context: RouterContextLite(navigationCoordinator: navigationCoordinator,
                                                                   globalContext: appCoordinatorLite.globalContext),
                                        onCompleted: finishOnboarding)
            )
        }
    }

    private func finishOnboarding() {
        withAnimation {
            appCoordinator = AppCoordinator(from: appCoordinatorLite,
                                            selectedTab: TabItem.home,
                                            possibleTabs: TabItem.allCases)
        }
    }
}
