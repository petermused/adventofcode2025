import gleam/int
import gleam/list
import gleam/string

pub type Problem {
  Sum(List(Int))
  Product(List(Int))
}

fn solve_problem(problem: Problem) -> Int {
  case problem {
    Sum(numbers) -> int.sum(numbers)
    Product(numbers) -> int.product(numbers)
  }
}

fn split_whitespace(input: String) -> List(String) {
  input
  |> string.to_graphemes
  |> list.chunk(fn(c) { c == " " })
  |> list.map(string.concat)
  |> list.map(string.trim)
  |> list.filter(fn(string) { !string.is_empty(string) })
}

fn parse(
  input: String,
  parse_numbers: fn(List(String)) -> List(List(Int)),
) -> List(Problem) {
  let lines = input |> string.split("\n")
  let numbers_lines = lines |> list.take(list.length(lines) - 1)
  let assert Ok(operations_line) = lines |> list.last

  let numbers_lists = parse_numbers(numbers_lines)

  operations_line
  |> split_whitespace
  |> list.map2(numbers_lists, fn(operation, numbers) {
    case operation {
      "+" -> Sum(numbers)
      "*" -> Product(numbers)
      _ -> panic as "invalid operation"
    }
  })
}

fn parse_numbers_pt1(numbers_lines: List(String)) -> List(List(Int)) {
  numbers_lines
  |> list.map(split_whitespace)
  |> list.transpose
  |> list.filter_map(fn(column) { list.try_map(column, int.parse) })
}

fn parse_numbers_pt2(numbers_lines: List(String)) -> List(List(Int)) {
  numbers_lines
  |> list.map(string.to_graphemes)
  |> list.transpose
  |> list.map(string.concat)
  |> list.map(string.trim)
  |> list.chunk(string.is_empty)
  |> list.filter_map(fn(chunk) { list.try_map(chunk, int.parse) })
}

pub fn pt_1(input: String) -> Int {
  input |> parse(parse_numbers_pt1) |> list.map(solve_problem) |> int.sum
}

pub fn pt_2(input: String) -> Int {
  input |> parse(parse_numbers_pt2) |> list.map(solve_problem) |> int.sum
}
