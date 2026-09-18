///|
priv struct FixturePayment {
  id : String
  status : String
  owner : String
  amount : String
}

///|
fn data_table_fixture() -> Val[Html] {
  let rows : Array[FixturePayment] = [
    { id: "pay-001", status: "Paid", owner: "Ada", amount: "120", },
    { id: "pay-002", status: "Processing", owner: "Grace", amount: "80", },
    { id: "pay-003", status: "Failed", owner: "Lin", amount: "240", },
    { id: "pay-004", status: "Paid", owner: "Margaret", amount: "160", },
    { id: "pay-005", status: "Paid", owner: "Evelyn", amount: "40", },
  ]
  let columns : Array[@rui.DataTableColumn[FixturePayment]] = [
    @rui.data_table_column(key="status", label="Status", value=row => row.status),
    @rui.data_table_column(key="owner", label="Owner", value=row => row.owner),
    @rui.data_table_column(
      key="amount",
      label="Amount",
      value=row => row.amount,
      numeric=true,
      render=row => strong("¥\{row.amount}"),
    ),
  ]
  let (selected, set_selected) = @rabbita.create_variable("pay-002")
  let (query, set_query) = @rabbita.create_variable("")
  let table = @rui.data_table(
    id="fixture-data-table",
    rows~,
    columns~,
    row_key=row => row.id,
    page_size=2,
    default_sort_key="amount",
    default_selected=["pay-002"],
    aria_label="Fixture payments",
    on_selection_change=set_selected.map(values => _ => values.join(",")),
    on_query_change=set_query.map(value => _ => value),
  )
  table.map3(selected, query, fn(table, selected, query) {
    @fixture.section("fixture-section-data-table", "Data Table", [
      div(style=["width:100%"], table),
      @html.output(
        id="fixture-data-table-output",
        "query:\{query}|selected:\{selected}",
      ),
    ])
  })
}
