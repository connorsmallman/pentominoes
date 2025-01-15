defmodule Pentominoes.Game.Pentomino do
  @default_location {8, 8}

  defstruct [
    name: :i,
    rotation: 0,
    reflected: false,
    location: @default_location
  ]

  alias Pentominoes.Game.Shape
  alias Pentominoes.Game.Point

  def new(fields \\ []), do: __struct__(fields)

  def rotate(%{rotation: degrees}=p) do
    %{ p | rotation: rem(degrees + 90, 360)}
  end

  def flip(%{reflected: reflection}=p) do
    %{ p | reflected: not reflection}
  end

  def up(p) do
    %{ p | location: Point.move(p.location, {0, -1})}
  end

  def down(p) do
    %{ p | location: Point.move(p.location, {0, 1})}
  end

  def left(p) do
    %{ p | location: Point.move(p.location, {-1, 0})}
  end

  def right(p) do
    %{ p | location: Point.move(p.location, {1, 0})}
  end

  def to_shape(pentomino) do
    Shape.new(pentomino.name, pentomino.rotation, pentomino.reflected, pentomino.location)
  end

  def overlapping?(pa, pb) do
    {p1, p2} = {to_shape(pa).points, to_shape(pb).points}
    Enum.count(p1 -- p2) != 5
  end
end
