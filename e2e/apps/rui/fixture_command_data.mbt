///|
priv struct FixturePayment {
  id : String
  status : String
  owner : String
  amount : String
}

///|
fn fixture_command_items(scope : @rui.CommandScope) -> Html {
  fragment([
    @rui.command_input(scope~, placeholder="Search fixture actions…"),
    @rui.command_list(scope~, aria_label="Fixture actions", [
      @rui.command_empty(scope~, "No matching fixture actions."),
      @rui.command_group(scope~, heading="Workspace", [
        @rui.command_item(scope~, value="Open dashboard", keywords=["home"], [
          span("Open dashboard"),
          @rui.command_shortcut("Ctrl+D"),
        ]),
        @rui.command_item(
          scope~,
          value="Create project",
          keywords=["new"],
          "Create project",
        ),
        @rui.command_item(
          scope~,
          value="Unavailable action",
          disabled=true,
          "Unavailable action",
        ),
        @rui.command_item(
          scope~,
          value="Open settings",
          keywords=["preferences"],
          "Open settings",
        ),
      ]),
    ]),
  ])
}

///|
fn command_fixture() -> Val[Html] {
  let (selection, set_selection) = @rabbita.create_variable("none")
  let (query, set_query) = @rabbita.create_variable("")
  let command = @rui.command(
    id="fixture-command",
    on_value_select=set_selection.map(value => _ => value),
    on_query_change=set_query.map(value => _ => value),
    style=[
      "width:min(100%,24rem);border:1px solid \{fixture_section_border};border-radius:0.5rem",
    ],
    fixture_command_items,
  )
  command.map3(selection, query, fn(command, selection, query) {
    fixture_section("fixture-section-command", "Command", [
      command,
      @html.output(
        id="fixture-command-output",
        "query:\{query}|selected:\{selection}",
      ),
    ])
  })
}

///|
fn command_dialog_fixture() -> Val[Html] {
  let (selection, set_selection) = @rabbita.create_variable("none")
  let (open_state, set_open_state) = @rabbita.create_variable("closed")
  let dialog = @rui.command_dialog(
    id="fixture-command-dialog",
    aria_label="Fixture command palette",
    on_value_select=set_selection.map(value => _ => value),
    on_open_change=set_open_state.map(open => {
      _ => if open { "open" } else { "closed" }
    }),
    trigger=scope => @rui.command_dialog_trigger(scope~, "Open fixture palette"),
    fixture_command_items,
  )
  dialog.map3(selection, open_state, fn(dialog, selection, open_state) {
    fixture_section("fixture-section-command-dialog", "Command Dialog", [
      dialog,
      @html.output(
        id="fixture-command-dialog-output",
        "state:\{open_state}|selected:\{selection}",
      ),
    ])
  })
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
    fixture_section("fixture-section-data-table", "Data Table", [
      div(style=["width:100%"], table),
      @html.output(
        id="fixture-data-table-output",
        "query:\{query}|selected:\{selected}",
      ),
    ])
  })
}

///|
fn command_data_fixture() -> Val[Html] {
  command_fixture().map3(command_dialog_fixture(), data_table_fixture(), fn(
    command,
    dialog,
    table,
  ) {
    fragment([command, dialog, table])
  })
}
