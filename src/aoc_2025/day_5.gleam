import gleam/int
import gleam/list
import gleam/string

pub type Range {
  Range(start: Int, end: Int)
}

pub type Input {
  Input(ranges: List(Range), ids: List(Int))
}

pub fn parse(input: String) -> Input {
  let assert Ok(#(range_lines, id_lines)) = input |> string.split_once("\n\n")
  let range_lines = range_lines |> string.split("\n")
  let id_lines = id_lines |> string.split("\n")

  let ranges =
    list.map(range_lines, fn(id_range_line) {
      let assert Ok(#(start_string, end_string)) =
        id_range_line |> string.split_once("-")
      let assert Ok(start) = start_string |> int.parse
      let assert Ok(end) = end_string |> int.parse
      Range(start:, end:)
    })

  let ids =
    list.map(id_lines, fn(id_line) {
      let assert Ok(id) = id_line |> int.parse
      id
    })

  Input(ranges:, ids:)
}

fn ranges_overlap(a: Range, b: Range) -> Bool {
  a.start <= b.end && a.end >= b.start
}

fn range_size(range: Range) -> Int {
  { range.end - range.start } + 1
}

fn range_contains(range: Range, value: Int) -> Bool {
  range.start <= value && value <= range.end
}

fn merge_ranges(a: Range, b: Range) -> Range {
  let start = int.min(a.start, b.start)
  let end = int.max(a.end, b.end)
  Range(start:, end:)
}

fn simplify_ranges(ranges: List(Range)) -> List(Range) {
  let assert [first_range, ..ranges] =
    ranges |> list.sort(fn(a, b) { int.compare(a.start, b.start) })

  list.fold(ranges, [first_range], fn(merged_ranges, range) {
    let assert [first_range, ..merged_ranges] = merged_ranges
    case ranges_overlap(first_range, range) {
      True -> [merge_ranges(range, first_range), ..merged_ranges]
      False -> [range, first_range, ..merged_ranges]
    }
  })
}

pub fn pt_1(input: Input) -> Int {
  let ranges = simplify_ranges(input.ranges)
  list.count(input.ids, fn(id) {
    list.any(ranges, fn(range) { range_contains(range, id) })
  })
}

pub fn pt_2(input: Input) -> Int {
  input.ranges |> simplify_ranges |> list.map(range_size) |> int.sum
}
