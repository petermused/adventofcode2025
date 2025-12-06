import gleam/int
import gleam/list
import gleam/string

pub fn parse(input: String) -> List(List(Int)) {
  let lines = input |> string.split("\n")

  list.map(lines, fn(line) {
    let assert Ok(values) =
      line |> string.to_graphemes |> list.try_map(int.parse)
    values
  })
}

type State {
  State(joltage: Int, index: Int)
}

fn max_joltage(values: List(Int), digits num_digits: Int) -> Int {
  let indexed_values = values |> list.index_map(fn(x, i) { #(x, i) })

  let state =
    list.fold(
      list.range(num_digits, 1),
      State(joltage: 0, index: -1),
      fn(state, num_digits_left) {
        let assert Ok(#(digit, index)) =
          indexed_values
          |> list.take(list.length(indexed_values) - { num_digits_left - 1 })
          |> list.filter(fn(it) { it.1 > state.index })
          |> list.max(fn(a, b) { int.compare(a.0, b.0) })

        State(joltage: 10 * state.joltage + digit, index:)
      },
    )

  state.joltage
}

pub fn pt_1(input: List(List(Int))) -> Int {
  input |> list.map(max_joltage(_, digits: 2)) |> int.sum
}

pub fn pt_2(input: List(List(Int))) -> Int {
  input |> list.map(max_joltage(_, digits: 12)) |> int.sum
}
