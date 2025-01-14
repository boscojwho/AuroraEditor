//
//  AuroraCommandBroadcaster.swift
//  Aurora Editor
//
//  Created by TAY KAI QUAN on 30/10/22.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import Foundation
import Combine
import OSLog

/// Class that manages a broadcaster.
/// The broadcaster is a publisher used to broadcast a command to any subscribers of
/// ``broadcaster``. Those subscribers can then act on the information provided.
///
/// To create a subscriber to ``broadcaster``, use the following code,
/// where `cancelables` is an instance of `Set<AnyCancellable>`:
/// ```
/// workspace.broadcaster.broadcaster.broadcaster.sink { command in
///     if command["name"] == "myCommand" {
///         // do something with the command
///     }
/// }
/// .store(in: &cancelables)
/// ```
/// **Remember to cancel the sink on deinit or view dissapear**
/// ```
/// cancelables.forEach({ $0.cancel() })
/// ```
///
/// For example, in a `View`:
/// ```swift
/// @EnvironmentObject var workspace: WorkspaceDocument
/// @State var cancelables: Set<AnyCancellable> = .init()
///
/// var body: some View {
///     VStack { /*your view here*/ }
///     // this code does not need to go on a VStack,
///     // just put it somewhere in your body.
///     // this cannot occur in the init function
///     // as workspace would not exist yet
///     .onAppear {
///         workspace.broadcaster.broadcaster.sink { command in
///             if command.name == "myCommand" {
///                 // do something with the command
///             }
///         }
///         .store(in: &cancelables)
///     }
///     .onDissapear {
///         cancelables.forEach({ $0.cancel() })
///     }
/// ```
class AuroraCommandBroadcaster {
    /// Aurora extensions broadcaster
    public private(set) var broadcaster: AnyPublisher<Broadcast, Never>

    /// The subject that the broadcaster uses to send commands
    private var subject: CurrentValueSubject<Broadcast, Never>

    /// The logger for this class
    private let logger = Logger(subsystem: "com.auroraeditor", category: "Broadcaster")

    /// Initializes the broadcaster
    init() {
        logger.info("[AuroraCommandBroadcaster] init()")
        subject = .init(.init(sender: "AuroraEditor", command: "NOOP"))
        broadcaster = subject
            .handleEvents(receiveCancel: {})
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    /// Broadcasts a given ``Broadcast`` to the listeners of ``broadcaster``
    func broadcast(command: Broadcast) {
        subject.send(command)
    }

    /// Wrapper around ``broadcast(command:)``
    /// Essentially moves the ``Broadcast`` init to inside the function instead of wherever the function is called
    /// - Parameters:
    ///   - name: The name of the `Broadcast` to send
    ///   - parameters: The parameters of the `Broadcast`, left blank for `[:]`
    func broadcast(sender: String, command: String, parameters: [String: Any] = [:]) {
        broadcast(command: Broadcast(sender: sender, command: command, parameters: parameters))
    }

    /// Wrapper around ``broadcast(command:)``, for when there is only a name required.
    /// This function equates to broadcasting `Broadcast(name: named)`
    /// - Parameter named: The name of the command to send.
    func broadcast(command: String) {
        broadcast(command: Broadcast(sender: "Unknown", command: command))
    }

    /// Struct that holds information about the command being broadcasted
    struct Broadcast {
        var sender: String
        var command: String
        var parameters: [String: Any] = [:]
    }
}
