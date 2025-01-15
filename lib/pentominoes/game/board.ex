defmodule Pentominoes.Game.Board do
  alias Pentominoes.Game.{Pentomino, Shape}

  defstruct [
    active_pentomino: nil,
    completed_pentominoes: [],
    palette: [],
    points: []
  ]

  def puzzles(), do: ~w[tiny small ball donut default wide widest medium]a

  def new(palette, points, hole \\ []) do
    %__MODULE__{palette: palette(palette), points: (points -- hole)}
  end
  def new(:tiny), do: new(:small, rect(5, 3))
  def new(:widest), do: new(:all, rect(20, 3))
  def new(:wide), do: new(:all, rect(15, 4))
  def new(:medium), do: new(:all, rect(12, 5))
  def new(:default), do: new(:all, rect(10, 6))
  def new(:small), do: new(:medium, rect(7, 5))
  def new(:donut) do
    new(:all, rect(8, 8), (for x <- 4..5, y <- 4..5, do: {x, y}))
  end
  def new(:ball) do
    new(:all, rect(8, 8), (for x <- [1, 8], y <- [1, 8], do: {x, y}))
  end

  defp rect(x, y) do
    for x <- 1..x, y <- 1..y, do: {x, y}
  end

  defp palette(:all), do: [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  defp palette(:small), do: [:u, :v, :p]
  defp palette(:medium), do: [:t, :y, :l, :p, :n, :v, :u]

  def to_shape(board) do
    Shape.__struct__(color: :purple, name: :board, points: board.points)
  end

  def to_shapes(board) do
    board_shape = to_shape(board)
    pentomino_shapes =
      [board.active_pentomino|board.completed_pentominoes]
      |> Enum.reverse
      |> Enum.filter(& &1)
      |> Enum.map(&Pentomino.to_shape/1)

    [board_shape|pentomino_shapes]
  end

  def active?(board, shape_name) when is_binary(shape_name) do
    active?(board, String.to_existing_atom(shape_name))
  end
  def active?(%{active_pentomino: %{name: shape_name}}, shape_name), do: true
  def active?(_board, _shape_name), do: false

  def drop(%{active_pentomino: nil}=board), do: board
  def drop(%{active_pentomino: pentomino}=board) do
    board
    |> Map.put(:active_pentomino, nil)
    |> Map.put(:completed_pentominoes, [pentomino|board.completed_pentominoes])
  end

  defp new_pentomino(board, shape_name) do
    Pentomino.new(name: shape_name, location: midpoints(board))
  end

  defp midpoints(board) do
    {xs, ys} = Enum.unzip(board.points)
    {midpoint(xs), midpoint(ys)}
  end

  defp midpoint(i), do: round(Enum.max(i) / 2.0)

  def pick(board, :board), do: board
  def pick(%{active_pentomino: pentomino}=board, shape_name) when not is_nil(pentomino) do
    if pentomino.name == shape_name do
      %{board| active_pentomino: nil}
    else
      board
    end
  end
  def pick(board, shape_name) do
    active =
      board.completed_pentominoes
      |> Enum.find(&(&1.name == shape_name))
      |> Kernel.||(new_pentomino(board, shape_name))
    completed = Enum.filter(board.completed_pentominoes, &(&1.name != shape_name))
    %{board| active_pentomino: active, completed_pentominoes: completed}
  end

  def legal_drop?(%{active_pentomino: pentomino}) when is_nil(pentomino), do: false
  def legal_drop?(%{active_pentomino: pentomino, points: board_points}=board) do
    points_on_board =
      Pentomino.to_shape(pentomino).points
      |> Enum.all?(fn point -> point in board_points end)
    no_overlapping_pentominoes =
      !Enum.any?(board.completed_pentominoes, &Pentomino.overlapping?(pentomino, &1))
    points_on_board and no_overlapping_pentominoes
  end

  def legal_move?(%{active_pentomino: pentomino, points: points}=_board) do
    pentomino.location in points
  end
end