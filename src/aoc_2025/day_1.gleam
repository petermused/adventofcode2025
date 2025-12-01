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

    case int.parse(value) {
      Ok(value) -> value
      _ -> panic
    }
  })
}

pub fn pt_1(rotations: List(Int)) {
  let positions =
    list.scan(rotations, 50, fn(position, rotation) {
      { position + rotation } % 100
    })

  positions |> list.filter(fn(pos) { pos == 0 }) |> list.length
}

pub fn pt_2(rotations: List(Int)) {
  let rotations =
    list.flat_map(rotations, fn(rotation) {
      let sign = int.clamp(rotation, min: -1, max: 1)
      let amount = int.absolute_value(rotation)
      list.repeat(sign, amount)
    })

  pt_1(rotations)
}
