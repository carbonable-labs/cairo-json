#[starknet::interface]
trait IJsonTest<TContractState> {
    fn test(self: @TContractState) -> Span<felt252>;
    fn metadata(self: @TContractState) -> Span<felt252>;
}


#[starknet::contract]
mod JsonTest {
    use array::{ArrayTrait, SpanTrait};
    use serde::Serde;
    use cairo_json::simple_json::{Json, JsonTrait};
    use cairo_json::json_metadata::{JsonMetadata, JsonMetadataTrait, DisplayType};

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

        fn metadata(self: @ContractState) -> Span<felt252> {
            let mut metadata: Array<felt252> = Default::default();
            self.create_metadata().append_to_string(ref metadata);
            metadata.span()
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

        fn create_metadata(self: @ContractState) -> JsonMetadata {
            let mut json: JsonMetadata = JsonMetadata {
                members: Default::default(), attributes: Default::default()
            };
            let mut value: Array<felt252> = Default::default();

            value.append('This is a value');
            value.append('This is another value');

            json.add_member('a', value.span());
            json.add_attribute(Option::Some(DisplayType::Number), Option::None, array!['1'].span());
            json
        }
    }
}
