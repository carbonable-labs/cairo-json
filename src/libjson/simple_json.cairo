use debug::PrintTrait;
use clone::Clone;
use array::{ArrayTrait, SpanTrait};
use libjson::utils::print_felt_span;

#[derive(Drop, Serde)]
struct Json {
    members: Array<(felt252, Span<felt252>)>, 
}

trait JsonTrait {
    fn add(ref self: Json, key: felt252, value: Span<felt252>);
    fn append_to_string(self: Json, ref s: Array<felt252>);
}


impl JsonddMemberImpl of JsonTrait {
    fn add(ref self: Json, key: felt252, value: Span<felt252>) {
        self.members.append((key, value.clone()));
    }
    fn append_to_string(self: Json, ref s: Array<felt252>) {
        let mut i = 0;
        s.append('{ ');
        loop {
            if i == self.members.len() {
                break;
            }
            let (key, value) = *self.members.at(i);
            s.append('"');
            s.append(key);
            s.append('" : "');

            // concat value
            let mut j = 0;
            loop {
                if j == value.len() {
                    break;
                }
                s.append(*value.at(j));
                j = j + 1;
            };
            s.append('"');
            if i != self.members.len() - 1 {
                s.append(', ');
            }
            i = i + 1;
        };
        s.append('}');
    }
}

// impl MemberPrint of PrintTrait<(felt252, Span<felt252>)> {
//     fn print(self: (felt252, Span<felt252>)) {
//         let (key, value) = self;
//         key.print();
//     }
// }

impl JsonPrintImpl of PrintTrait<Json> {
    fn print(self: Json) {
        let mut i = 0;
        '{ '.print();
        loop {
            if i == self.members.len() {
                break;
            }
            let (key, value) = *self.members.at(i);
            key.print();
            ' : '.print();
            print_felt_span(value);
            i = i + 1;
        };
        '}'.print();
    }
}

fn main() {
    'test json'.print();
    let mut json: Json = Json { members: Default::default() };
    let mut value: Array<felt252> = Default::default();
    value.append('This is a value');
    value.append('This is another value');
    json.add('a', value.span());

    json.print();
}
