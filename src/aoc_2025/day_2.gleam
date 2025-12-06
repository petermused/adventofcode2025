import gleam/float
import gleam/int
import gleam/list
import gleam/string

pub type IdRange {
  IdRange(start: Int, end: Int)
}

pub fn parse(input: String) -> List(IdRange) {
  let id_ranges = input |> string.split(",")

  list.map(id_ranges, fn(id_range) {
    let assert Ok(#(start, end)) = id_range |> string.split_once("-")
    let assert Ok(start) = int.parse(start)
    let assert Ok(end) = int.parse(end)

    IdRange(start:, end:)
  })
}

type InvalidId {
  InvalidId(digits: Int, repeats: Int)
}

fn invalid_id_to_int(invalid_id: InvalidId) -> Int {
  let invalid_id_string =
    int.to_string(invalid_id.digits) |> string.repeat(invalid_id.repeats)
  let assert Ok(value) = int.parse(invalid_id_string)
  value
}

fn next_invalid_id(from id: Int, with_repeats repeats: Int) -> InvalidId {
  let id_string = int.to_string(id)
  let length = string.length(id_string)

  case length % repeats == 0 {
    True -> {
      let chunk_length = length / repeats
      let assert Ok(first_chunk) =
        id_string
        |> string.slice(at_index: 0, length: chunk_length)
        |> int.parse

      let invalid_id = InvalidId(digits: first_chunk, repeats:)
      case invalid_id_to_int(invalid_id) >= id {
        True -> invalid_id
        False -> InvalidId(digits: first_chunk + 1, repeats:)
      }
    }
    False -> {
      let chunk_length = { length / repeats } + 1
      let assert Ok(first_chunk) = int.power(10, int.to_float(chunk_length - 1))
      let first_chunk = float.truncate(first_chunk)
      InvalidId(digits: first_chunk, repeats:)
    }
  }
}

fn invalid_ids_in_range_with_repeats(
  id_range: IdRange,
  repeats repeats: Int,
) -> List(Int) {
  let start_invalid_id =
    next_invalid_id(from: id_range.start, with_repeats: repeats)
  let end_invalid_id =
    next_invalid_id(from: id_range.end, with_repeats: repeats)

  list.range(start_invalid_id.digits, end_invalid_id.digits)
  |> list.map(fn(digits) { InvalidId(digits:, repeats:) |> invalid_id_to_int })
  |> list.filter(fn(id) { id_range.start <= id && id <= id_range.end })
}

pub fn pt_1(id_ranges: List(IdRange)) -> Int {
  id_ranges
  |> list.flat_map(invalid_ids_in_range_with_repeats(_, repeats: 2))
  |> int.sum
}

fn all_invalid_ids_in_range(id_range: IdRange) -> List(Int) {
  let min_repeats = 2
  let max_repeats = id_range.end |> int.to_string |> string.length |> int.max(2)

  list.range(min_repeats, max_repeats)
  |> list.flat_map(invalid_ids_in_range_with_repeats(id_range, repeats: _))
  |> list.unique
}

pub fn pt_2(id_ranges: List(IdRange)) -> Int {
  id_ranges
  |> list.flat_map(all_invalid_ids_in_range)
  |> int.sum
}
