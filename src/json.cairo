use core::box::BoxTrait;
use debug::PrintTrait;
use array::{ArrayTrait, SpanTrait};
use clone::Clone;
use option::OptionTrait;
use box::Box;

#[derive(Drop)]
enum Json {
    String: Array<felt252>,
    Number: u128,
    Null: (),
    Bool: bool,
    Array: Array<Json>,
    Object: Array<(Span<felt252>, Json)>,
}

trait JsonTrait {
    fn add(ref self: Json, key: @felt252, value: Json);
}

impl JsonPrintImpl of PrintTrait<Json> {
    fn print(self: Json) {
        match self {
            Json::String(array) => array.print(),
            Json::Number(n) => n.print(),
            Json::Null => (),
            Json::Bool(b) => b.print(),
            Json::Array(array) => print_span(array.span()),
            Json::Object(array) => print_objects(array.span()),
        };
    }
}

fn print_span(a: Span<Json>) {
    let mut i: usize = 0;
    loop {
        if i == a.len() {
            break;
        }
        let v: @Json = a.get(i).unwrap().unbox();
        v.print();
        i += 1;
    }
}


fn print_objects(objects: Span<(Span<felt252>, Json)>) {}

impl JsonTraitImpl of JsonTrait {
    fn add(ref self: Json, key: @felt252, value: Json) {}
}

fn main() {
    let mut test: Json = Json::Object(ArrayTrait::new());
    test.add(@'key', Json::Number(123));
}
