module CreditTrackingSystem::CarbonCreditTracker {

    use aptos_framework::signer;

    /// Struct to store a company's carbon credit balance.
    struct Company has store, key {
        credits: u64, // Carbon credit balance
    }

    /// Function to register a company with an initial carbon credit balance.
    public fun register_company(owner: &signer, initial_credits: u64) {
        let company = Company {
            credits: initial_credits,
        };
        move_to(owner, company);
    }

    /// Function to transfer carbon credits from one company to another.
    public fun transfer_credits(sender: &signer, recipient: address, amount: u64) acquires Company {
        // Step 1: Deduct credits from the sender
        let sender_company = borrow_global_mut<Company>(signer::address_of(sender));
        assert!(sender_company.credits >= amount, 1);
        sender_company.credits = sender_company.credits - amount;

        // Step 2: Add credits to the recipient
        let recipient_company = borrow_global_mut<Company>(recipient);
        recipient_company.credits = recipient_company.credits + amount;
    }
}
