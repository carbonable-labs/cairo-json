use debug::PrintTrait;
use array::{ArrayTrait, SpanTrait};
use cairo_json::utils::{print_felt_span, ArrayConcat};
use clone::Clone;


type String = Span<felt252>;
type ShortString = felt252;

#[derive(Drop, Copy, Serde)]
enum DisplayType {
    Number,
    BoostNumber,
    BoostPercentage,
    Date
}

#[derive(Drop, Serde)]
struct JsonMetadata {
    members: Array<(felt252, Span<felt252>)>,
    // display_type, trait_type, value
    attributes: Array<(Option<DisplayType>, Option<String>, String)>
}

trait JsonMetadataTrait {
    fn add_member(ref self: JsonMetadata, key: felt252, value: Span<felt252>);
    fn add_attribute(
        ref self: JsonMetadata,
        display_type: Option<DisplayType>,
        trait_type: Option<String>,
        value: String
    );
    fn append_to_string(self: JsonMetadata, ref s: Array<felt252>);
}


impl JsonddMemberImpl of JsonMetadataTrait {
    fn add_member(ref self: JsonMetadata, key: felt252, value: Span<felt252>) {
        self.members.append((key, value.clone()));
    }

    fn add_attribute(
        ref self: JsonMetadata,
        display_type: Option<DisplayType>,
        trait_type: Option<String>,
        value: String
    ) {
        self.attributes.append((display_type, trait_type, value));
    }

    fn append_to_string(self: JsonMetadata, ref s: Array<felt252>) {
        let mut i = 0;
        s.append('{ ');
        // append members
        loop {
            if i == self.members.len() {
                break;
            }
            let (key, mut value) = *self.members.at(i);
            s.append('"');
            s.append(key);
            s.append('" : "');

            ArrayConcat::concat(ref s, ref value);

            s.append('"');
            if i != self.members.len() - 1 {
                s.append(', ');
            }
            i = i + 1;
        };

        // append attributes
        if self.attributes.len() != 0 {
            let mut i = 0;
            s.append(', "attributes" : [');
            loop {
                if i == self.attributes.len() {
                    break;
                }
                let (display_type, trait_type, mut value) = *self.attributes.at(i);

                let mut is_number = false;

                match display_type {
                    Option::Some(display_type) => match display_type {
                        DisplayType::Number => {
                            s.append('{"display_type": "number", ');
                            is_number = true;
                        },
                        DisplayType::BoostNumber => {
                            s.append('{"display_type":"boost_number",');
                        },
                        DisplayType::BoostPercentage => {
                            s.append('{"display_type":');
                            s.append(' "boost_percentage",');
                        },
                        DisplayType::Date => {
                            s.append('{"display_type": "date", ');
                        }
                    },
                    Option::None => {
                        s.append('{')
                    }
                };

                match trait_type {
                    Option::Some(v) => {
                        let mut v = v;
                        s.append('"trait_type": "');
                        ArrayConcat::concat(ref s, ref v);
                        s.append('",')
                    },
                    Option::None => {}
                }

                s.append('"value": ');
                if !is_number {
                    s.append('"');
                }
                ArrayConcat::concat(ref s, ref value);
                if !is_number {
                    s.append('"');
                }

                s.append('}');
                if i != self.attributes.len() - 1 {
                    s.append(', ');
                }
                i = i + 1;
            };
            s.append(']');
        }

        // End of Metadata
        s.append('}');
    }
}

fn main() {
    'test json'.print();
    let mut json: JsonMetadata = JsonMetadata {
        members: Default::default(), attributes: Default::default()
    };

    json.add_member('name', array!['Stark Dog'].span());
    json.add_attribute(Option::Some(DisplayType::Number), Option::None, array!['1'].span());

    let mut metadata: Array<felt252> = Default::default();
    json.append_to_string(ref metadata);
    metadata.print();
}
