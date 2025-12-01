import gleam/int
import gleam/list
import gleam/string

pub fn parse(input: String) -> List(Int) {
  let lines = input |> string.split("\n")

  list.map(lines, fn(line) {
    let value = case line {
      "L" <> value -> "-" <> value
      "R" <> value -> value
      _ -> panic
    }
    let assert Ok(value) = int.parse(value)
    value
  })
}

pub fn pt_1(rotations: List(Int)) {
  let positions =
    list.scan(rotations, 50, fn(position, rotation) {
      { position + rotation } % 100
    })

  positions |> list.count(fn(pos) { pos == 0 })
}

/// Counts how many multiples of 100 occur within a given range (exclusive).
fn num_multiples_of_100_between(start a: Int, end b: Int) -> Int {
  assert a <= b

  let assert Ok(lower_multiplier) = int.floor_divide(a, 100)
  let assert Ok(upper_multiplier) = int.floor_divide(b, 100)

  list.range(lower_multiplier, upper_multiplier)
  |> list.map(fn(multiplier) { multiplier * 100 })
  |> list.filter(fn(multiple) { a < multiple && multiple < b })
  |> list.length
}

pub fn pt_2(rotations: List(Int)) {
  let positions = list.scan(rotations, 50, int.add) |> list.prepend(50)

  let num_clicks_during_rotations =
    positions
    |> list.window_by_2
    |> list.fold(0, fn(count, it) {
      let #(a, b) = case it {
        #(smaller, larger) if smaller < larger -> #(smaller, larger)
        #(larger, smaller) -> #(smaller, larger)
      }

      count + num_multiples_of_100_between(start: a, end: b)
    })

  pt_1(rotations) + num_clicks_during_rotations
}
