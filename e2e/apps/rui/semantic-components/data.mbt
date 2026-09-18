///|
fn semantic_data_fixture() -> Html {
  @fixture.section("fixture-section-semantic-data", "Data Semantics", [
    @rui.table(id="fixture-table", [
      @rui.table_caption("Fixture build matrix"),
      @rui.table_header(
        @rui.table_row([
          @rui.table_head(scope=Col, "Target"),
          @rui.table_head(scope=Col, "Status"),
        ]),
      ),
      @rui.table_body(
        @rui.table_row([@rui.table_cell("Chromium"), @rui.table_cell("Passing")]),
      ),
    ]),
    @rui.chart_container(
      id="fixture-chart",
      aria_label="Fixture coverage chart",
      style=["width:16rem"],
      @rui.chart_style(
        variables=[("covered", "#2563eb")],
        div(
          id="fixture-chart-bar",
          style=["width:75%;height:2rem;background:var(--color-covered)"],
          "75%",
        ),
      ),
    ),
    @rui.progress(
      id="fixture-progress",
      value=140,
      min=0,
      max=100,
      aria_label="Fixture completion",
      children=[
        @rui.progress_label("Fixture completion"),
        @rui.progress_value(value=140, min=0, max=100),
      ],
    ),
    @rui.progress(
      id="fixture-progress-indeterminate",
      aria_label="Fixture pending work",
    ),
  ])
}
