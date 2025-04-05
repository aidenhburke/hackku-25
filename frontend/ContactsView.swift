import SwiftUI
import Contacts

struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let phone: String
}

struct ContactsView: View {
    @State private var emergencyContacts: [Contact] = []
    @State private var showingContactPicker = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Emergency Contacts")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                if emergencyContacts.isEmpty {
                    Text("No contacts added.")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                } else {
                    List(emergencyContacts) { contact in
                        VStack(alignment: .leading) {
                            Text(contact.name)
                                .font(.headline)
                            Text(contact.phone)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }

                Spacer()

                Button(action: {
                    showingContactPicker = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Emergency Contact")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.top)
            .background(Color.black.ignoresSafeArea())
            .sheet(isPresented: $showingContactPicker) {
                Text("Contact picker UI placeholder")
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
