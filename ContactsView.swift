import SwiftUI
import Contacts

struct Contact: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var fullName: String
    var phoneNumber: String
    var email: String?

    enum CodingKeys: String, CodingKey {
        case id, fullName, phoneNumber, email
    }

    init(id: UUID = UUID(), fullName: String, phoneNumber: String, email: String? = nil) {
        self.id = id
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.email = email
    }
}

class ContactStore: ObservableObject {
    @Published var contacts: [Contact] = [] {
        didSet {
            saveContacts()
        }
    }

    init() {
        loadContactsFromCNContacts()
    }

    private let contactsKey = "SavedContacts"

    func saveContacts() {
        if let encoded = try? JSONEncoder().encode(contacts) {
            UserDefaults.standard.set(encoded, forKey: contactsKey)
        }
    }

    func loadContactsFromCNContacts() {
        let store = CNContactStore()
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)

        var fetchedContacts: [Contact] = []

        do {
            try store.enumerateContacts(with: request) { (cnContact, stop) in
                guard let phoneNumber = cnContact.phoneNumbers.first?.value.stringValue else { return }
                let email = cnContact.emailAddresses.first?.value as String?
                let fullName = "\(cnContact.givenName) \(cnContact.familyName)".trimmingCharacters(in: .whitespaces)

                let contact = Contact(fullName: fullName, phoneNumber: phoneNumber, email: email)
                fetchedContacts.append(contact)
            }
            DispatchQueue.main.async {
                self.contacts = fetchedContacts
            }
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
    }

    func removeContact(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }

    func addContact(fullName: String, phoneNumber: String, email: String?) {
        let newContact = Contact(fullName: fullName, phoneNumber: phoneNumber, email: email)
        contacts.append(newContact)
    }
}

struct ContactsView: View {
    @StateObject private var store = ContactStore()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Emergency Contacts")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)

                Text("Swipe left on a contact to remove it from the list.")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                if store.contacts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.purple)
                        Text("No emergency contacts added yet.")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Go to Settings and grant access to your device contacts. Contacts that are allowed will appear here.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(store.contacts) { contact in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(contact.fullName)
                                    .font(.headline)
                                Text(contact.phoneNumber)
                                    .foregroundColor(.secondary)
                                if let email = contact.email {
                                    Text(email)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: store.removeContact)
                    }
                    .listStyle(InsetGroupedListStyle())
                }

                Spacer()

                VStack(spacing: 12) {
                    Text("You can manage which contacts appear here by going to the Settings tab and granting permission to access your device contacts.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

