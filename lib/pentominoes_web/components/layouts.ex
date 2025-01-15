defmodule PentominoesWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use PentominoesWeb, :controller` and
  `use PentominoesWeb, :live_view`.
  """
  use PentominoesWeb, :html

  embed_templates "layouts/*"
end
