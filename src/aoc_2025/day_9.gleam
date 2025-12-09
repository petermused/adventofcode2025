import gleam/int
import gleam/list
import gleam/string

pub type Coord {
  Coord(x: Int, y: Int)
}

pub fn parse(input: String) -> List(Coord) {
  let lines = input |> string.split("\n")

  list.map(lines, fn(line) {
    let assert Ok(#(x, y)) = line |> string.split_once(",")
    let assert Ok(x) = int.parse(x)
    let assert Ok(y) = int.parse(y)
    Coord(x:, y:)
  })
}

fn rectangle_area(a: Coord, b: Coord) -> Int {
  let width = int.absolute_value(a.x - b.x) + 1
  let height = int.absolute_value(a.y - b.y) + 1
  width * height
}

pub fn pt_1(coords: List(Coord)) -> Int {
  let assert Ok(max_area) =
    coords
    |> list.combination_pairs
    |> list.map(fn(pair) {
      let #(a, b) = pair
      rectangle_area(a, b)
    })
    |> list.max(int.compare)

  max_area
}

pub fn pt_2(coords: List(Coord)) -> Int {
  todo as "part 2 not implemented"
}
