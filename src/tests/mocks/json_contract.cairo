#[starknet::interface]
trait IJsonTest<TContractState> {
    fn test(self: @TContractState) -> Span<felt252>;
}


#[starknet::contract]
mod JsonTest {
    use array::{ArrayTrait, SpanTrait};
    use serde::Serde;
    use cairo_json::simple_json::{Json, JsonTrait};

    #[storage]
    struct Storage {}

    #[generate_trait]
    #[external(v0)]
    impl JsonTestImpl of IJsonTest {
        fn test(self: @ContractState) -> Span<felt252> {
            let mut json: Array<felt252> = Default::default();
            self.create_json().append_to_string(ref json);
            json.span()
        }
    }

    #[generate_trait]
    impl JsonHelperImpl of JsonHelperTrait {
        fn create_json(self: @ContractState) -> Json {
            let mut metadata = Json { members: Default::default() };
            let mut name: Array<felt252> = ArrayTrait::new();
            name.append('Stark');
            metadata.add('name', name.span());
            let mut first_name: Array<felt252> = ArrayTrait::new();
            first_name.append('Tony');
            metadata.add('first_name', first_name.span());
            metadata
        }
    }
}
