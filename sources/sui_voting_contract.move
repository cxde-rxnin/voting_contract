module sui_voting_contract::sui_voting_contract;

use std::string::String;

public struct Candidate has key, store {
    id: object::UID,
    name: String,
    vote_count: u64,
}

public struct Election has key, store {
    id: object::UID,
    name: String,
    candidates: vector<object::ID>,
    start_time: Option<u64>,
    end_time: Option<u64>,
    registered_voters: vector<address>,
    voted_addresses: vector<address>,
}

public fun create_election(name: String, ctx: &mut tx_context::TxContext) {
    let election = Election {
        id: object::new(ctx),
        name,
        candidates: vector::empty<object::ID>(),
        start_time: option::none<u64>(),
        end_time: option::none<u64>(),
        registered_voters: vector::empty<address>(),
        voted_addresses: vector::empty<address>(),
    };
    
    transfer::public_share_object(election);
}

public fun register_candidate(election: &mut Election, name: String, ctx: &mut tx_context::TxContext) {
    let candidate = Candidate {
        id: object::new(ctx),
        name,
        vote_count: 0,
    };

    election.candidates.push_back(*candidate.id.as_inner());
    transfer::public_share_object(candidate);
}