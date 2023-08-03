use starknet::syscalls::deploy_syscall;
use core::{TryInto};
use option::OptionTrait;
use array::{SpanTrait, ArrayTrait};
use core::result::ResultTrait;

use cairo_json::tests::mocks::json_contract::JsonTest;
use cairo_json::utils::print_felt_span;
use cairo_json::tests::mocks::json_contract::{IJsonTestDispatcher, IJsonTestDispatcherTrait};

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
