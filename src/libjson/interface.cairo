#[starknet::interface]
trait IJsonTest<TContractState> {
    fn test(self: @TContractState) -> Span<felt252>;
}
