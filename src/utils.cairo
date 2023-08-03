use array::SpanTrait;
use debug::PrintTrait;

fn print_felt_span(a: Span<felt252>) {
    let length = a.len();
    let mut index = 0;
    loop {
        if index < length {
            let value = *a.at(index);
            value.print();
        } else {
            break;
        }
        index += 1;
    };
}

