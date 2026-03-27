//
//  RouterContext.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 27/03/2026.
//

public struct RouterContext: Hashable {
    public let navigationCoordinator: NavigationCoordinator
    public let sheetCoordinator: SheetCoordinator
    public let alertCoordinator: AlertCoordinator
    public let tabCoordinator: TabCoordinator

    public init(navigationCoordinator: NavigationCoordinator,
                sheetCoordinator: SheetCoordinator,
                alertCoordinator: AlertCoordinator,
                tabCoordinator: TabCoordinator) {
        self.navigationCoordinator = navigationCoordinator
        self.sheetCoordinator = sheetCoordinator
        self.alertCoordinator = alertCoordinator
        self.tabCoordinator = tabCoordinator
    }

    public static var mockValue: RouterContext {
        enum MockTable: TabRoute, CaseIterable {
            case tab
        }
        return RouterContext(
            navigationCoordinator: NavigationCoordinator(),
            sheetCoordinator: SheetCoordinator(),
            alertCoordinator: AlertCoordinator(),
            tabCoordinator: TabCoordinator(selectedTab: MockTable.tab.erased(),
                                           possibleTabs: MockTable.allCases.map({ $0.erased() }))
        )
    }
}
