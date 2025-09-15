//
//  PasswordListView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/13/25.
//

import SwiftUI

struct PasswordListView: View {
    @State private var passwordEntries: [PasswordEntry] = []
    
    @State private var searchText = ""
    @State private var showingDeleteConfirmation = false
    @State private var passwordToDelete: PasswordEntry?
    @State private var editMode: EditMode = .inactive
    @State private var selectedPasswords = Set<UUID>()
    @State private var showingBulkDeleteConfirmation = false
    @State private var showingAddPassword = false
    // @State private var navigationID = UUID()
    
    private var filteredPasswordEntries: [PasswordEntry] {
        if searchText.isEmpty {
            return passwordEntries
        }
        
        let lowercasedSearch = searchText.lowercased()
        return passwordEntries.filter { entry in
            let websiteMatch = entry.websiteName.lowercased().contains(lowercasedSearch)
            let usernameMatch = entry.username.lowercased().contains(lowercasedSearch)
            return websiteMatch || usernameMatch
        }
    }
    
    private func deletePassword(_ entry: PasswordEntry) {
        let success = KeychainManager.shared.deletePasswordEntry(withId: entry.id)
        
        if success, let index = passwordEntries.firstIndex(where: { $0.id == entry.id}) {
            passwordEntries.remove(at: index)
            print("Deleted password for \(entry.websiteName)")
        }
    }
    
    private func deletePasswordConfirmed(_ entry: PasswordEntry) {
        deletePassword(entry)
        passwordToDelete = nil
    }
    
    private func deleteSelectedPasswords() {
        let entriesToDelete = passwordEntries.filter{selectedPasswords.contains($0.id)}
        
        for entry in entriesToDelete {
            let success = KeychainManager.shared.deletePasswordEntry(withId: entry.id)
            if success {
                passwordEntries.removeAll { $0.id == entry.id }
            }
        }
        
        selectedPasswords.removeAll()
        editMode = .inactive
        print("Deleted \(entriesToDelete.count) passwords")
    }
    
    private func deletePasswords(at offsets: IndexSet) {
        for index in offsets {
            let entry = filteredPasswordEntries[index]
            deletePassword(entry)
        }
    }
    
    var body: some View {
        VStack {
            Text("Your Passwords")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search passwords...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            if filteredPasswordEntries.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "lock.doc")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text(searchText.isEmpty ? "No passwords saved yet" : "No passwords match your search")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    if searchText.isEmpty {
                        Text("Add your first password to get started")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
            }
            
            else {
                List {
                    ForEach(filteredPasswordEntries) { entry in
                        HStack {
                            if editMode == .active {
                                Button(action: {
                                    if selectedPasswords.contains(entry.id) {
                                        selectedPasswords.remove(entry.id)
                                    } else {
                                        selectedPasswords.insert(entry.id)
                                    }
                            }) {
                                Image(systemName: selectedPasswords.contains(entry.id) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            NavigationLink(destination: PasswordDetailView(
                                websiteName: entry.websiteName,
                                username: entry.username,
                                password: entry.password
                            )) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(entry.websiteName)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(entry.username)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(editMode == .active)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", role: .destructive) {
                                passwordToDelete = entry
                                showingDeleteConfirmation = true
                            }
                            .tint(.red)
                        }
                    }
                    .onDelete(perform: editMode == .active ? nil : deletePasswords)
                }
            }
        }
        .navigationTitle("SecureVault")
        
        .navigationBarTitleDisplayMode(.automatic)
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if editMode == .active && !selectedPasswords.isEmpty {
                    Button("Delete Selected") {
                        showingBulkDeleteConfirmation = true
                    }
                    .foregroundColor(.red)
                }
                else {
                    Button(action: {
                        showingAddPassword = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        
        .confirmationDialog("Delete Password", isPresented: $showingDeleteConfirmation, presenting: passwordToDelete) { entry in
            Button("Delete", role: .destructive) {
                deletePasswordConfirmed(entry)
            }
            Button("Cancel", role: .cancel) {}
        } message: { entry in
            Text("Are you sure you want to delete the password for \(entry.websiteName)?")
        }
        
        .confirmationDialog("Delete Selected Passwords", isPresented: $showingBulkDeleteConfirmation) {
            Button("Delete All", role: .destructive) {
                deleteSelectedPasswords()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete the \(selectedPasswords.count) selected passwords?")
        }
        
        .environment(\.editMode, $editMode)
        .onAppear {
            passwordEntries = KeychainManager.shared.getAllPasswordEntries()
        }
        .refreshable {
            passwordEntries = KeychainManager.shared.getAllPasswordEntries()
        }
        
        .sheet(isPresented: $showingAddPassword) {
            NavigationView {
                AddPasswordView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showingAddPassword = false
                            }
                        }
                    }
            }
        }
        
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PasswordSaved"))) { _ in
            passwordEntries = KeychainManager.shared.getAllPasswordEntries()
        }
    }
}
