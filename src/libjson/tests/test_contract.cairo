#[starknet::contract]
mod JsonTest {
    use array::{ArrayTrait, SpanTrait};
    use serde::Serde;
    use libjson::libjson::simple_json::{Json, JsonTrait};

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

use starknet::syscalls::deploy_syscall;
use core::{TryInto};
use option::OptionTrait;
use array::{SpanTrait, ArrayTrait};
use core::result::ResultTrait;

use libjson::utils::print_felt_span;
use libjson::libjson::interface::{IJsonTestDispatcher, IJsonTestDispatcherTrait};

fn deploy() -> IJsonTestDispatcher {
    let (address, _) = deploy_syscall(
        JsonTest::TEST_CLASS_HASH.try_into().unwrap(), 0, ArrayTrait::new().span(), false
    )
        .unwrap();

    return IJsonTestDispatcher { contract_address: address };
}

#[test]
#[available_gas(2000000)]
fn test_Initialize() {
    let JsonTest = deploy();
    let mut json_data: Span<felt252> = JsonTest.test();
    print_felt_span(json_data);

    assert(json_data.at(json_data.len() - 3) == @'Tony', 'Json String Error');
}
