use array::{SpanTrait, ArrayTrait};
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


trait ArrayConcat<T> {
    fn concat(ref self: Array<T>, ref data: Span<T>);
}

impl ArrayConcatTrait<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>> of ArrayConcat<T> {
    fn concat(ref self: Array<T>, ref data: Span<T>) {
        loop {
            match data.pop_front() {
                Option::Some(v) => {
                    self.append(*v);
                },
                Option::None(_) => {
                    break ();
                },
            };
        };
    }
}
