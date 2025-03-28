

module MyModule::CharityGivingPlatform {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a charitable cause.
    struct CharityCause has store, key {
        total_donations: u64,  // Total tokens donated
        goal: u64,             // Donation goal
    }

    /// Function to create a new charity cause with a donation goal.
    public fun create_charity(creator: &signer, goal: u64) {
        let cause = CharityCause {
            total_donations: 0,
            goal,
        };
        move_to(creator, cause);
    }

    /// Function for users to donate to the charity cause.
    public fun donate_to_charity(donor: &signer, charity_owner: address, amount: u64) acquires CharityCause {
        let cause = borrow_global_mut<CharityCause>(charity_owner);

        // Transfer donation from the donor to the charity owner
        let donation = coin::withdraw<AptosCoin>(donor, amount);
        coin::deposit<AptosCoin>(charity_owner, donation);

        // Update the total donations
        cause.total_donations = cause.total_donations + amount;
    }
}
