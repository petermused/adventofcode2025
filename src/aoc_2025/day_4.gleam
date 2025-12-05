import gleam/list
import gleam/set
import gleam/string

pub type Coord {
  Coord(row: Int, column: Int)
}

pub fn parse(input: String) -> set.Set(Coord) {
  let rows = input |> string.split("\n")

  let rows =
    list.map(rows, fn(row) {
      let columns = row |> string.to_graphemes

      list.map(columns, fn(column) {
        case column {
          "." -> False
          "@" -> True
          _ -> panic as "invalid character"
        }
      })
    })

  list.index_map(rows, fn(cells, row) {
    list.index_map(cells, fn(cell, column) { #(Coord(row:, column:), cell) })
  })
  |> list.flatten
  |> list.filter_map(fn(it) {
    let #(coord, cell) = it
    case cell {
      True -> Ok(coord)
      False -> Error(Nil)
    }
  })
  |> set.from_list
}

fn neighbours(coord: Coord, grid: set.Set(Coord)) -> set.Set(Coord) {
  let offsets = [
    #(-1, -1),
    #(-1, 0),
    #(-1, 1),
    #(0, 1),
    #(1, 1),
    #(1, 0),
    #(1, -1),
    #(0, -1),
  ]

  let coords =
    list.map(offsets, fn(offset) {
      let #(row_offset, column_offset) = offset
      Coord(row: coord.row + row_offset, column: coord.column + column_offset)
    })

  coords |> set.from_list |> set.intersection(grid)
}

fn num_accessible_rolls(
  grid: set.Set(Coord),
  next_grid: fn(set.Set(Coord), set.Set(Coord)) -> set.Set(Coord),
) -> Int {
  let accessible_rolls =
    set.filter(grid, fn(coord) { set.size(neighbours(coord, grid)) < 4 })

  case set.is_empty(accessible_rolls) {
    True -> 0
    False -> {
      set.size(accessible_rolls)
      + num_accessible_rolls(next_grid(grid, accessible_rolls), next_grid)
    }
  }
}

pub fn pt_1(grid: set.Set(Coord)) -> Int {
  num_accessible_rolls(grid, fn(_, _) { set.new() })
}

pub fn pt_2(grid: set.Set(Coord)) -> Int {
  num_accessible_rolls(grid, set.difference)
}
