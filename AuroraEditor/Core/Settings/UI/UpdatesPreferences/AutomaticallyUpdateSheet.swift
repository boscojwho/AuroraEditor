//
//  AutomaticallyUpdateSheet.swift
//  Aurora Editor
//
//  Created by Nanashi Li on 2022/09/23.
//  Copyright © 2023 Aurora Company. All rights reserved.
//

import SwiftUI

/// A view that represents the automatically update sheet.
struct AutomaticallyUpdateSheet: View {
    /// Dismiss environment
    @Environment(\.dismiss)
    private var dismiss

    /// Preferences model
    @ObservedObject
    var prefs: AppPreferencesModel = .shared

    /// The view body
    var body: some View {
        VStack(alignment: .leading) {
            Text("settings.update.check.automatically")
                .font(.system(size: 11, weight: .bold))

            GroupBox {
                HStack {
                    Text("settings.update.check.updates")
                        .font(.system(size: 11))
                    Spacer()
                    Toggle("", isOn: $prefs.preferences.updates.checkForUpdates)
                        .onChange(of: prefs.preferences.updates.checkForUpdates, perform: { _ in
                            prefs.preferences.updates.downloadUpdatesWhenAvailable = false
                        })
                        .toggleStyle(.switch)
                        .labelsHidden()
                }
                .padding(.horizontal, 5)

                Divider()

                HStack {
                    Text("settings.update.download.when.available")
                        .font(.system(size: 11))
                    Spacer()
                    Toggle("", isOn: $prefs.preferences.updates.downloadUpdatesWhenAvailable)
                        .toggleStyle(.switch)
                        .labelsHidden()
                }
                .padding(.horizontal, 5)
                .disabled(!prefs.preferences.updates.checkForUpdates)

                Divider()

                HStack {
                    Text("settings.update.channel")
                        .font(.system(size: 11))
                    Spacer()
                    Picker("", selection: $prefs.preferences.updates.updateChannel) {
                        Text("settings.update.channel.release")
                            .font(.system(size: 11))
                            .tag(UpdateChannel.release)
                        Text("settings.update.channel.beta")
                            .font(.system(size: 11))
                            .tag(UpdateChannel.beta)
                        Text("settings.update.channel.nightly")
                            .font(.system(size: 11))
                            .tag(UpdateChannel.nightly)
                    }
                    .labelsHidden()
                    .frame(width: 80)
                }
                .padding(.bottom, 5)
                .padding(.horizontal, 5)
                .disabled(!prefs.preferences.updates.checkForUpdates)

            }

            Divider()
                .padding(.top)
                .padding(.bottom, 10)
                .padding(.horizontal, -15)

            HStack {
                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text("global.done")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 415)
    }
}

struct AutomaticallyUpdateSheet_Previews: PreviewProvider {
    static var previews: some View {
        AutomaticallyUpdateSheet()
    }
}
