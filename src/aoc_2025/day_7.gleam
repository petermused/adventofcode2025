import gleam/dict
import gleam/int
import gleam/list
import gleam/set
import gleam/string

pub type Coord {
  Coord(row: Int, column: Int)
}

pub type Input {
  Input(num_rows: Int, start: Coord, splitters: set.Set(Coord))
}

pub fn parse(input: String) -> Input {
  let lines = input |> string.split("\n") |> list.map(string.to_graphemes)

  let rows =
    list.index_map(lines, fn(cells, row) {
      list.index_map(cells, fn(cell, column) { #(Coord(row:, column:), cell) })
    })

  let assert [start_row, ..rows] = rows
  let num_rows = list.length(rows)

  let assert Ok(start) =
    list.find_map(start_row, fn(it) {
      let #(coord, character) = it
      case character {
        "S" -> Ok(coord)
        _ -> Error(Nil)
      }
    })

  let splitters =
    rows
    |> list.flatten
    |> list.filter_map(fn(it) {
      let #(coord, character) = it
      case character {
        "^" -> Ok(coord)
        _ -> Error(Nil)
      }
    })
    |> set.from_list

  Input(num_rows:, start:, splitters:)
}

type State {
  State(beam_positions: set.Set(Coord), num_splits: Int)
}

pub fn pt_1(input: Input) -> Int {
  let state =
    list.fold(
      list.range(1, input.num_rows - 1),
      State(beam_positions: set.from_list([input.start]), num_splits: 0),
      fn(state, _) {
        let next_beam_positions =
          state.beam_positions
          |> set.map(fn(coord) { Coord(..coord, row: coord.row + 1) })
        let beams_to_split =
          set.intersection(next_beam_positions, input.splitters)
        let split_beams =
          beams_to_split
          |> set.to_list
          |> list.flat_map(fn(coord) {
            [
              Coord(..coord, column: coord.column - 1),
              Coord(..coord, column: coord.column + 1),
            ]
          })
          |> set.from_list

        let beam_positions =
          next_beam_positions
          |> set.difference(beams_to_split)
          |> set.union(split_beams)
        let num_splits = set.size(beams_to_split)

        State(beam_positions:, num_splits: state.num_splits + num_splits)
      },
    )

  state.num_splits
}

pub fn pt_2(input: Input) -> Int {
  let splitters =
    input.splitters
    |> set.to_list
    |> list.sort(fn(a, b) { int.compare(a.row, b.row) })

  let assert Ok(first_splitter) = list.first(splitters)

  let assert Ok(num_timelines) =
    splitters
    |> list.reverse
    |> list.fold(dict.new(), fn(memo, coord) {
      todo as "base case 1 on each side, recursive case use memo"
    })
    |> dict.get(first_splitter)

  num_timelines
}
