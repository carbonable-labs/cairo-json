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
fn test_simple_json() {
    let JsonTest = deploy();
    let mut json_data: Span<felt252> = JsonTest.test();
    print_felt_span(json_data);

    assert(json_data.at(json_data.len() - 3) == @'Tony', 'Json String Error');
}

impl SpanPartialEq of PartialEq<Span<felt252>> {
    fn eq(lhs: @Span<felt252>, rhs: @Span<felt252>) -> bool {
        if (*lhs).len() != (*rhs).len() {
            false
        } else {
            let mut lhs = *lhs;
            let mut rhs = *rhs;

            loop {
                match lhs.pop_front() {
                    Option::Some(x) => {
                        if x != rhs.pop_front().unwrap() {
                            break false;
                        }
                    },
                    Option::None(()) => {
                        break true;
                    }
                };
            }
        }
    }

    fn ne(lhs: @Span<felt252>, rhs: @Span<felt252>) -> bool {
        return !(lhs == rhs);
    }
}

#[test]
#[available_gas(2000000)]
fn test_json_metadata() {
    let JsonTest = deploy();
    let mut json_data: Span<felt252> = JsonTest.metadata();

    let expected = array![
        '{ ',
        '"',
        'a',
        '" : "',
        'This is a value',
        'This is another value',
        '"',
        ', "attributes" : [',
        '{"display_type": "number", ',
        '"value": ',
        '1',
        '}',
        ']',
        '}'
    ]
        .span();
    assert(json_data == expected, 'Json String Error');
}

