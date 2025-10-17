import SwiftUI

struct OrderFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var orderViewModel: OrderViewModel

    @State private var draft: EventOrderDraft
    @State private var showingConfirmation = false

    init(orderDraft: EventOrderDraft) {
        _draft = State(initialValue: orderDraft)
    }

    var body: some View {
        Form {
            Section("Event") {
                Text(draft.event.title)
                Text(draft.event.startDate.formattedRelativeEventRange(endDate: draft.event.endDate))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Fulfillment") {
                Picker("Order type", selection: $draft.orderType) {
                    ForEach(OrderType.allCases) { type in
                        Text(type.displayTitle).tag(type)
                    }
                }
                .pickerStyle(.segmented)

                DatePicker(
                    draft.orderType.datePickerLabel,
                    selection: $draft.fulfillmentDate,
                    in: draft.orderType.dateRange(reference: draft.event.startDate),
                    displayedComponents: [.date, .hourAndMinute]
                )

                if draft.orderType == .delivery {
                    TextField("Delivery address", text: $draft.deliveryAddress)
                }

                TextField("Contact phone", text: $draft.contactPhone)
                    .keyboardType(.phonePad)
            }

            Section("Order details") {
                TextField("What would you like?", text: $draft.itemsDescription, axis: .vertical)
                Toggle("I have a question", isOn: $draft.hasQuestions)
                if draft.hasQuestions {
                    TextField("Let us know how we can help", text: $draft.additionalNotes, axis: .vertical)
                }
            }
        }
        .navigationTitle("New order")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) { dismiss() }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Submit") {
                    showingConfirmation = true
                }
                .disabled(!orderViewModel.canSubmit(draft: draft))
            }
        }
        .confirmationDialog(
            "Submit this order?",
            isPresented: $showingConfirmation,
            presenting: draft
        ) { draft in
            Button("Submit order", role: .none) {
                Task {
                    await orderViewModel.submit(draft: draft)
                    dismiss()
                }
            }
        } message: { draft in
            Text("We will send confirmation details to \(draft.contactPhone).")
        }
        .alert("We couldn’t submit your order", isPresented: Binding(
            get: { orderViewModel.submissionError != nil },
            set: { isPresented in
                if !isPresented { orderViewModel.submissionError = nil }
            }
        ), presenting: orderViewModel.submissionError) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            Text(error)
        }
    }
}

#Preview {
    NavigationStack {
        OrderFormView(orderDraft: EventOrderDraft(event: .preview))
            .environmentObject(OrderViewModel())
    }
}
