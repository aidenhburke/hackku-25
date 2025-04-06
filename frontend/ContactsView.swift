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
            updatePhoneNumbers()
        }
    }
    
    private var phoneNumbers: [String] = []
    
    var formattedPhoneNumbers: [String] {
        phoneNumbers
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
    private func updatePhoneNumbers() {
        // Extract phone numbers whenever the contacts array is updated
        self.phoneNumbers = contacts.map { contact in
            let digits = contact.phoneNumber.filter { $0.isNumber }
            let formatted = digits.hasPrefix("1") && digits.count == 11 ? "+\(digits)" :
                            digits.count == 10 ? "+1\(digits)" :
                            digits.hasPrefix("+" ) ? digits : "+\(digits)"
                return formatted
            }
        }
}

struct ContactsView: View {
    @StateObject private var store = ContactStore()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Emergency Contacts")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Color(hex: 0xEE3233))
                    .padding(.horizontal)
                    .padding(.top)

                if !store.contacts.isEmpty {
                    Text("Swipe left on a contact to remove it from the list.")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(hex: 0x6C7476))
                        .padding(.horizontal)
                }

                if store.contacts.isEmpty {
                    Spacer()
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 160)
                            .foregroundColor(Color(hex: 0xEE3233))

                        Text("No emergency contacts added yet.")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color(hex: 0x6C7476))
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    List {
                        ForEach(store.contacts) { contact in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(contact.fullName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(contact.phoneNumber)
                                    .foregroundColor(Color(hex: 0xF0ECEB))
                                if let email = contact.email {
                                    Text(email)
                                        .foregroundColor(Color(hex: 0xF0ECEB))
                                }
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(Color(hex: 0x66A7C5))
                        }
                        .onDelete(perform: store.removeContact)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color(hex: 0xCEEBFB))
                    .listStyle(InsetGroupedListStyle())
                    .cornerRadius(12)
                }

                Spacer()

                Text("You can manage your contacts in the Settings to add them to the emergency contact list.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(hex: 0x6C7476))
                    .padding(.horizontal)
                    .padding(.bottom, 36)
            }
            .background(Color(hex: 0xCEEBFB))  // Same background for the whole view
        }
    }
}

#Preview {
    ContactsView()
}
