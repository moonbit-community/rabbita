///|
const FormsVariantsStackStyle : String = "display:flex;min-width:0;flex-direction:column;gap:4rem"

///|
const FormsVariantsGridStyle : String = "display:grid;width:min(100%,48rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,13rem),1fr));gap:clamp(1.5rem,4vw,2.5rem);align-items:start"

///|
const FormsVariantsWideGridStyle : String = "display:grid;width:min(100%,50rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(1.75rem,5vw,3rem);align-items:start"

///|
const FormsVariantItemStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.75rem"

///|
const FormsVariantItemTitleStyle : String = "margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"

///|
const FormsVariantItemNoteStyle : String = "margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"

///|
const FormsVariantControlStyle : String = "display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"

///|
const FormsVariantColumnStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.625rem"

///|
fn forms_variant_item(
  title : String,
  note : String,
  body : @html.Html,
) -> @html.Html {
  @html.div(style=[FormsVariantItemStyle], [
    @html.div(style=[FormsVariantColumnStyle, "gap:0.25rem"], [
      @html.h5(style=[FormsVariantItemTitleStyle], title),
      @html.p(style=[FormsVariantItemNoteStyle], note),
    ]),
    @html.div(style=["min-width:0"], body),
  ])
}

///|
const FormsCheckboxCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"],
  #|      [
  #|        @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|        @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|      ],
  #|    ),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|let mixed = @ui.checkbox(
  #|  id="forms-variants-checkbox-mixed",
  #|  default_indeterminate=true,
  #|  aria_label="Select all projects",
  #|)
  #|let invalid = @ui.checkbox(
  #|  id="forms-variants-checkbox-invalid",
  #|  invalid=true,
  #|  aria_label="Accept the workspace policy",
  #|)
  #|let disabled = @ui.checkbox(
  #|  id="forms-variants-checkbox-disabled",
  #|  default_checked=true,
  #|  disabled=true,
  #|  aria_label="Inherited organization policy",
  #|)
  #|mixed.view3(invalid, disabled, (mixed_html, invalid_html, disabled_html) => {
  #|  @html.div(
  #|    style=["display:grid;width:min(100%,48rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,13rem),1fr));gap:clamp(1.5rem,4vw,2.5rem);align-items:start"],
  #|    [
  #|      item("Mixed", "Starts indeterminate, then resolves through normal activation.", @html.div(
  #|        style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|        [@ui.label(for_="forms-variants-checkbox-mixed", "All projects"), mixed_html],
  #|      )),
  #|      item("Invalid", "Validation styling leaves pointer and keyboard behavior intact.", @html.div(
  #|        style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|        [@ui.label(for_="forms-variants-checkbox-invalid", "Workspace policy"), invalid_html],
  #|      )),
  #|      item("Disabled", "A managed value remains visible without entering the tab order.", @html.div(
  #|        style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|        [
  #|          @ui.label(for_="forms-variants-checkbox-disabled", disabled=true, "Organization policy"),
  #|          disabled_html,
  #|        ],
  #|      )),
  #|    ],
  #|  )
  #|})
  #|

///|
const FormsSwitchSizesCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"], [
  #|      @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|      @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|    ]),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|let previews = @ui.switch(
  #|  id="forms-variants-switch-default",
  #|  default_checked=true,
  #|  aria_label="Enable live previews",
  #|)
  #|let activity = @ui.switch(
  #|  id="forms-variants-switch-small",
  #|  size=@ui.Sm,
  #|  aria_label="Enable compact activity",
  #|)
  #|previews.view2(activity, (previews_html, activity_html) => @html.div(
  #|  style=["display:grid;width:min(100%,50rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(1.75rem,5vw,3rem);align-items:start"],
  #|  [
  #|    item("Default", "The standard control for a settings row.", @html.div(
  #|      style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|      [@ui.label(for_="forms-variants-switch-default", "Live previews"), previews_html],
  #|    )),
  #|    item("Small", "A compact control for denser preference lists.", @html.div(
  #|      style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|      [@ui.label(for_="forms-variants-switch-small", "Compact activity"), activity_html],
  #|    )),
  #|  ],
  #|))
  #|

///|
const FormsSwitchValidationCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"], [
  #|      @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|      @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|    ]),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|let approval = @ui.switch(
  #|  id="forms-variants-switch-invalid",
  #|  invalid=true,
  #|  aria_label="Enable required approval",
  #|)
  #|let backups = @ui.switch(
  #|  id="forms-variants-switch-disabled",
  #|  default_checked=true,
  #|  disabled=true,
  #|  aria_label="Organization-managed backups",
  #|)
  #|approval.view2(backups, (approval_html, backups_html) => @html.div(
  #|  style=["display:grid;width:min(100%,50rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(1.75rem,5vw,3rem);align-items:start"],
  #|  [
  #|    item("Invalid", "Required-choice styling without replacing interaction.", @html.div(
  #|      style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|      [@ui.label(for_="forms-variants-switch-invalid", "Approval required"), approval_html],
  #|    )),
  #|    item("Disabled", "The organization owns this setting.", @html.div(
  #|      style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|      [
  #|        @ui.label(for_="forms-variants-switch-disabled", disabled=true, "Managed backups"),
  #|        backups_html,
  #|      ],
  #|    )),
  #|  ],
  #|))
  #|

///|
const FormsComboboxSelectionCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"], [
  #|      @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|      @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|    ]),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|let options = [
  #|  @ui.combobox_option(value="moonbit", label="MoonBit"),
  #|  @ui.combobox_option(value="rabbita", label="Rabbita"),
  #|  @ui.combobox_option(value="typescript", label="TypeScript"),
  #|  @ui.combobox_option(value="rust", label="Rust"),
  #|  @ui.combobox_option(value="legacy", label="Legacy runtime", disabled=true),
  #|]
  #|let multiple = @ui.combobox(
  #|  id="forms-variants-combobox-multiple",
  #|  options=options,
  #|  multiple=true,
  #|  default_values=["moonbit", "rabbita"],
  #|  placeholder="Add a runtime…",
  #|  empty_text="No matching runtimes.",
  #|  name="supported-runtimes",
  #|)
  #|let grouped = @ui.combobox(
  #|  id="forms-variants-combobox-grouped",
  #|  options=options,
  #|  default_value="rabbita",
  #|  render=scope => @html.fragment([
  #|    @ui.combobox_trigger(scope~, aria_label="Choose a runtime by group"),
  #|    @ui.combobox_content(scope~, @ui.combobox_list([
  #|      @ui.combobox_group(label_id="forms-variants-combobox-group-core-label", [
  #|        @ui.combobox_label(id="forms-variants-combobox-group-core-label", "Core"),
  #|        @ui.combobox_item(scope~, value="moonbit", "MoonBit"),
  #|        @ui.combobox_item(scope~, value="rabbita", "Rabbita"),
  #|      ]),
  #|      @ui.combobox_separator(),
  #|      @ui.combobox_group(label_id="forms-variants-combobox-group-host-label", [
  #|        @ui.combobox_label(id="forms-variants-combobox-group-host-label", "Host languages"),
  #|        @ui.combobox_item(scope~, value="typescript", "TypeScript"),
  #|        @ui.combobox_item(scope~, value="rust", "Rust"),
  #|        @ui.combobox_item(scope~, value="legacy", disabled=true, "Legacy runtime"),
  #|      ]),
  #|    ])),
  #|  ]),
  #|)
  #|multiple.view2(grouped, (multiple_html, grouped_html) => @html.div(
  #|  style=["display:grid;width:min(100%,50rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(1.75rem,5vw,3rem);align-items:start"],
  #|  [
  #|    item("Multiple", "Remove chips, clear the value, or type to add another runtime.", multiple_html),
  #|    item("Grouped", "Core and host-language options share one searchable popup.", grouped_html),
  #|  ],
  #|))
  #|

///|
const FormsComboboxAvailabilityCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"], [
  #|      @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|      @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|    ]),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|let options = [
  #|  @ui.combobox_option(value="moonbit", label="MoonBit"),
  #|  @ui.combobox_option(value="rabbita", label="Rabbita"),
  #|  @ui.combobox_option(value="typescript", label="TypeScript"),
  #|  @ui.combobox_option(value="rust", label="Rust"),
  #|  @ui.combobox_option(value="legacy", label="Legacy runtime", disabled=true),
  #|]
  #|let empty = @ui.combobox(
  #|  id="forms-variants-combobox-empty",
  #|  options=[
  #|    @ui.combobox_option(value="alpha", label="Alpha workspace"),
  #|    @ui.combobox_option(value="beta", label="Beta workspace"),
  #|  ],
  #|  placeholder="Search workspaces…",
  #|  empty_text="No workspace matches this search.",
  #|)
  #|let invalid = @ui.combobox(
  #|  id="forms-variants-combobox-invalid",
  #|  options=options,
  #|  placeholder="Choose a required runtime…",
  #|  empty_text="No matching runtimes.",
  #|  invalid=true,
  #|  required=true,
  #|)
  #|let disabled = @ui.combobox(
  #|  id="forms-variants-combobox-disabled",
  #|  options=options,
  #|  default_value="moonbit",
  #|  disabled=true,
  #|)
  #|empty.view3(invalid, disabled, (empty_html, invalid_html, disabled_html) => @html.div(
  #|  style=["display:grid;width:min(100%,48rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,13rem),1fr));gap:clamp(1.5rem,4vw,2.5rem);align-items:start"],
  #|  [
  #|    item("Empty result", "Type an unmatched query to reveal the component's empty message.", empty_html),
  #|    item("Invalid", "A required choice keeps search and keyboard interaction available.", invalid_html),
  #|    item("Disabled", "The selected runtime remains readable in a locked control.", disabled_html),
  #|  ],
  #|))
  #|

///|
const FormsSelectCompoundCode : String =
  #|let options = [
  #|  @ui.select_option(value="iad", label="Washington, D.C."),
  #|  @ui.select_option(value="ord", label="Chicago"),
  #|  @ui.select_option(value="dfw", label="Dallas"),
  #|  @ui.select_option(value="sfo", label="San Francisco"),
  #|  @ui.select_option(value="fra", label="Frankfurt"),
  #|  @ui.select_option(value="lhr", label="London"),
  #|  @ui.select_option(value="sin", label="Singapore"),
  #|  @ui.select_option(value="nrt", label="Tokyo"),
  #|  @ui.select_option(value="syd", label="Sydney"),
  #|  @ui.select_option(value="legacy-region", label="Legacy region", disabled=true),
  #|]
  #|let grouped = @ui.select(
  #|  id="forms-variants-select-grouped",
  #|  options=options,
  #|  default_value="sfo",
  #|  render=scope => @html.fragment([
  #|    @ui.select_trigger(scope~, aria_label="Choose a deployment region"),
  #|    @ui.select_content(scope~, style=["max-height:13rem"], [
  #|      @ui.select_scroll_up_button(scope~, label="Scroll regions up"),
  #|      @ui.select_group(label_id="forms-variants-select-americas-label", [
  #|        @ui.select_label(id="forms-variants-select-americas-label", "Americas"),
  #|        @ui.select_item(scope~, value="iad", "Washington, D.C."),
  #|        @ui.select_item(scope~, value="ord", "Chicago"),
  #|        @ui.select_item(scope~, value="dfw", "Dallas"),
  #|        @ui.select_item(scope~, value="sfo", "San Francisco"),
  #|      ]),
  #|      @ui.select_separator(),
  #|      @ui.select_group(label_id="forms-variants-select-emea-label", [
  #|        @ui.select_label(id="forms-variants-select-emea-label", "Europe"),
  #|        @ui.select_item(scope~, value="fra", "Frankfurt"),
  #|        @ui.select_item(scope~, value="lhr", "London"),
  #|      ]),
  #|      @ui.select_separator(),
  #|      @ui.select_group(label_id="forms-variants-select-apac-label", [
  #|        @ui.select_label(id="forms-variants-select-apac-label", "Asia Pacific"),
  #|        @ui.select_item(scope~, value="sin", "Singapore"),
  #|        @ui.select_item(scope~, value="nrt", "Tokyo"),
  #|        @ui.select_item(scope~, value="syd", "Sydney"),
  #|        @ui.select_item(scope~, value="legacy-region", disabled=true, "Legacy region"),
  #|      ]),
  #|      @ui.select_scroll_down_button(scope~, label="Scroll regions down"),
  #|    ]),
  #|  ]),
  #|)
  #|grouped.view(grouped_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  grouped_html,
  #|))
  #|

///|
const FormsSelectAvailabilityCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"], [
  #|      @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|      @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|    ]),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|let options = [
  #|  @ui.select_option(value="iad", label="Washington, D.C."),
  #|  @ui.select_option(value="ord", label="Chicago"),
  #|  @ui.select_option(value="dfw", label="Dallas"),
  #|  @ui.select_option(value="sfo", label="San Francisco"),
  #|  @ui.select_option(value="fra", label="Frankfurt"),
  #|  @ui.select_option(value="lhr", label="London"),
  #|  @ui.select_option(value="sin", label="Singapore"),
  #|  @ui.select_option(value="nrt", label="Tokyo"),
  #|  @ui.select_option(value="syd", label="Sydney"),
  #|  @ui.select_option(value="legacy-region", label="Legacy region", disabled=true),
  #|]
  #|let invalid = @ui.select(
  #|  id="forms-variants-select-invalid",
  #|  options=options,
  #|  placeholder="Choose a required region…",
  #|  invalid=true,
  #|  required=true,
  #|)
  #|let disabled = @ui.select(
  #|  id="forms-variants-select-disabled",
  #|  options=options,
  #|  default_value="fra",
  #|  disabled=true,
  #|)
  #|invalid.view2(disabled, (invalid_html, disabled_html) => @html.div(
  #|  style=["display:grid;width:min(100%,50rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(1.75rem,5vw,3rem);align-items:start"],
  #|  [
  #|    item("Invalid", "Required styling keeps normal pointer and keyboard behavior.", invalid_html),
  #|    item("Disabled", "The selected region remains legible in a locked control.", disabled_html),
  #|  ],
  #|))
  #|

///|
const FormsFieldLayoutsCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"], [
  #|      @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|      @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|    ]),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|@html.div(
  #|  style=["display:grid;width:min(100%,50rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(1.75rem,5vw,3rem);align-items:start"],
  #|  [
  #|    item("Horizontal", "A compact label and control share one row.", @ui.field(
  #|      orientation=@ui.FieldHorizontal,
  #|      [
  #|        @ui.field_label(
  #|          for_="forms-variants-field-horizontal",
  #|          style=["width:7rem;flex:none"],
  #|          "Project",
  #|        ),
  #|        @ui.field_content([
  #|          @ui.input(id="forms-variants-field-horizontal", placeholder="rabbit-tea"),
  #|          @ui.field_description("Used in generated workspace URLs."),
  #|        ]),
  #|      ],
  #|    )),
  #|    item("Responsive", "The label stacks when the field container becomes narrow.", @ui.field(
  #|      orientation=@ui.FieldResponsive,
  #|      [
  #|        @ui.field_label(for_="forms-variants-field-responsive", "Repository"),
  #|        @ui.field_content([
  #|          @ui.input(
  #|            id="forms-variants-field-responsive",
  #|            placeholder="moonbit-community/rabbita",
  #|          ),
  #|          @ui.field_description("Paste a repository path or URL."),
  #|        ]),
  #|      ],
  #|    )),
  #|  ],
  #|)
  #|

///|
const FormsFieldsetCode : String =
  #|@html.div(
  #|  style=["width:min(100%,34rem);margin-inline:auto"],
  #|  @ui.field_set([
  #|    @ui.field_legend(variant=@ui.FieldLabelLegend, "Delivery settings"),
  #|    @ui.field_group(style=["gap:1rem"], [
  #|      @ui.field([
  #|        @ui.field_label(for_="forms-variants-field-region", "Region"),
  #|        @ui.input(
  #|          id="forms-variants-field-region",
  #|          placeholder="Asia Pacific",
  #|        ),
  #|      ]),
  #|      @ui.field([
  #|        @ui.field_label(
  #|          for_="forms-variants-field-channel",
  #|          "Release channel",
  #|        ),
  #|        @ui.input(
  #|          id="forms-variants-field-channel",
  #|          placeholder="Stable",
  #|        ),
  #|      ]),
  #|    ]),
  #|  ]),
  #|)
  #|

///|
const FormsFieldCompositionCode : String =
  #|let (state, set_state) = @rabbita.create_variable((
  #|  "Ada Lovelace",
  #|  "ada@example.com",
  #|  "analytical-engine",
  #|  "Ship the first programmable workspace.",
  #|  false,
  #|))
  #|state.view(state => {
  #|  let (name, email, website, note, submitted) = state
  #|  let email_invalid = email == "invalid"
  #|  @html.div(
  #|    style=["width:min(100%,54rem);margin-inline:auto"],
  #|    @ui.form(
  #|      id="forms-gallery-profile-form",
  #|      name="workspace-profile",
  #|      on_submit=set_state(state => (
  #|        state.0,
  #|        state.1,
  #|        state.2,
  #|        state.3,
  #|        true,
  #|      )),
  #|      @ui.field_set([
  #|        @ui.field_legend("Create a workspace"),
  #|        @ui.field_group(
  #|          style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,18rem),1fr));gap:1.25rem"],
  #|          [
  #|            @ui.form_field(
  #|              name="display-name",
  #|              required=true,
  #|              describedby="forms-gallery-name-description",
  #|              [
  #|                @ui.form_label(for_="forms-gallery-name", "Display name"),
  #|                @ui.form_control(@ui.input(
  #|                  id="forms-gallery-name",
  #|                  name="display-name",
  #|                  value=name,
  #|                  required=true,
  #|                  auto_complete=@html.On,
  #|                  placeholder="Ada Lovelace",
  #|                  on_input=set_state.map(value => state => (
  #|                    value,
  #|                    state.1,
  #|                    state.2,
  #|                    state.3,
  #|                    false,
  #|                  )),
  #|                )),
  #|                @ui.form_description(
  #|                  id="forms-gallery-name-description",
  #|                  "Shown to collaborators across the workspace.",
  #|                ),
  #|              ],
  #|            ),
  #|            @ui.form_field(
  #|              name="email",
  #|              invalid=email_invalid,
  #|              required=true,
  #|              describedby="forms-gallery-email-description",
  #|              errormessage="forms-gallery-email-error",
  #|              [
  #|                @ui.form_label(for_="forms-gallery-email", "Email"),
  #|                @ui.form_control(@ui.input(
  #|                  input_type=@html.Email,
  #|                  id="forms-gallery-email",
  #|                  name="email",
  #|                  value=email,
  #|                  required=true,
  #|                  invalid=email_invalid,
  #|                  auto_complete=@html.On,
  #|                  placeholder="ada@example.com",
  #|                  on_input=set_state.map(value => state => (
  #|                    state.0,
  #|                    value,
  #|                    state.2,
  #|                    state.3,
  #|                    false,
  #|                  )),
  #|                )),
  #|                @ui.form_description(
  #|                  id="forms-gallery-email-description",
  #|                  "Type “invalid” to preview the destructive state.",
  #|                ),
  #|                if email_invalid {
  #|                  @ui.form_message(
  #|                    id="forms-gallery-email-error",
  #|                    "Enter a valid email address.",
  #|                  )
  #|                } else {
  #|                  @html.nothing
  #|                },
  #|              ],
  #|            ),
  #|            @ui.field([
  #|              @ui.field_label(for_="forms-gallery-site", "Workspace URL"),
  #|              @ui.input_group([
  #|                @ui.input_group_addon(
  #|                  for_="forms-gallery-site",
  #|                  @ui.input_group_text("https://"),
  #|                ),
  #|                @ui.input_group_input(
  #|                  id="forms-gallery-site",
  #|                  name="workspace-url",
  #|                  value=website,
  #|                  placeholder="project-name",
  #|                  on_input=set_state.map(value => state => (
  #|                    state.0,
  #|                    state.1,
  #|                    value,
  #|                    state.3,
  #|                    false,
  #|                  )),
  #|                ),
  #|                @ui.input_group_addon(
  #|                  align=@ui.InputInlineEnd,
  #|                  @ui.input_group_text(".moonbit.app"),
  #|                ),
  #|              ]),
  #|              @ui.field_description(
  #|                "Input Group keeps prefixes and suffixes on one control surface.",
  #|              ),
  #|            ]),
  #|            @ui.field([
  #|              @ui.field_label(for_="forms-gallery-note", "Launch note"),
  #|              @ui.textarea(
  #|                id="forms-gallery-note",
  #|                name="launch-note",
  #|                value=note,
  #|                rows=4,
  #|                placeholder="What should collaborators know?",
  #|                on_input=set_state.map(value => state => (
  #|                  state.0,
  #|                  state.1,
  #|                  state.2,
  #|                  value,
  #|                  false,
  #|                )),
  #|              ),
  #|              @ui.field_description(
  #|                "Textarea remains a native, parent-controlled value.",
  #|              ),
  #|            ]),
  #|          ],
  #|        ),
  #|        @html.div(
  #|          style=["display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem"],
  #|          [
  #|            @html.output(
  #|              style=["color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"],
  #|              if submitted {
  #|                "Saved locally — submit default was prevented."
  #|              } else {
  #|                "Edit a field, then submit the native form."
  #|              },
  #|            ),
  #|            @ui.button(type_="submit", "Save workspace"),
  #|          ],
  #|        ),
  #|      ]),
  #|    ),
  #|  )
  #|})
  #|

///|
const FormsInputGroupCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"], [
  #|      @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|      @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|    ]),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|@html.div(
  #|  style=["display:grid;width:min(100%,50rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(1.75rem,5vw,3rem);align-items:start"],
  #|  [
  #|    item("Block add-ons and action", "Supporting text and the action align above and below the input.", @ui.input_group(
  #|      style=["flex-wrap:wrap;align-items:stretch"],
  #|      [
  #|        @ui.input_group_addon(
  #|          align=@ui.InputBlockStart,
  #|          for_="forms-variants-input-group-address",
  #|          @ui.input_group_text("Workspace address"),
  #|        ),
  #|        @ui.input_group_input(
  #|          id="forms-variants-input-group-address",
  #|          placeholder="team.rabbit-tea.dev",
  #|          style=["flex-basis:100%"],
  #|        ),
  #|        @ui.input_group_addon(align=@ui.InputBlockEnd, [
  #|          @ui.input_group_text(style=["flex:1"], "Public after publish"),
  #|          @ui.input_group_button(
  #|            size=@ui.InputButtonSm,
  #|            variant=@ui.Secondary,
  #|            "Copy address",
  #|          ),
  #|        ]),
  #|      ],
  #|    )),
  #|    item("Textarea group", "A multi-line control shares its status and action row.", @ui.input_group(
  #|      style=["flex-wrap:wrap;align-items:stretch"],
  #|      [
  #|        @ui.input_group_addon(
  #|          align=@ui.InputBlockStart,
  #|          for_="forms-variants-input-group-note",
  #|          @ui.input_group_text("Release note"),
  #|        ),
  #|        @ui.input_group_textarea(
  #|          id="forms-variants-input-group-note",
  #|          rows=4,
  #|          placeholder="Describe what changed…",
  #|          style=["min-height:6rem;flex-basis:100%"],
  #|        ),
  #|        @ui.input_group_addon(align=@ui.InputBlockEnd, [
  #|          @ui.input_group_text(style=["flex:1"], "Markdown supported"),
  #|          @ui.input_group_button(size=@ui.InputButtonXs, "Add reference"),
  #|        ]),
  #|      ],
  #|    )),
  #|  ],
  #|)
  #|

///|
const FormsNativeSelectCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"], [
  #|      @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|      @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|    ]),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|@html.div(
  #|  style=["display:grid;width:min(100%,50rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(1.75rem,5vw,3rem);align-items:start"],
  #|  [
  #|    item("Invalid", "A required platform select uses the shared destructive border.", @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|      [
  #|        @ui.label(for_="forms-variants-native-invalid", "Access level"),
  #|        @ui.native_select(
  #|          id="forms-variants-native-invalid",
  #|          invalid=true,
  #|          required=true,
  #|          aria_label="Choose an access level",
  #|          [
  #|            @ui.native_select_option(value="", selected=true, "Choose access"),
  #|            @ui.native_select_option(value="viewer", "Viewer"),
  #|            @ui.native_select_option(value="editor", "Editor"),
  #|          ],
  #|        ),
  #|      ],
  #|    )),
  #|    item("Disabled", "The inherited environment stays visible but cannot be changed.", @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|      [
  #|        @ui.label(for_="forms-variants-native-disabled", disabled=true, "Environment"),
  #|        @ui.native_select(
  #|          id="forms-variants-native-disabled",
  #|          disabled=true,
  #|          aria_label="Inherited environment",
  #|          [
  #|            @ui.native_select_option(value="production", selected=true, "Production"),
  #|            @ui.native_select_option(value="preview", "Preview"),
  #|          ],
  #|        ),
  #|      ],
  #|    )),
  #|  ],
  #|)
  #|

///|
const FormsNativeSelectSizesCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"], [
  #|      @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|      @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|    ]),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|@html.div(
  #|  style=["display:grid;width:min(100%,50rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(1.75rem,5vw,3rem);align-items:start"],
  #|  [
  #|    item("Default with groups", "Native option groups preserve the platform menu and semantics.", @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|      [
  #|        @ui.label(for_="forms-variants-native-default", "Access scope"),
  #|        @ui.native_select(id="forms-variants-native-default", [
  #|          @ui.native_select_optgroup(label="Workspace", [
  #|            @ui.native_select_option(value="personal", "Personal"),
  #|            @ui.native_select_option(value="team", selected=true, "Team"),
  #|          ]),
  #|          @ui.native_select_optgroup(label="Advanced", [
  #|            @ui.native_select_option(value="organization", "Organization"),
  #|          ]),
  #|        ]),
  #|      ],
  #|    )),
  #|    item("Small", "A compact native control for dense settings.", @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|      [
  #|        @ui.label(for_="forms-variants-native-small", "Release channel"),
  #|        @ui.native_select(id="forms-variants-native-small", size=@ui.NativeSelectSm, [
  #|          @ui.native_select_option(value="stable", selected=true, "Stable"),
  #|          @ui.native_select_option(value="preview", "Preview"),
  #|        ]),
  #|      ],
  #|    )),
  #|  ],
  #|)
  #|

///|
const FormsOtpGroupingCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"], [
  #|      @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|      @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|    ]),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|let verification = @ui.input_otp(
  #|  id="forms-variants-otp-default",
  #|  max_length=6,
  #|  separator_after=3,
  #|  aria_label="Verification code",
  #|)
  #|let recovery = @ui.input_otp(
  #|  id="forms-variants-otp-custom",
  #|  max_length=8,
  #|  separator_after=4,
  #|  aria_label="Eight-digit recovery code",
  #|)
  #|verification.view2(recovery, (verification_html, recovery_html) => @html.div(
  #|  style=["display:grid;width:min(100%,50rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(1.75rem,5vw,3rem);align-items:start"],
  #|  [
  #|    item("3 + 3", "Six-digit verification code.", verification_html),
  #|    item("4 + 4", "Eight-digit recovery code.", recovery_html),
  #|  ],
  #|))
  #|

///|
const FormsOtpCode : String =
  #|let item = (title, note, body) => @html.div(
  #|  style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|  [
  #|    @html.div(style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem", "gap:0.25rem"], [
  #|      @html.h5(style=["margin:0;font-size:0.9375rem;line-height:1.375rem;font-weight:650;letter-spacing:-0.015em"], title),
  #|      @html.p(style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.35"], note),
  #|    ]),
  #|    @html.div(style=["min-width:0"], body),
  #|  ],
  #|)
  #|let invalid = @ui.input_otp(
  #|  id="forms-variants-otp-invalid",
  #|  max_length=6,
  #|  separator_after=3,
  #|  invalid=true,
  #|  aria_label="Invalid verification code",
  #|)
  #|let verified = @ui.input_otp(
  #|  id="forms-variants-otp-disabled",
  #|  max_length=6,
  #|  default_value="482931",
  #|  separator_after=3,
  #|  disabled=true,
  #|  aria_label="Previously verified code",
  #|)
  #|invalid.view2(verified, (invalid_html, verified_html) => @html.div(
  #|  style=["display:grid;width:min(100%,50rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(1.75rem,5vw,3rem);align-items:start"],
  #|  [
  #|    item("Invalid and editable", "Enter a replacement code using the same six live slots.", invalid_html),
  #|    item("Disabled", "A previously verified value remains readable.", verified_html),
  #|  ],
  #|))
  #|

///|
fn forms_checkbox_variants() -> @rabbita.Val[@html.Html] {
  let checkbox_mixed = @ui.checkbox(
    id="forms-variants-checkbox-mixed",
    default_indeterminate=true,
    aria_label="Select all projects",
  )
  let checkbox_invalid = @ui.checkbox(
    id="forms-variants-checkbox-invalid",
    invalid=true,
    aria_label="Accept the workspace policy",
  )
  let checkbox_disabled = @ui.checkbox(
    id="forms-variants-checkbox-disabled",
    default_checked=true,
    disabled=true,
    aria_label="Inherited organization policy",
  )
  checkbox_mixed.view3(checkbox_invalid, checkbox_disabled, (
    mixed_html,
    invalid_html,
    disabled_html,
  ) => {
    showcase_component_demos(
      "Checkbox",
      "Mixed, validation, and managed-disabled variants keep their semantics and component-owned interaction.",
      [
        showcase_demo_section(
          "Behavior variants",
          "Each enabled checkbox remains live; the managed value is intentionally unavailable.",
          showcase_demo_stage(
            @html.div(style=[FormsVariantsGridStyle], [
              forms_variant_item(
                "Mixed",
                "Starts indeterminate, then resolves through normal activation.",
                @html.div(style=[FormsVariantControlStyle], [
                  @ui.label(
                    for_="forms-variants-checkbox-mixed",
                    "All projects",
                  ),
                  mixed_html,
                ]),
              ),
              forms_variant_item(
                "Invalid",
                "Validation styling leaves pointer and keyboard behavior intact.",
                @html.div(style=[FormsVariantControlStyle], [
                  @ui.label(
                    for_="forms-variants-checkbox-invalid",
                    "Workspace policy",
                  ),
                  invalid_html,
                ]),
              ),
              forms_variant_item(
                "Disabled",
                "A managed value remains visible without entering the tab order.",
                @html.div(style=[FormsVariantControlStyle], [
                  @ui.label(
                    for_="forms-variants-checkbox-disabled",
                    disabled=true,
                    "Organization policy",
                  ),
                  disabled_html,
                ]),
              ),
            ]),
            FormsCheckboxCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
      ],
    )
  })
}

///|
fn forms_switch_variants() -> @rabbita.Val[@html.Html] {
  let switch_default = @ui.switch(
    id="forms-variants-switch-default",
    default_checked=true,
    aria_label="Enable live previews",
  )
  let switch_small = @ui.switch(
    id="forms-variants-switch-small",
    size=@ui.Sm,
    aria_label="Enable compact activity",
  )
  let switch_invalid = @ui.switch(
    id="forms-variants-switch-invalid",
    invalid=true,
    aria_label="Enable required approval",
  )
  let switch_disabled = @ui.switch(
    id="forms-variants-switch-disabled",
    default_checked=true,
    disabled=true,
    aria_label="Organization-managed backups",
  )
  switch_default.view4(switch_small, switch_invalid, switch_disabled, (
    default_html,
    small_html,
    invalid_html,
    disabled_html,
  ) => {
    showcase_component_demos(
      "Switch",
      "Default and compact sizes stay interactive; validation and managed settings use the same black-box component.",
      [
        showcase_demo_section(
          "Sizes",
          "Use the default control for settings rows and the small control in denser layouts.",
          showcase_demo_stage(
            @html.div(style=[FormsVariantsWideGridStyle], [
              forms_variant_item(
                "Default",
                "The standard control for a settings row.",
                @html.div(style=[FormsVariantControlStyle], [
                  @ui.label(
                    for_="forms-variants-switch-default",
                    "Live previews",
                  ),
                  default_html,
                ]),
              ),
              forms_variant_item(
                "Small",
                "A compact control for denser preference lists.",
                @html.div(style=[FormsVariantControlStyle], [
                  @ui.label(
                    for_="forms-variants-switch-small",
                    "Compact activity",
                  ),
                  small_html,
                ]),
              ),
            ]),
            FormsSwitchSizesCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:14rem",
          ),
        ),
        showcase_demo_section(
          "Validation and availability",
          "The invalid control remains live, while the managed setting is intentionally unavailable.",
          showcase_demo_stage(
            @html.div(style=[FormsVariantsWideGridStyle], [
              forms_variant_item(
                "Invalid",
                "Required-choice styling without replacing interaction.",
                @html.div(style=[FormsVariantControlStyle], [
                  @ui.label(
                    for_="forms-variants-switch-invalid",
                    "Approval required",
                  ),
                  invalid_html,
                ]),
              ),
              forms_variant_item(
                "Disabled",
                "The organization owns this setting.",
                @html.div(style=[FormsVariantControlStyle], [
                  @ui.label(
                    for_="forms-variants-switch-disabled",
                    disabled=true,
                    "Managed backups",
                  ),
                  disabled_html,
                ]),
              ),
            ]),
            FormsSwitchValidationCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:14rem",
          ),
        ),
      ],
    )
  })
}

///|
fn forms_combobox_variants() -> @rabbita.Val[@html.Html] {
  let framework_options = [
    @ui.combobox_option(value="moonbit", label="MoonBit"),
    @ui.combobox_option(value="rabbita", label="Rabbita"),
    @ui.combobox_option(value="typescript", label="TypeScript"),
    @ui.combobox_option(value="rust", label="Rust"),
    @ui.combobox_option(value="legacy", label="Legacy runtime", disabled=true),
  ]
  let multiple = @ui.combobox(
    id="forms-variants-combobox-multiple",
    options=framework_options,
    multiple=true,
    default_values=["moonbit", "rabbita"],
    placeholder="Add a runtime…",
    empty_text="No matching runtimes.",
    name="supported-runtimes",
  )
  let grouped = @ui.combobox(
    id="forms-variants-combobox-grouped",
    options=framework_options,
    default_value="rabbita",
    render=scope => {
      @html.fragment([
        @ui.combobox_trigger(scope~, aria_label="Choose a runtime by group"),
        @ui.combobox_content(
          scope~,
          @ui.combobox_list([
            @ui.combobox_group(
              label_id="forms-variants-combobox-group-core-label",
              [
                @ui.combobox_label(
                  id="forms-variants-combobox-group-core-label",
                  "Core",
                ),
                @ui.combobox_item(scope~, value="moonbit", "MoonBit"),
                @ui.combobox_item(scope~, value="rabbita", "Rabbita"),
              ],
            ),
            @ui.combobox_separator(),
            @ui.combobox_group(
              label_id="forms-variants-combobox-group-host-label",
              [
                @ui.combobox_label(
                  id="forms-variants-combobox-group-host-label",
                  "Host languages",
                ),
                @ui.combobox_item(scope~, value="typescript", "TypeScript"),
                @ui.combobox_item(scope~, value="rust", "Rust"),
                @ui.combobox_item(
                  scope~,
                  value="legacy",
                  disabled=true,
                  "Legacy runtime",
                ),
              ],
            ),
          ]),
        ),
      ])
    },
  )
  let empty = @ui.combobox(
    id="forms-variants-combobox-empty",
    options=[
      @ui.combobox_option(value="alpha", label="Alpha workspace"),
      @ui.combobox_option(value="beta", label="Beta workspace"),
    ],
    placeholder="Search workspaces…",
    empty_text="No workspace matches this search.",
  )
  let invalid = @ui.combobox(
    id="forms-variants-combobox-invalid",
    options=framework_options,
    placeholder="Choose a required runtime…",
    empty_text="No matching runtimes.",
    invalid=true,
    required=true,
  )
  let disabled = @ui.combobox(
    id="forms-variants-combobox-disabled",
    options=framework_options,
    default_value="moonbit",
    disabled=true,
  )
  multiple.view5(grouped, empty, invalid, disabled, (
    multiple_html,
    grouped_html,
    empty_html,
    invalid_html,
    disabled_html,
  ) => {
    showcase_component_demos(
      "Combobox",
      "Single and multiple selection, compound collections, validation, and availability all retain component-owned popup state.",
      [
        showcase_demo_section(
          "Selection and composition",
          "Use multiple selection with removable chips, or compose a grouped collection with the public scope API.",
          showcase_demo_stage(
            @html.div(style=[FormsVariantsWideGridStyle], [
              forms_variant_item(
                "Multiple", "Remove chips, clear the value, or type to add another runtime.",
                multiple_html,
              ),
              forms_variant_item(
                "Grouped", "Core and host-language options share one searchable popup.",
                grouped_html,
              ),
            ]),
            FormsComboboxSelectionCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:17rem",
          ),
        ),
        showcase_demo_section(
          "Search, validation, and availability",
          "Search can expose a real empty result; required and disabled controls preserve their normal semantics.",
          showcase_demo_stage(
            @html.div(style=[FormsVariantsGridStyle], [
              forms_variant_item(
                "Empty result", "Type an unmatched query to reveal the component's empty message.",
                empty_html,
              ),
              forms_variant_item(
                "Invalid", "A required choice keeps search and keyboard interaction available.",
                invalid_html,
              ),
              forms_variant_item(
                "Disabled", "The selected runtime remains readable in a locked control.",
                disabled_html,
              ),
            ]),
            FormsComboboxAvailabilityCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:16rem",
          ),
        ),
      ],
    )
  })
}

///|
fn forms_select_variants() -> @rabbita.Val[@html.Html] {
  let deployment_options = [
    @ui.select_option(value="iad", label="Washington, D.C."),
    @ui.select_option(value="ord", label="Chicago"),
    @ui.select_option(value="dfw", label="Dallas"),
    @ui.select_option(value="sfo", label="San Francisco"),
    @ui.select_option(value="fra", label="Frankfurt"),
    @ui.select_option(value="lhr", label="London"),
    @ui.select_option(value="sin", label="Singapore"),
    @ui.select_option(value="nrt", label="Tokyo"),
    @ui.select_option(value="syd", label="Sydney"),
    @ui.select_option(
      value="legacy-region",
      label="Legacy region",
      disabled=true,
    ),
  ]
  let grouped = @ui.select(
    id="forms-variants-select-grouped",
    options=deployment_options,
    default_value="sfo",
    render=scope => {
      @html.fragment([
        @ui.select_trigger(scope~, aria_label="Choose a deployment region"),
        @ui.select_content(scope~, style=["max-height:13rem"], [
          @ui.select_scroll_up_button(scope~, label="Scroll regions up"),
          @ui.select_group(label_id="forms-variants-select-americas-label", [
            @ui.select_label(
              id="forms-variants-select-americas-label",
              "Americas",
            ),
            @ui.select_item(scope~, value="iad", "Washington, D.C."),
            @ui.select_item(scope~, value="ord", "Chicago"),
            @ui.select_item(scope~, value="dfw", "Dallas"),
            @ui.select_item(scope~, value="sfo", "San Francisco"),
          ]),
          @ui.select_separator(),
          @ui.select_group(label_id="forms-variants-select-emea-label", [
            @ui.select_label(id="forms-variants-select-emea-label", "Europe"),
            @ui.select_item(scope~, value="fra", "Frankfurt"),
            @ui.select_item(scope~, value="lhr", "London"),
          ]),
          @ui.select_separator(),
          @ui.select_group(label_id="forms-variants-select-apac-label", [
            @ui.select_label(
              id="forms-variants-select-apac-label",
              "Asia Pacific",
            ),
            @ui.select_item(scope~, value="sin", "Singapore"),
            @ui.select_item(scope~, value="nrt", "Tokyo"),
            @ui.select_item(scope~, value="syd", "Sydney"),
            @ui.select_item(
              scope~,
              value="legacy-region",
              disabled=true,
              "Legacy region",
            ),
          ]),
          @ui.select_scroll_down_button(scope~, label="Scroll regions down"),
        ]),
      ])
    },
  )
  let invalid = @ui.select(
    id="forms-variants-select-invalid",
    options=deployment_options,
    placeholder="Choose a required region…",
    invalid=true,
    required=true,
  )
  let disabled = @ui.select(
    id="forms-variants-select-disabled",
    options=deployment_options,
    default_value="fra",
    disabled=true,
  )
  grouped.view3(invalid, disabled, (grouped_html, invalid_html, disabled_html) => {
    showcase_component_demos(
      "Select",
      "The compound API adds groups, separators, disabled options, and scroll controls without moving popup state into the showcase.",
      [
        showcase_demo_section(
          "Compound collection",
          "Open the list to browse labeled regions, separators, a disabled option, and scroll controls.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              grouped_html,
            ),
            FormsSelectCompoundCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:16rem",
          ),
        ),
        showcase_demo_section(
          "Validation and availability",
          "A required Select stays interactive; a locked selection stays readable and outside the tab order.",
          showcase_demo_stage(
            @html.div(style=[FormsVariantsWideGridStyle], [
              forms_variant_item(
                "Invalid", "Required styling keeps normal pointer and keyboard behavior.",
                invalid_html,
              ),
              forms_variant_item(
                "Disabled", "The selected region remains legible in a locked control.",
                disabled_html,
              ),
            ]),
            FormsSelectAvailabilityCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:14rem",
          ),
        ),
      ],
    )
  })
}

///|
fn forms_field_variants(form_composition : @html.Html) -> @html.Html {
  showcase_component_demos(
    "Field",
    "Semantic form fields, responsive layouts, Fieldset, and Legend keep labels, descriptions, validation, and grouping explicit.",
    [
      showcase_demo_section(
        "Complete form composition",
        "A real submitted form composes Form Field, labels, controls, descriptions, validation messages, and grouped fields.",
        showcase_demo_stage(
          @html.div(
            style=["width:min(100%,54rem);margin-inline:auto"],
            form_composition,
          ),
          FormsFieldCompositionCode,
          variant=ShowcaseStageSurface,
          stage_style="--rui-showcase-stage-min-height:34rem",
        ),
      ),
      showcase_demo_section(
        "Layouts",
        "Horizontal fields share a row; responsive fields stack when their container narrows.",
        showcase_demo_stage(
          @html.div(style=[FormsVariantsWideGridStyle], [
            forms_variant_item(
              "Horizontal",
              "A compact label and control share one row.",
              @ui.field(orientation=@ui.FieldHorizontal, [
                @ui.field_label(
                  for_="forms-variants-field-horizontal",
                  style=["width:7rem;flex:none"],
                  "Project",
                ),
                @ui.field_content([
                  @ui.input(
                    id="forms-variants-field-horizontal",
                    placeholder="rabbit-tea",
                  ),
                  @ui.field_description("Used in generated workspace URLs."),
                ]),
              ]),
            ),
            forms_variant_item(
              "Responsive",
              "The label stacks when the field container becomes narrow.",
              @ui.field(orientation=@ui.FieldResponsive, [
                @ui.field_label(
                  for_="forms-variants-field-responsive",
                  "Repository",
                ),
                @ui.field_content([
                  @ui.input(
                    id="forms-variants-field-responsive",
                    placeholder="moonbit-community/rabbita",
                  ),
                  @ui.field_description("Paste a repository path or URL."),
                ]),
              ]),
            ),
          ]),
          FormsFieldLayoutsCode,
          variant=ShowcaseStagePlain,
          stage_style="--rui-showcase-stage-min-height:17rem",
        ),
      ),
      showcase_demo_section(
        "Fieldset and legend",
        "Related delivery settings share a native legend and field group.",
        showcase_demo_stage(
          @html.div(
            style=["width:min(100%,34rem);margin-inline:auto"],
            @ui.field_set([
              @ui.field_legend(
                variant=@ui.FieldLabelLegend,
                "Delivery settings",
              ),
              @ui.field_group(style=["gap:1rem"], [
                @ui.field([
                  @ui.field_label(for_="forms-variants-field-region", "Region"),
                  @ui.input(
                    id="forms-variants-field-region",
                    placeholder="Asia Pacific",
                  ),
                ]),
                @ui.field([
                  @ui.field_label(
                    for_="forms-variants-field-channel",
                    "Release channel",
                  ),
                  @ui.input(
                    id="forms-variants-field-channel",
                    placeholder="Stable",
                  ),
                ]),
              ]),
            ]),
          ),
          FormsFieldsetCode,
          variant=ShowcaseStageSurface,
          stage_style="--rui-showcase-stage-min-height:19rem",
        ),
      ),
    ],
  )
}

///|
fn forms_input_group_variants() -> @html.Html {
  showcase_component_demos(
    "Input Group",
    "Block add-ons, embedded actions, and textarea controls stay inside one public compound surface.",
    [
      showcase_demo_section(
        "Block add-ons and textarea",
        "Both compositions use one compound surface without an extra specimen frame.",
        showcase_demo_stage(
          @html.div(style=[FormsVariantsWideGridStyle], [
            forms_variant_item(
              "Block add-ons and action",
              "Supporting text and the action align above and below the input.",
              @ui.input_group(style=["flex-wrap:wrap;align-items:stretch"], [
                @ui.input_group_addon(
                  align=@ui.InputBlockStart,
                  for_="forms-variants-input-group-address",
                  @ui.input_group_text("Workspace address"),
                ),
                @ui.input_group_input(
                  id="forms-variants-input-group-address",
                  placeholder="team.rabbit-tea.dev",
                  style=["flex-basis:100%"],
                ),
                @ui.input_group_addon(align=@ui.InputBlockEnd, [
                  @ui.input_group_text(style=["flex:1"], "Public after publish"),
                  @ui.input_group_button(
                    size=@ui.InputButtonSm,
                    variant=@ui.Secondary,
                    "Copy address",
                  ),
                ]),
              ]),
            ),
            forms_variant_item(
              "Textarea group",
              "A multi-line control shares its status and action row.",
              @ui.input_group(style=["flex-wrap:wrap;align-items:stretch"], [
                @ui.input_group_addon(
                  align=@ui.InputBlockStart,
                  for_="forms-variants-input-group-note",
                  @ui.input_group_text("Release note"),
                ),
                @ui.input_group_textarea(
                  id="forms-variants-input-group-note",
                  rows=4,
                  placeholder="Describe what changed…",
                  style=["min-height:6rem;flex-basis:100%"],
                ),
                @ui.input_group_addon(align=@ui.InputBlockEnd, [
                  @ui.input_group_text(style=["flex:1"], "Markdown supported"),
                  @ui.input_group_button(
                    size=@ui.InputButtonXs,
                    "Add reference",
                  ),
                ]),
              ]),
            ),
          ]),
          FormsInputGroupCode,
          variant=ShowcaseStageSurface,
          stage_style="--rui-showcase-stage-min-height:19rem",
        ),
      ),
    ],
  )
}

///|
fn forms_native_select_variants() -> @html.Html {
  showcase_component_demos(
    "Native Select",
    "Sizes, grouped options, validation, and managed-disabled variants keep the platform-native menu while matching the shared control surface.",
    [
      showcase_demo_section(
        "Sizes and groups",
        "The default control supports native option groups; the small size fits denser forms.",
        showcase_demo_stage(
          @html.div(style=[FormsVariantsWideGridStyle], [
            forms_variant_item(
              "Default with groups",
              "Native option groups preserve the platform menu and semantics.",
              @html.div(style=[FormsVariantColumnStyle], [
                @ui.label(for_="forms-variants-native-default", "Access scope"),
                @ui.native_select(id="forms-variants-native-default", [
                  @ui.native_select_optgroup(label="Workspace", [
                    @ui.native_select_option(value="personal", "Personal"),
                    @ui.native_select_option(
                      value="team",
                      selected=true,
                      "Team",
                    ),
                  ]),
                  @ui.native_select_optgroup(label="Advanced", [
                    @ui.native_select_option(
                      value="organization",
                      "Organization",
                    ),
                  ]),
                ]),
              ]),
            ),
            forms_variant_item(
              "Small",
              "A compact native control for dense settings.",
              @html.div(style=[FormsVariantColumnStyle], [
                @ui.label(for_="forms-variants-native-small", "Release channel"),
                @ui.native_select(
                  id="forms-variants-native-small",
                  size=@ui.NativeSelectSm,
                  [
                    @ui.native_select_option(
                      value="stable",
                      selected=true,
                      "Stable",
                    ),
                    @ui.native_select_option(value="preview", "Preview"),
                  ],
                ),
              ]),
            ),
          ]),
          FormsNativeSelectSizesCode,
          variant=ShowcaseStageSurface,
          stage_style="--rui-showcase-stage-min-height:15rem",
        ),
      ),
      showcase_demo_section(
        "Validation and availability",
        "The invalid control stays selectable; the inherited environment remains readable but unavailable.",
        showcase_demo_stage(
          @html.div(style=[FormsVariantsWideGridStyle], [
            forms_variant_item(
              "Invalid",
              "A required platform select uses the shared destructive border.",
              @html.div(style=[FormsVariantColumnStyle], [
                @ui.label(for_="forms-variants-native-invalid", "Access level"),
                @ui.native_select(
                  id="forms-variants-native-invalid",
                  invalid=true,
                  required=true,
                  aria_label="Choose an access level",
                  [
                    @ui.native_select_option(
                      value="",
                      selected=true,
                      "Choose access",
                    ),
                    @ui.native_select_option(value="viewer", "Viewer"),
                    @ui.native_select_option(value="editor", "Editor"),
                  ],
                ),
              ]),
            ),
            forms_variant_item(
              "Disabled",
              "The inherited environment stays visible but cannot be changed.",
              @html.div(style=[FormsVariantColumnStyle], [
                @ui.label(
                  for_="forms-variants-native-disabled",
                  disabled=true,
                  "Environment",
                ),
                @ui.native_select(
                  id="forms-variants-native-disabled",
                  disabled=true,
                  aria_label="Inherited environment",
                  [
                    @ui.native_select_option(
                      value="production",
                      selected=true,
                      "Production",
                    ),
                    @ui.native_select_option(value="preview", "Preview"),
                  ],
                ),
              ]),
            ),
          ]),
          FormsNativeSelectCode,
          variant=ShowcaseStagePlain,
          stage_style="--rui-showcase-stage-min-height:15rem",
        ),
      ),
    ],
  )
}

///|
fn forms_otp_variants() -> @rabbita.Val[@html.Html] {
  let default = @ui.input_otp(
    id="forms-variants-otp-default",
    max_length=6,
    separator_after=3,
    aria_label="Verification code",
  )
  let custom = @ui.input_otp(
    id="forms-variants-otp-custom",
    max_length=8,
    separator_after=4,
    aria_label="Eight-digit recovery code",
  )
  let invalid = @ui.input_otp(
    id="forms-variants-otp-invalid",
    max_length=6,
    separator_after=3,
    invalid=true,
    aria_label="Invalid verification code",
  )
  let disabled = @ui.input_otp(
    id="forms-variants-otp-disabled",
    max_length=6,
    default_value="482931",
    separator_after=3,
    disabled=true,
    aria_label="Previously verified code",
  )
  default.view4(custom, invalid, disabled, (
    default_html,
    custom_html,
    invalid_html,
    disabled_html,
  ) => {
    showcase_component_demos(
      "Input OTP",
      "Default and custom groupings remain editable; validation and disabled variants preserve the same slot composition.",
      [
        showcase_demo_section(
          "Grouping",
          "Use the default 3 + 3 verification layout or a custom 4 + 4 recovery-code layout.",
          showcase_demo_stage(
            @html.div(style=[FormsVariantsWideGridStyle], [
              forms_variant_item(
                "3 + 3", "Six-digit verification code.", default_html,
              ),
              forms_variant_item(
                "4 + 4", "Eight-digit recovery code.", custom_html,
              ),
            ]),
            FormsOtpGroupingCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
        showcase_demo_section(
          "Validation and availability",
          "The editable error and previously verified value share the same grouped slot composition.",
          showcase_demo_stage(
            @html.div(style=[FormsVariantsWideGridStyle], [
              forms_variant_item(
                "Invalid and editable", "Enter a replacement code using the same six live slots.",
                invalid_html,
              ),
              forms_variant_item(
                "Disabled", "A previously verified value remains readable.", disabled_html,
              ),
            ]),
            FormsOtpCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
      ],
    )
  })
}

///|
fn forms_variants_gallery() -> @rabbita.Val[@html.Html] {
  let checkbox_variants = forms_checkbox_variants()
  let switch_variants = forms_switch_variants()
  let combobox_variants = forms_combobox_variants()
  let select_variants = forms_select_variants()
  let otp_variants = forms_otp_variants()
  checkbox_variants.view5(
    switch_variants,
    combobox_variants,
    select_variants,
    otp_variants,
    (checkbox_html, switch_html, combobox_html, select_html, otp_html) => {
      @html.div(style=[FormsVariantsStackStyle], [
        checkbox_html,
        switch_html,
        combobox_html,
        select_html,
        forms_input_group_variants(),
        forms_native_select_variants(),
        otp_html,
      ])
    },
  )
}
