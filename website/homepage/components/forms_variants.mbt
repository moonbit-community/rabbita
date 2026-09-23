///|
const FormsVariantControlStyle : String = "display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"

///|
const FormsVariantColumnStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.625rem"

///|
const FormsCheckboxMixedCode : String =
  #|let mixed = @rui.checkbox(
  #|  id="forms-variants-checkbox-mixed",
  #|  default_indeterminate=true,
  #|  aria_label="Select all projects",
  #|)
  #|mixed.view(mixed_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|    [@rui.label(for_="forms-variants-checkbox-mixed", "All projects"), mixed_html],
  #|  ),
  #|))
  #|

///|
const FormsCheckboxInvalidCode : String =
  #|let invalid = @rui.checkbox(
  #|  id="forms-variants-checkbox-invalid",
  #|  invalid=true,
  #|  aria_label="Accept the workspace policy",
  #|)
  #|invalid.view(invalid_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|    [@rui.label(for_="forms-variants-checkbox-invalid", "Workspace policy"), invalid_html],
  #|  ),
  #|))
  #|

///|
const FormsCheckboxDisabledCode : String =
  #|let disabled = @rui.checkbox(
  #|  id="forms-variants-checkbox-disabled",
  #|  default_checked=true,
  #|  disabled=true,
  #|  aria_label="Inherited organization policy",
  #|)
  #|disabled.view(disabled_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|    [
  #|      @rui.label(for_="forms-variants-checkbox-disabled", disabled=true, "Organization policy"),
  #|      disabled_html,
  #|    ],
  #|  ),
  #|))
  #|

///|
const FormsSwitchDefaultCode : String =
  #|let previews = @rui.switch(
  #|  id="forms-variants-switch-default",
  #|  default_checked=true,
  #|  aria_label="Enable live previews",
  #|)
  #|previews.view(previews_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|    [@rui.label(for_="forms-variants-switch-default", "Live previews"), previews_html],
  #|  ),
  #|))
  #|

///|
const FormsSwitchSmallCode : String =
  #|let activity = @rui.switch(
  #|  id="forms-variants-switch-small",
  #|  size=@rui.Sm,
  #|  aria_label="Enable compact activity",
  #|)
  #|activity.view(activity_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|      [@rui.label(for_="forms-variants-switch-small", "Compact activity"), activity_html],
  #|  ),
  #|))
  #|

///|
const FormsSwitchInvalidCode : String =
  #|let approval = @rui.switch(
  #|  id="forms-variants-switch-invalid",
  #|  invalid=true,
  #|  aria_label="Enable required approval",
  #|)
  #|approval.view(approval_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|    [@rui.label(for_="forms-variants-switch-invalid", "Approval required"), approval_html],
  #|  ),
  #|))
  #|

///|
const FormsSwitchDisabledCode : String =
  #|let backups = @rui.switch(
  #|  id="forms-variants-switch-disabled",
  #|  default_checked=true,
  #|  disabled=true,
  #|  aria_label="Organization-managed backups",
  #|)
  #|backups.view(backups_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex:1;align-items:center;justify-content:space-between;gap:1rem"],
  #|    [
  #|      @rui.label(for_="forms-variants-switch-disabled", disabled=true, "Managed backups"),
  #|      backups_html,
  #|    ],
  #|  ),
  #|))
  #|

///|
const FormsComboboxMultipleCode : String =
  #|let options = [
  #|  @rui.combobox_option(value="moonbit", label="MoonBit"),
  #|  @rui.combobox_option(value="rabbita", label="Rabbita"),
  #|  @rui.combobox_option(value="typescript", label="TypeScript"),
  #|  @rui.combobox_option(value="rust", label="Rust"),
  #|  @rui.combobox_option(value="legacy", label="Legacy runtime", disabled=true),
  #|]
  #|let multiple = @rui.combobox(
  #|  id="forms-variants-combobox-multiple",
  #|  options=options,
  #|  multiple=true,
  #|  default_values=["moonbit", "rabbita"],
  #|  placeholder="Add a runtime…",
  #|  empty_text="No matching runtimes.",
  #|  name="supported-runtimes",
  #|)
  #|multiple.view(multiple_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  multiple_html,
  #|))
  #|

///|
const FormsComboboxGroupedCode : String =
  #|let options = [
  #|  @rui.combobox_option(value="moonbit", label="MoonBit"),
  #|  @rui.combobox_option(value="rabbita", label="Rabbita"),
  #|  @rui.combobox_option(value="typescript", label="TypeScript"),
  #|  @rui.combobox_option(value="rust", label="Rust"),
  #|  @rui.combobox_option(value="legacy", label="Legacy runtime", disabled=true),
  #|]
  #|let grouped = @rui.combobox(
  #|  id="forms-variants-combobox-grouped",
  #|  options=options,
  #|  default_value="rabbita",
  #|  render=scope => @html.fragment([
  #|    @rui.combobox_trigger(scope~, aria_label="Choose a runtime by group"),
  #|    @rui.combobox_content(scope~, @rui.combobox_list([
  #|      @rui.combobox_group(label_id="forms-variants-combobox-group-core-label", [
  #|        @rui.combobox_label(id="forms-variants-combobox-group-core-label", "Core"),
  #|        @rui.combobox_item(scope~, value="moonbit", "MoonBit"),
  #|        @rui.combobox_item(scope~, value="rabbita", "Rabbita"),
  #|      ]),
  #|      @rui.combobox_separator(),
  #|      @rui.combobox_group(label_id="forms-variants-combobox-group-host-label", [
  #|        @rui.combobox_label(id="forms-variants-combobox-group-host-label", "Host languages"),
  #|        @rui.combobox_item(scope~, value="typescript", "TypeScript"),
  #|        @rui.combobox_item(scope~, value="rust", "Rust"),
  #|        @rui.combobox_item(scope~, value="legacy", disabled=true, "Legacy runtime"),
  #|      ]),
  #|    ])),
  #|  ]),
  #|)
  #|grouped.view(grouped_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  grouped_html,
  #|))
  #|

///|
const FormsComboboxEmptyCode : String =
  #|let empty = @rui.combobox(
  #|  id="forms-variants-combobox-empty",
  #|  options=[
  #|    @rui.combobox_option(value="alpha", label="Alpha workspace"),
  #|    @rui.combobox_option(value="beta", label="Beta workspace"),
  #|  ],
  #|  placeholder="Search workspaces…",
  #|  empty_text="No workspace matches this search.",
  #|)
  #|empty.view(empty_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  empty_html,
  #|))
  #|

///|
const FormsComboboxInvalidCode : String =
  #|let options = [
  #|  @rui.combobox_option(value="moonbit", label="MoonBit"),
  #|  @rui.combobox_option(value="rabbita", label="Rabbita"),
  #|  @rui.combobox_option(value="typescript", label="TypeScript"),
  #|  @rui.combobox_option(value="rust", label="Rust"),
  #|  @rui.combobox_option(value="legacy", label="Legacy runtime", disabled=true),
  #|]
  #|let invalid = @rui.combobox(
  #|  id="forms-variants-combobox-invalid",
  #|  options=options,
  #|  placeholder="Choose a required runtime…",
  #|  empty_text="No matching runtimes.",
  #|  invalid=true,
  #|  required=true,
  #|)
  #|invalid.view(invalid_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  invalid_html,
  #|))
  #|

///|
const FormsComboboxDisabledCode : String =
  #|let options = [
  #|  @rui.combobox_option(value="moonbit", label="MoonBit"),
  #|  @rui.combobox_option(value="rabbita", label="Rabbita"),
  #|  @rui.combobox_option(value="typescript", label="TypeScript"),
  #|  @rui.combobox_option(value="rust", label="Rust"),
  #|  @rui.combobox_option(value="legacy", label="Legacy runtime", disabled=true),
  #|]
  #|let disabled = @rui.combobox(
  #|  id="forms-variants-combobox-disabled",
  #|  options=options,
  #|  default_value="moonbit",
  #|  disabled=true,
  #|)
  #|disabled.view(disabled_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  disabled_html,
  #|))
  #|

///|
const FormsSelectCompoundCode : String =
  #|let options = [
  #|  @rui.select_option(value="iad", label="Washington, D.C."),
  #|  @rui.select_option(value="ord", label="Chicago"),
  #|  @rui.select_option(value="dfw", label="Dallas"),
  #|  @rui.select_option(value="sfo", label="San Francisco"),
  #|  @rui.select_option(value="fra", label="Frankfurt"),
  #|  @rui.select_option(value="lhr", label="London"),
  #|  @rui.select_option(value="sin", label="Singapore"),
  #|  @rui.select_option(value="nrt", label="Tokyo"),
  #|  @rui.select_option(value="syd", label="Sydney"),
  #|  @rui.select_option(value="legacy-region", label="Legacy region", disabled=true),
  #|]
  #|let grouped = @rui.select(
  #|  id="forms-variants-select-grouped",
  #|  options=options,
  #|  default_value="sfo",
  #|  render=scope => @html.fragment([
  #|    @rui.select_trigger(scope~, aria_label="Choose a deployment region"),
  #|    @rui.select_content(scope~, style=["max-height:13rem"], [
  #|      @rui.select_scroll_up_button(scope~, label="Scroll regions up"),
  #|      @rui.select_group(label_id="forms-variants-select-americas-label", [
  #|        @rui.select_label(id="forms-variants-select-americas-label", "Americas"),
  #|        @rui.select_item(scope~, value="iad", "Washington, D.C."),
  #|        @rui.select_item(scope~, value="ord", "Chicago"),
  #|        @rui.select_item(scope~, value="dfw", "Dallas"),
  #|        @rui.select_item(scope~, value="sfo", "San Francisco"),
  #|      ]),
  #|      @rui.select_separator(),
  #|      @rui.select_group(label_id="forms-variants-select-emea-label", [
  #|        @rui.select_label(id="forms-variants-select-emea-label", "Europe"),
  #|        @rui.select_item(scope~, value="fra", "Frankfurt"),
  #|        @rui.select_item(scope~, value="lhr", "London"),
  #|      ]),
  #|      @rui.select_separator(),
  #|      @rui.select_group(label_id="forms-variants-select-apac-label", [
  #|        @rui.select_label(id="forms-variants-select-apac-label", "Asia Pacific"),
  #|        @rui.select_item(scope~, value="sin", "Singapore"),
  #|        @rui.select_item(scope~, value="nrt", "Tokyo"),
  #|        @rui.select_item(scope~, value="syd", "Sydney"),
  #|        @rui.select_item(scope~, value="legacy-region", disabled=true, "Legacy region"),
  #|      ]),
  #|      @rui.select_scroll_down_button(scope~, label="Scroll regions down"),
  #|    ]),
  #|  ]),
  #|)
  #|grouped.view(grouped_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  grouped_html,
  #|))
  #|

///|
const FormsSelectInvalidCode : String =
  #|let options = [
  #|  @rui.select_option(value="iad", label="Washington, D.C."),
  #|  @rui.select_option(value="ord", label="Chicago"),
  #|  @rui.select_option(value="dfw", label="Dallas"),
  #|  @rui.select_option(value="sfo", label="San Francisco"),
  #|  @rui.select_option(value="fra", label="Frankfurt"),
  #|  @rui.select_option(value="lhr", label="London"),
  #|  @rui.select_option(value="sin", label="Singapore"),
  #|  @rui.select_option(value="nrt", label="Tokyo"),
  #|  @rui.select_option(value="syd", label="Sydney"),
  #|  @rui.select_option(value="legacy-region", label="Legacy region", disabled=true),
  #|]
  #|let invalid = @rui.select(
  #|  id="forms-variants-select-invalid",
  #|  options=options,
  #|  placeholder="Choose a required region…",
  #|  invalid=true,
  #|  required=true,
  #|)
  #|invalid.view(invalid_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  invalid_html,
  #|))
  #|

///|
const FormsSelectDisabledCode : String =
  #|let options = [
  #|  @rui.select_option(value="iad", label="Washington, D.C."),
  #|  @rui.select_option(value="ord", label="Chicago"),
  #|  @rui.select_option(value="dfw", label="Dallas"),
  #|  @rui.select_option(value="sfo", label="San Francisco"),
  #|  @rui.select_option(value="fra", label="Frankfurt"),
  #|  @rui.select_option(value="lhr", label="London"),
  #|  @rui.select_option(value="sin", label="Singapore"),
  #|  @rui.select_option(value="nrt", label="Tokyo"),
  #|  @rui.select_option(value="syd", label="Sydney"),
  #|  @rui.select_option(value="legacy-region", label="Legacy region", disabled=true),
  #|]
  #|let disabled = @rui.select(
  #|  id="forms-variants-select-disabled",
  #|  options=options,
  #|  default_value="fra",
  #|  disabled=true,
  #|)
  #|disabled.view(disabled_html => @html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  disabled_html,
  #|))
  #|

///|
const FormsFieldHorizontalCode : String =
  #|@html.div(
  #|  style=["width:min(100%,30rem);margin-inline:auto"],
  #|  @rui.field(
  #|      orientation=@rui.FieldHorizontal,
  #|      [
  #|        @rui.field_label(
  #|          for_="forms-variants-field-horizontal",
  #|          style=["width:7rem;flex:none"],
  #|          "Project",
  #|        ),
  #|        @rui.field_content([
  #|          @rui.input(id="forms-variants-field-horizontal", placeholder="rabbit-tea"),
  #|          @rui.field_description("Used in generated workspace URLs."),
  #|        ]),
  #|      ],
  #|  ),
  #|)
  #|

///|
const FormsFieldResponsiveCode : String =
  #|@rui.field_group(
  #|  style=["width:min(100%,30rem);margin-inline:auto"],
  #|  @rui.field(
  #|      orientation=@rui.FieldResponsive,
  #|      [
  #|        @rui.field_label(
  #|          for_="forms-variants-field-responsive",
  #|          style=["width:7rem;flex:none"],
  #|          "Repository",
  #|        ),
  #|        @rui.field_content([
  #|          @rui.input(
  #|            id="forms-variants-field-responsive",
  #|            placeholder="moonbit-community/rabbita",
  #|          ),
  #|          @rui.field_description("Paste a repository path or URL."),
  #|        ]),
  #|      ],
  #|  ),
  #|)
  #|

///|
const FormsFieldsetCode : String =
  #|@html.div(
  #|  style=["width:min(100%,34rem);margin-inline:auto"],
  #|  @rui.field_set([
  #|    @rui.field_legend(variant=@rui.FieldLabelLegend, "Delivery settings"),
  #|    @rui.field_group(style=["gap:1rem"], [
  #|      @rui.field([
  #|        @rui.field_label(for_="forms-variants-field-region", "Region"),
  #|        @rui.input(
  #|          id="forms-variants-field-region",
  #|          placeholder="Asia Pacific",
  #|        ),
  #|      ]),
  #|      @rui.field([
  #|        @rui.field_label(
  #|          for_="forms-variants-field-channel",
  #|          "Release channel",
  #|        ),
  #|        @rui.input(
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
  #|    @rui.form(
  #|      id="forms-gallery-profile-form",
  #|      name="workspace-profile",
  #|      on_submit=set_state(state => (
  #|        state.0,
  #|        state.1,
  #|        state.2,
  #|        state.3,
  #|        true,
  #|      )),
  #|      @rui.field_set([
  #|        @rui.field_legend("Create a workspace"),
  #|        @rui.field_group(
  #|          style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,18rem),1fr));gap:1.25rem"],
  #|          [
  #|            @rui.form_field(
  #|              name="display-name",
  #|              required=true,
  #|              describedby="forms-gallery-name-description",
  #|              [
  #|                @rui.form_label(for_="forms-gallery-name", "Display name"),
  #|                @rui.form_control(@rui.input(
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
  #|                @rui.form_description(
  #|                  id="forms-gallery-name-description",
  #|                  "Shown to collaborators across the workspace.",
  #|                ),
  #|              ],
  #|            ),
  #|            @rui.form_field(
  #|              name="email",
  #|              invalid=email_invalid,
  #|              required=true,
  #|              describedby="forms-gallery-email-description",
  #|              errormessage="forms-gallery-email-error",
  #|              [
  #|                @rui.form_label(for_="forms-gallery-email", "Email"),
  #|                @rui.form_control(@rui.input(
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
  #|                @rui.form_description(
  #|                  id="forms-gallery-email-description",
  #|                  "Type “invalid” to preview the destructive state.",
  #|                ),
  #|                if email_invalid {
  #|                  @rui.form_message(
  #|                    id="forms-gallery-email-error",
  #|                    "Enter a valid email address.",
  #|                  )
  #|                } else {
  #|                  @html.nothing
  #|                },
  #|              ],
  #|            ),
  #|            @rui.field([
  #|              @rui.field_label(for_="forms-gallery-site", "Workspace URL"),
  #|              @rui.input_group([
  #|                @rui.input_group_addon(
  #|                  for_="forms-gallery-site",
  #|                  @rui.input_group_text("https://"),
  #|                ),
  #|                @rui.input_group_input(
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
  #|                @rui.input_group_addon(
  #|                  align=@rui.InputInlineEnd,
  #|                  @rui.input_group_text(".moonbit.app"),
  #|                ),
  #|              ]),
  #|              @rui.field_description(
  #|                "Input Group keeps prefixes and suffixes on one control surface.",
  #|              ),
  #|            ]),
  #|            @rui.field([
  #|              @rui.field_label(for_="forms-gallery-note", "Launch note"),
  #|              @rui.textarea(
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
  #|              @rui.field_description(
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
  #|            @rui.button(type_="submit", "Save workspace"),
  #|          ],
  #|        ),
  #|      ]),
  #|    ),
  #|  )
  #|})
  #|

///|
const FormsNativeSelectInvalidCode : String =
  #|@html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|      [
  #|        @rui.label(for_="forms-variants-native-invalid", "Access level"),
  #|        @rui.native_select(
  #|          id="forms-variants-native-invalid",
  #|          invalid=true,
  #|          required=true,
  #|          aria_label="Choose an access level",
  #|          [
  #|            @rui.native_select_option(value="", selected=true, "Choose access"),
  #|            @rui.native_select_option(value="viewer", "Viewer"),
  #|            @rui.native_select_option(value="editor", "Editor"),
  #|          ],
  #|        ),
  #|      ],
  #|  ),
  #|)
  #|

///|
const FormsNativeSelectDisabledCode : String =
  #|@html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|      [
  #|        @rui.label(for_="forms-variants-native-disabled", disabled=true, "Environment"),
  #|        @rui.native_select(
  #|          id="forms-variants-native-disabled",
  #|          disabled=true,
  #|          aria_label="Inherited environment",
  #|          [
  #|            @rui.native_select_option(value="production", selected=true, "Production"),
  #|            @rui.native_select_option(value="preview", "Preview"),
  #|          ],
  #|        ),
  #|      ],
  #|  ),
  #|)
  #|

///|
const FormsNativeSelectDefaultGroupsCode : String =
  #|@html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|      [
  #|        @rui.label(for_="forms-variants-native-default", "Access scope"),
  #|        @rui.native_select(id="forms-variants-native-default", [
  #|          @rui.native_select_optgroup(label="Workspace", [
  #|            @rui.native_select_option(value="personal", "Personal"),
  #|            @rui.native_select_option(value="team", selected=true, "Team"),
  #|          ]),
  #|          @rui.native_select_optgroup(label="Advanced", [
  #|            @rui.native_select_option(value="organization", "Organization"),
  #|          ]),
  #|        ]),
  #|      ],
  #|  ),
  #|)
  #|

///|
const FormsNativeSelectSmallCode : String =
  #|@html.div(
  #|  style=["width:min(100%,24rem);margin-inline:auto"],
  #|  @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.625rem"],
  #|      [
  #|        @rui.label(for_="forms-variants-native-small", "Release channel"),
  #|        @rui.native_select(id="forms-variants-native-small", size=@rui.NativeSelectSm, [
  #|          @rui.native_select_option(value="stable", selected=true, "Stable"),
  #|          @rui.native_select_option(value="preview", "Preview"),
  #|        ]),
  #|      ],
  #|  ),
  #|)
  #|

///|
const FormsOtpContinuousCode : String =
  #|let continuous = @rui.input_otp(
  #|  id="forms-variants-otp-continuous",
  #|  max_length=6,
  #|  aria_label="Verification code",
  #|)
  #|continuous.view(continuous_html => @html.div(
  #|  style=["display:flex;justify-content:center"],
  #|  continuous_html,
  #|))
  #|

///|
const FormsOtpPatternCode : String =
  #|let digits = @rui.input_otp(
  #|  id="forms-variants-otp-pattern",
  #|  max_length=6,
  #|  pattern="[0-9]*",
  #|  aria_label="Digits only",
  #|)
  #|digits.view(digits_html => @rui.field(
  #|  style=["width:fit-content;margin-inline:auto"],
  #|  [
  #|    @rui.field_label(for_="forms-variants-otp-pattern", "Digits Only"),
  #|    digits_html,
  #|  ],
  #|))
  #|

///|
const FormsOtpSeparatorCode : String =
  #|let paired = @rui.input_otp(
  #|  id="forms-variants-otp-separator",
  #|  max_length=6,
  #|  aria_label="Paired verification code",
  #|  render=scope => @html.fragment([
  #|    @rui.input_otp_group([
  #|      @rui.input_otp_slot(scope~, index=0),
  #|      @rui.input_otp_slot(scope~, index=1),
  #|    ]),
  #|    @rui.input_otp_separator(),
  #|    @rui.input_otp_group([
  #|      @rui.input_otp_slot(scope~, index=2),
  #|      @rui.input_otp_slot(scope~, index=3),
  #|    ]),
  #|    @rui.input_otp_separator(),
  #|    @rui.input_otp_group([
  #|      @rui.input_otp_slot(scope~, index=4),
  #|      @rui.input_otp_slot(scope~, index=5),
  #|    ]),
  #|  ]),
  #|)
  #|paired.view(paired_html => @html.div(
  #|  style=["display:flex;justify-content:center"],
  #|  paired_html,
  #|))
  #|

///|
const FormsOtpDefaultCode : String =
  #|let verification = @rui.input_otp(
  #|  id="forms-variants-otp-default",
  #|  max_length=6,
  #|  separator_after=3,
  #|  aria_label="Verification code",
  #|)
  #|verification.view(verification_html => @html.div(
  #|  style=["display:flex;justify-content:center"],
  #|  verification_html,
  #|))
  #|

///|
const FormsOtpCustomCode : String =
  #|let recovery = @rui.input_otp(
  #|  id="forms-variants-otp-custom",
  #|  max_length=8,
  #|  separator_after=4,
  #|  aria_label="Eight-digit recovery code",
  #|)
  #|recovery.view(recovery_html => @html.div(
  #|  style=["display:flex;justify-content:center"],
  #|  recovery_html,
  #|))
  #|

///|
const FormsOtpFourDigitsCode : String =
  #|let pin = @rui.input_otp(
  #|  id="forms-variants-otp-four-digits",
  #|  max_length=4,
  #|  pattern="[0-9]*",
  #|  aria_label="Four-digit PIN",
  #|)
  #|pin.view(pin_html => @html.div(
  #|  style=["display:flex;justify-content:center"],
  #|  pin_html,
  #|))
  #|

///|
const FormsOtpAlphanumericCode : String =
  #|let code = @rui.input_otp(
  #|  id="forms-variants-otp-alphanumeric",
  #|  max_length=6,
  #|  default_value="A1B2C3",
  #|  separator_after=3,
  #|  inputmode="text",
  #|  pattern="[A-Za-z0-9]*",
  #|  aria_label="Alphanumeric verification code",
  #|)
  #|code.view(code_html => @html.div(
  #|  style=["display:flex;justify-content:center"],
  #|  code_html,
  #|))
  #|

///|
const FormsOtpInvalidCode : String =
  #|let invalid = @rui.input_otp(
  #|  id="forms-variants-otp-invalid",
  #|  max_length=6,
  #|  separator_after=3,
  #|  invalid=true,
  #|  aria_label="Invalid verification code",
  #|)
  #|invalid.view(invalid_html => @html.div(
  #|  style=["display:flex;justify-content:center"],
  #|  invalid_html,
  #|))
  #|

///|
const FormsOtpDisabledCode : String =
  #|let verified = @rui.input_otp(
  #|  id="forms-variants-otp-disabled",
  #|  max_length=6,
  #|  default_value="482931",
  #|  separator_after=3,
  #|  disabled=true,
  #|  aria_label="Previously verified code",
  #|)
  #|verified.view(verified_html => @html.div(
  #|  style=["display:flex;justify-content:center"],
  #|  verified_html,
  #|))
  #|

///|
const FormsOtpFormCode : String = FoundationsStrokeIconCode +
  (
    #|
    #|let verification = @rui.input_otp(
    #|  id="forms-variants-otp-form",
    #|  max_length=6,
    #|  aria_label="Verification code",
    #|  input_attrs=@html.Attrs::build().required(true),
    #|  render=scope => {
    #|    let slot_style = ["width:2rem;height:2rem;font-size:0.875rem;line-height:1.25rem"]
    #|    @html.fragment([
    #|      @rui.input_otp_group([
    #|        @rui.input_otp_slot(scope~, index=0, style=slot_style),
    #|        @rui.input_otp_slot(scope~, index=1, style=slot_style),
    #|        @rui.input_otp_slot(scope~, index=2, style=slot_style),
    #|      ]),
    #|      @rui.input_otp_separator(),
    #|      @rui.input_otp_group([
    #|        @rui.input_otp_slot(scope~, index=3, style=slot_style),
    #|        @rui.input_otp_slot(scope~, index=4, style=slot_style),
    #|        @rui.input_otp_slot(scope~, index=5, style=slot_style),
    #|      ]),
    #|    ])
    #|  },
    #|)
    #|verification.view(verification_html => @rui.card(
    #|  style=["width:min(100%,28rem);margin-inline:auto"],
    #|  [
    #|    @rui.card_header([
    #|      @rui.card_title("Verify your login"),
    #|      @rui.card_description([
    #|        @html.span("Enter the verification code we sent to your email address: "),
    #|        @html.span(style=["font-weight:500;color:var(--rui-foreground)"], "m@example.com"),
    #|        @html.span("."),
    #|      ]),
    #|    ]),
    #|    @rui.card_content(@rui.field([
    #|      @html.div(
    #|        style=["display:flex;align-items:center;justify-content:space-between;gap:0.75rem"],
    #|        [
    #|          @rui.field_label(for_="forms-variants-otp-form", "Verification code"),
    #|          @rui.button(
    #|            variant=@rui.Outline,
    #|            size=@rui.Xs,
    #|            [
    #|              stroke_icon("M20 6v6h-6M4 18v-6h6M5.1 9A7 7 0 0 1 16.5 5.5L20 9M4 15l3.5 3.5A7 7 0 0 0 18.9 15"),
    #|              @html.span("Resend Code"),
    #|            ],
    #|          ),
    #|        ],
    #|      ),
    #|      verification_html,
    #|      @rui.field_description(@html.a(
    #|        href="#component-Input-OTP",
    #|        style=["color:inherit;text-underline-offset:4px"],
    #|        "I no longer have access to this email address.",
    #|      )),
    #|    ])),
    #|    @rui.card_footer(
    #|      style=["flex-direction:column;align-items:stretch;gap:0.75rem"],
    #|      @rui.field([
    #|        @rui.button(style=["width:100%"], "Verify"),
    #|        @html.div(
    #|          style=["color:var(--rui-muted-foreground);font-size:0.875rem;line-height:1.25rem;text-align:center"],
    #|          [
    #|            @html.span("Having trouble signing in? "),
    #|            @html.a(
    #|              href="#component-Input-OTP",
    #|              style=["color:inherit;text-decoration:underline;text-underline-offset:4px"],
    #|              "Contact support",
    #|            ),
    #|          ],
    #|        ),
    #|      ]),
    #|    ),
    #|  ],
    #|))
    #|
  )

///|
fn forms_checkbox_variants() -> @rabbita.Val[@html.Html] {
  let checkbox_mixed = @rui.checkbox(
    id="forms-variants-checkbox-mixed",
    default_indeterminate=true,
    aria_label="Select all projects",
  )
  let checkbox_invalid = @rui.checkbox(
    id="forms-variants-checkbox-invalid",
    invalid=true,
    aria_label="Accept the workspace policy",
  )
  let checkbox_disabled = @rui.checkbox(
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
          "Mixed",
          "Starts indeterminate, then resolves through normal activation.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              @html.div(style=[FormsVariantControlStyle], [
                @rui.label(for_="forms-variants-checkbox-mixed", "All projects"),
                mixed_html,
              ]),
            ),
            FormsCheckboxMixedCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:13rem",
          ),
        ),
        showcase_demo_section(
          "Invalid",
          "Validation styling leaves pointer and keyboard behavior intact.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              @html.div(style=[FormsVariantControlStyle], [
                @rui.label(
                  for_="forms-variants-checkbox-invalid",
                  "Workspace policy",
                ),
                invalid_html,
              ]),
            ),
            FormsCheckboxInvalidCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:13rem",
          ),
        ),
        showcase_demo_section(
          "Disabled",
          "A managed value remains visible without entering the tab order.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              @html.div(style=[FormsVariantControlStyle], [
                @rui.label(
                  for_="forms-variants-checkbox-disabled",
                  disabled=true,
                  "Organization policy",
                ),
                disabled_html,
              ]),
            ),
            FormsCheckboxDisabledCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:13rem",
          ),
        ),
      ],
    )
  })
}

///|
fn forms_switch_variants() -> @rabbita.Val[@html.Html] {
  let switch_default = @rui.switch(
    id="forms-variants-switch-default",
    default_checked=true,
    aria_label="Enable live previews",
  )
  let switch_small = @rui.switch(
    id="forms-variants-switch-small",
    size=Sm,
    aria_label="Enable compact activity",
  )
  let switch_invalid = @rui.switch(
    id="forms-variants-switch-invalid",
    invalid=true,
    aria_label="Enable required approval",
  )
  let switch_disabled = @rui.switch(
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
          "Default",
          "The standard control for a settings row.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              @html.div(style=[FormsVariantControlStyle], [
                @rui.label(
                  for_="forms-variants-switch-default",
                  "Live previews",
                ),
                default_html,
              ]),
            ),
            FormsSwitchDefaultCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:13rem",
          ),
        ),
        showcase_demo_section(
          "Small",
          "A compact control for denser preference lists.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              @html.div(style=[FormsVariantControlStyle], [
                @rui.label(
                  for_="forms-variants-switch-small",
                  "Compact activity",
                ),
                small_html,
              ]),
            ),
            FormsSwitchSmallCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:13rem",
          ),
        ),
        showcase_demo_section(
          "Invalid",
          "Required-choice styling keeps normal switch interaction.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              @html.div(style=[FormsVariantControlStyle], [
                @rui.label(
                  for_="forms-variants-switch-invalid",
                  "Approval required",
                ),
                invalid_html,
              ]),
            ),
            FormsSwitchInvalidCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:13rem",
          ),
        ),
        showcase_demo_section(
          "Disabled",
          "The organization owns this setting.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              @html.div(style=[FormsVariantControlStyle], [
                @rui.label(
                  for_="forms-variants-switch-disabled",
                  disabled=true,
                  "Managed backups",
                ),
                disabled_html,
              ]),
            ),
            FormsSwitchDisabledCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:13rem",
          ),
        ),
      ],
    )
  })
}

///|
fn forms_combobox_variants() -> @rabbita.Val[@html.Html] {
  let framework_options = [
    @rui.combobox_option(value="moonbit", label="MoonBit"),
    @rui.combobox_option(value="rabbita", label="Rabbita"),
    @rui.combobox_option(value="typescript", label="TypeScript"),
    @rui.combobox_option(value="rust", label="Rust"),
    @rui.combobox_option(value="legacy", label="Legacy runtime", disabled=true),
  ]
  let multiple = @rui.combobox(
    id="forms-variants-combobox-multiple",
    options=framework_options,
    multiple=true,
    default_values=["moonbit", "rabbita"],
    placeholder="Add a runtime…",
    empty_text="No matching runtimes.",
    name="supported-runtimes",
  )
  let grouped = @rui.combobox(
    id="forms-variants-combobox-grouped",
    options=framework_options,
    default_value="rabbita",
    render=scope => {
      @html.fragment([
        @rui.combobox_trigger(scope~, aria_label="Choose a runtime by group"),
        @rui.combobox_content(
          scope~,
          @rui.combobox_list([
            @rui.combobox_group(
              label_id="forms-variants-combobox-group-core-label",
              [
                @rui.combobox_label(
                  id="forms-variants-combobox-group-core-label",
                  "Core",
                ),
                @rui.combobox_item(scope~, value="moonbit", "MoonBit"),
                @rui.combobox_item(scope~, value="rabbita", "Rabbita"),
              ],
            ),
            @rui.combobox_separator(),
            @rui.combobox_group(
              label_id="forms-variants-combobox-group-host-label",
              [
                @rui.combobox_label(
                  id="forms-variants-combobox-group-host-label",
                  "Host languages",
                ),
                @rui.combobox_item(scope~, value="typescript", "TypeScript"),
                @rui.combobox_item(scope~, value="rust", "Rust"),
                @rui.combobox_item(
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
  let empty = @rui.combobox(
    id="forms-variants-combobox-empty",
    options=[
      @rui.combobox_option(value="alpha", label="Alpha workspace"),
      @rui.combobox_option(value="beta", label="Beta workspace"),
    ],
    placeholder="Search workspaces…",
    empty_text="No workspace matches this search.",
  )
  let invalid = @rui.combobox(
    id="forms-variants-combobox-invalid",
    options=framework_options,
    placeholder="Choose a required runtime…",
    empty_text="No matching runtimes.",
    invalid=true,
    required=true,
  )
  let disabled = @rui.combobox(
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
          "Multiple",
          "Remove chips, clear the value, or type to add another runtime.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              multiple_html,
            ),
            FormsComboboxMultipleCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:17rem",
          ),
        ),
        showcase_demo_section(
          "Grouped",
          "Core and host-language options share one searchable popup.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              grouped_html,
            ),
            FormsComboboxGroupedCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:17rem",
          ),
        ),
        showcase_demo_section(
          "Empty result",
          "Type an unmatched query to reveal the component's empty message.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              empty_html,
            ),
            FormsComboboxEmptyCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:16rem",
          ),
        ),
        showcase_demo_section(
          "Invalid",
          "A required choice keeps search and keyboard interaction available.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              invalid_html,
            ),
            FormsComboboxInvalidCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:16rem",
          ),
        ),
        showcase_demo_section(
          "Disabled",
          "The selected runtime remains readable in a locked control.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              disabled_html,
            ),
            FormsComboboxDisabledCode,
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
    @rui.select_option(value="iad", label="Washington, D.C."),
    @rui.select_option(value="ord", label="Chicago"),
    @rui.select_option(value="dfw", label="Dallas"),
    @rui.select_option(value="sfo", label="San Francisco"),
    @rui.select_option(value="fra", label="Frankfurt"),
    @rui.select_option(value="lhr", label="London"),
    @rui.select_option(value="sin", label="Singapore"),
    @rui.select_option(value="nrt", label="Tokyo"),
    @rui.select_option(value="syd", label="Sydney"),
    @rui.select_option(
      value="legacy-region",
      label="Legacy region",
      disabled=true,
    ),
  ]
  let grouped = @rui.select(
    id="forms-variants-select-grouped",
    options=deployment_options,
    default_value="sfo",
    render=scope => {
      @html.fragment([
        @rui.select_trigger(scope~, aria_label="Choose a deployment region"),
        @rui.select_content(scope~, style=["max-height:13rem"], [
          @rui.select_scroll_up_button(scope~, label="Scroll regions up"),
          @rui.select_group(label_id="forms-variants-select-americas-label", [
            @rui.select_label(
              id="forms-variants-select-americas-label",
              "Americas",
            ),
            @rui.select_item(scope~, value="iad", "Washington, D.C."),
            @rui.select_item(scope~, value="ord", "Chicago"),
            @rui.select_item(scope~, value="dfw", "Dallas"),
            @rui.select_item(scope~, value="sfo", "San Francisco"),
          ]),
          @rui.select_separator(),
          @rui.select_group(label_id="forms-variants-select-emea-label", [
            @rui.select_label(id="forms-variants-select-emea-label", "Europe"),
            @rui.select_item(scope~, value="fra", "Frankfurt"),
            @rui.select_item(scope~, value="lhr", "London"),
          ]),
          @rui.select_separator(),
          @rui.select_group(label_id="forms-variants-select-apac-label", [
            @rui.select_label(
              id="forms-variants-select-apac-label",
              "Asia Pacific",
            ),
            @rui.select_item(scope~, value="sin", "Singapore"),
            @rui.select_item(scope~, value="nrt", "Tokyo"),
            @rui.select_item(scope~, value="syd", "Sydney"),
            @rui.select_item(
              scope~,
              value="legacy-region",
              disabled=true,
              "Legacy region",
            ),
          ]),
          @rui.select_scroll_down_button(scope~, label="Scroll regions down"),
        ]),
      ])
    },
  )
  let invalid = @rui.select(
    id="forms-variants-select-invalid",
    options=deployment_options,
    placeholder="Choose a required region…",
    invalid=true,
    required=true,
  )
  let disabled = @rui.select(
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
          "Invalid",
          "A required Select keeps normal pointer and keyboard behavior.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              invalid_html,
            ),
            FormsSelectInvalidCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:14rem",
          ),
        ),
        showcase_demo_section(
          "Disabled",
          "The selected region remains legible in a locked control.",
          showcase_demo_stage(
            @html.div(
              style=["width:min(100%,24rem);margin-inline:auto"],
              disabled_html,
            ),
            FormsSelectDisabledCode,
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
        "Horizontal",
        "A compact label and control share one row.",
        showcase_demo_stage(
          @html.div(
            style=["width:min(100%,30rem);margin-inline:auto"],
            @rui.field(orientation=FieldHorizontal, [
              @rui.field_label(
                for_="forms-variants-field-horizontal",
                style=["width:7rem;flex:none"],
                "Project",
              ),
              @rui.field_content([
                @rui.input(
                  id="forms-variants-field-horizontal",
                  placeholder="rabbit-tea",
                ),
                @rui.field_description("Used in generated workspace URLs."),
              ]),
            ]),
          ),
          FormsFieldHorizontalCode,
          variant=ShowcaseStagePlain,
          stage_style="--rui-showcase-stage-min-height:16rem",
        ),
      ),
      showcase_demo_section(
        "Responsive",
        "The label stacks when the field container becomes narrow.",
        showcase_demo_stage(
          @rui.field_group(
            style=["width:min(100%,30rem);margin-inline:auto"],
            @rui.field(orientation=FieldResponsive, [
              @rui.field_label(
                for_="forms-variants-field-responsive",
                style=["width:7rem;flex:none"],
                "Repository",
              ),
              @rui.field_content([
                @rui.input(
                  id="forms-variants-field-responsive",
                  placeholder="moonbit-community/rabbita",
                ),
                @rui.field_description("Paste a repository path or URL."),
              ]),
            ]),
          ),
          FormsFieldResponsiveCode,
          variant=ShowcaseStagePlain,
          stage_style="--rui-showcase-stage-min-height:16rem",
        ),
      ),
      showcase_demo_section(
        "Fieldset and legend",
        "Related delivery settings share a native legend and field group.",
        showcase_demo_stage(
          @html.div(
            style=["width:min(100%,34rem);margin-inline:auto"],
            @rui.field_set([
              @rui.field_legend(variant=FieldLabelLegend, "Delivery settings"),
              @rui.field_group(style=["gap:1rem"], [
                @rui.field([
                  @rui.field_label(for_="forms-variants-field-region", "Region"),
                  @rui.input(
                    id="forms-variants-field-region",
                    placeholder="Asia Pacific",
                  ),
                ]),
                @rui.field([
                  @rui.field_label(
                    for_="forms-variants-field-channel",
                    "Release channel",
                  ),
                  @rui.input(
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
fn forms_native_select_variants() -> @html.Html {
  showcase_component_demos(
    "Native Select",
    "Sizes, grouped options, validation, and managed-disabled variants keep the platform-native menu while matching the shared control surface.",
    [
      showcase_demo_section(
        "Default with groups",
        "Native option groups preserve the platform menu and semantics.",
        showcase_demo_stage(
          @html.div(
            style=["width:min(100%,24rem);margin-inline:auto"],
            @html.div(style=[FormsVariantColumnStyle], [
              @rui.label(for_="forms-variants-native-default", "Access scope"),
              @rui.native_select(id="forms-variants-native-default", [
                @rui.native_select_optgroup(label="Workspace", [
                  @rui.native_select_option(value="personal", "Personal"),
                  @rui.native_select_option(value="team", selected=true, "Team"),
                ]),
                @rui.native_select_optgroup(label="Advanced", [
                  @rui.native_select_option(
                    value="organization",
                    "Organization",
                  ),
                ]),
              ]),
            ]),
          ),
          FormsNativeSelectDefaultGroupsCode,
          variant=ShowcaseStageSurface,
          stage_style="--rui-showcase-stage-min-height:14rem",
        ),
      ),
      showcase_demo_section(
        "Small",
        "A compact native control for dense settings.",
        showcase_demo_stage(
          @html.div(
            style=["width:min(100%,24rem);margin-inline:auto"],
            @html.div(style=[FormsVariantColumnStyle], [
              @rui.label(for_="forms-variants-native-small", "Release channel"),
              @rui.native_select(
                id="forms-variants-native-small",
                size=NativeSelectSm,
                [
                  @rui.native_select_option(
                    value="stable",
                    selected=true,
                    "Stable",
                  ),
                  @rui.native_select_option(value="preview", "Preview"),
                ],
              ),
            ]),
          ),
          FormsNativeSelectSmallCode,
          variant=ShowcaseStageSurface,
          stage_style="--rui-showcase-stage-min-height:14rem",
        ),
      ),
      showcase_demo_section(
        "Invalid",
        "A required platform select uses the shared destructive border.",
        showcase_demo_stage(
          @html.div(
            style=["width:min(100%,24rem);margin-inline:auto"],
            @html.div(style=[FormsVariantColumnStyle], [
              @rui.label(for_="forms-variants-native-invalid", "Access level"),
              @rui.native_select(
                id="forms-variants-native-invalid",
                invalid=true,
                required=true,
                aria_label="Choose an access level",
                [
                  @rui.native_select_option(
                    value="",
                    selected=true,
                    "Choose access",
                  ),
                  @rui.native_select_option(value="viewer", "Viewer"),
                  @rui.native_select_option(value="editor", "Editor"),
                ],
              ),
            ]),
          ),
          FormsNativeSelectInvalidCode,
          variant=ShowcaseStagePlain,
          stage_style="--rui-showcase-stage-min-height:14rem",
        ),
      ),
      showcase_demo_section(
        "Disabled",
        "The inherited environment stays visible but cannot be changed.",
        showcase_demo_stage(
          @html.div(
            style=["width:min(100%,24rem);margin-inline:auto"],
            @html.div(style=[FormsVariantColumnStyle], [
              @rui.label(
                for_="forms-variants-native-disabled",
                disabled=true,
                "Environment",
              ),
              @rui.native_select(
                id="forms-variants-native-disabled",
                disabled=true,
                aria_label="Inherited environment",
                [
                  @rui.native_select_option(
                    value="production",
                    selected=true,
                    "Production",
                  ),
                  @rui.native_select_option(value="preview", "Preview"),
                ],
              ),
            ]),
          ),
          FormsNativeSelectDisabledCode,
          variant=ShowcaseStagePlain,
          stage_style="--rui-showcase-stage-min-height:14rem",
        ),
      ),
    ],
  )
}

///|
priv struct FormsOtpStageViews {
  continuous : @html.Html
  pattern : @html.Html
  separator : @html.Html
  default : @html.Html
  custom : @html.Html
  four_digits : @html.Html
  alphanumeric : @html.Html
  invalid : @html.Html
  disabled : @html.Html
} derive(Eq)

///|
fn forms_otp_variants() -> @rabbita.Val[@html.Html] {
  let continuous = @rui.input_otp(
    id="forms-variants-otp-continuous",
    max_length=6,
    aria_label="Verification code",
  )
  let pattern = @rui.input_otp(
    id="forms-variants-otp-pattern",
    max_length=6,
    pattern="[0-9]*",
    aria_label="Digits only",
  )
  let separator = @rui.input_otp(
    id="forms-variants-otp-separator",
    max_length=6,
    aria_label="Paired verification code",
    render=scope => {
      @html.fragment([
        @rui.input_otp_group([
          @rui.input_otp_slot(scope~, index=0),
          @rui.input_otp_slot(scope~, index=1),
        ]),
        @rui.input_otp_separator(),
        @rui.input_otp_group([
          @rui.input_otp_slot(scope~, index=2),
          @rui.input_otp_slot(scope~, index=3),
        ]),
        @rui.input_otp_separator(),
        @rui.input_otp_group([
          @rui.input_otp_slot(scope~, index=4),
          @rui.input_otp_slot(scope~, index=5),
        ]),
      ])
    },
  )
  let default = @rui.input_otp(
    id="forms-variants-otp-default",
    max_length=6,
    separator_after=3,
    aria_label="Verification code",
  )
  let custom = @rui.input_otp(
    id="forms-variants-otp-custom",
    max_length=8,
    separator_after=4,
    aria_label="Eight-digit recovery code",
  )
  let four_digits = @rui.input_otp(
    id="forms-variants-otp-four-digits",
    max_length=4,
    pattern="[0-9]*",
    aria_label="Four-digit PIN",
  )
  let alphanumeric = @rui.input_otp(
    id="forms-variants-otp-alphanumeric",
    max_length=6,
    default_value="A1B2C3",
    separator_after=3,
    inputmode="text",
    pattern="[A-Za-z0-9]*",
    aria_label="Alphanumeric verification code",
  )
  let invalid = @rui.input_otp(
    id="forms-variants-otp-invalid",
    max_length=6,
    separator_after=3,
    invalid=true,
    aria_label="Invalid verification code",
  )
  let disabled = @rui.input_otp(
    id="forms-variants-otp-disabled",
    max_length=6,
    default_value="482931",
    separator_after=3,
    disabled=true,
    aria_label="Previously verified code",
  )
  let form = @rui.input_otp(
    id="forms-variants-otp-form",
    max_length=6,
    aria_label="Verification code",
    input_attrs=@html.Attrs::build().required(true),
    render=scope => {
      let slot_style = [
        "width:2rem;height:2rem;font-size:0.875rem;line-height:1.25rem",
      ]
      @html.fragment([
        @rui.input_otp_group([
          @rui.input_otp_slot(scope~, index=0, style=slot_style),
          @rui.input_otp_slot(scope~, index=1, style=slot_style),
          @rui.input_otp_slot(scope~, index=2, style=slot_style),
        ]),
        @rui.input_otp_separator(),
        @rui.input_otp_group([
          @rui.input_otp_slot(scope~, index=3, style=slot_style),
          @rui.input_otp_slot(scope~, index=4, style=slot_style),
          @rui.input_otp_slot(scope~, index=5, style=slot_style),
        ]),
      ])
    },
  )
  let stages = continuous.map9(
    pattern,
    separator,
    default,
    custom,
    four_digits,
    alphanumeric,
    invalid,
    disabled,
    (
      continuous_html,
      pattern_html,
      separator_html,
      default_html,
      custom_html,
      four_digits_html,
      alphanumeric_html,
      invalid_html,
      disabled_html,
    ) => {
      continuous: continuous_html,
      pattern: pattern_html,
      separator: separator_html,
      default: default_html,
      custom: custom_html,
      four_digits: four_digits_html,
      alphanumeric: alphanumeric_html,
      invalid: invalid_html,
      disabled: disabled_html,
    },
  )
  stages.view2(form, (stages, form_html) => {
    showcase_component_demos(
      "Input OTP",
      "Patterns, lengths, grouping recipes, validation states, and a complete verification form all use the same incremental input component.",
      [
        showcase_demo_section(
          "Default",
          "Six editable digits stay in one continuous group.",
          showcase_demo_stage(
            @html.div(
              style=["display:flex;justify-content:center"],
              stages.continuous,
            ),
            FormsOtpContinuousCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
        showcase_demo_section(
          "Pattern",
          "A native input pattern constrains the field to digits.",
          showcase_demo_stage(
            @rui.field(style=["width:fit-content;margin-inline:auto"], [
              @rui.field_label(for_="forms-variants-otp-pattern", "Digits Only"),
              stages.pattern,
            ]),
            FormsOtpPatternCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
        showcase_demo_section(
          "2 + 2 + 2 Separator",
          "Two separators divide the code into three independently styled pairs.",
          showcase_demo_stage(
            @html.div(
              style=["display:flex;justify-content:center"],
              stages.separator,
            ),
            FormsOtpSeparatorCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
        showcase_demo_section(
          "3 + 3",
          "A six-digit verification code split after the third slot.",
          showcase_demo_stage(
            @html.div(
              style=["display:flex;justify-content:center"],
              stages.default,
            ),
            FormsOtpDefaultCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
        showcase_demo_section(
          "4 + 4",
          "An eight-digit recovery code uses a custom four-slot grouping.",
          showcase_demo_stage(
            @html.div(
              style=["display:flex;justify-content:center"],
              stages.custom,
            ),
            FormsOtpCustomCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
        showcase_demo_section(
          "Four Digits",
          "A compact four-digit PIN keeps the same input and focus behavior.",
          showcase_demo_stage(
            @html.div(
              style=["display:flex;justify-content:center"],
              stages.four_digits,
            ),
            FormsOtpFourDigitsCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
        showcase_demo_section(
          "Alphanumeric",
          "Letters and numbers share the same six slots and text keyboard mode.",
          showcase_demo_stage(
            @html.div(
              style=["display:flex;justify-content:center"],
              stages.alphanumeric,
            ),
            FormsOtpAlphanumericCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
        showcase_demo_section(
          "Invalid and editable",
          "Enter a replacement code using the same six live slots.",
          showcase_demo_stage(
            @html.div(
              style=["display:flex;justify-content:center"],
              stages.invalid,
            ),
            FormsOtpInvalidCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
        showcase_demo_section(
          "Disabled",
          "A previously verified value remains readable.",
          showcase_demo_stage(
            @html.div(
              style=["display:flex;justify-content:center"],
              stages.disabled,
            ),
            FormsOtpDisabledCode,
            variant=ShowcaseStagePlain,
            stage_style="--rui-showcase-stage-min-height:15rem",
          ),
        ),
        showcase_demo_section(
          "Form",
          "A complete login-verification card composes the OTP with labels and actions.",
          showcase_demo_stage(
            @rui.card(style=["width:min(100%,28rem);margin-inline:auto"], [
              @rui.card_header([
                @rui.card_title("Verify your login"),
                @rui.card_description([
                  @html.span(
                    "Enter the verification code we sent to your email address: ",
                  ),
                  @html.span(
                    style=["font-weight:500;color:var(--rui-foreground)"],
                    "m@example.com",
                  ),
                  @html.span("."),
                ]),
              ]),
              @rui.card_content(
                @rui.field([
                  @html.div(
                    style=[
                      "display:flex;align-items:center;justify-content:space-between;gap:0.75rem",
                    ],
                    [
                      @rui.field_label(
                        for_="forms-variants-otp-form",
                        "Verification code",
                      ),
                      @rui.button(variant=Outline, size=Xs, [
                        showcase_refresh_icon(),
                        @html.span("Resend Code"),
                      ]),
                    ],
                  ),
                  form_html,
                  @rui.field_description(
                    @html.a(
                      href="#component-Input-OTP",
                      style=["color:inherit;text-underline-offset:4px"],
                      "I no longer have access to this email address.",
                    ),
                  ),
                ]),
              ),
              @rui.card_footer(
                style=["flex-direction:column;align-items:stretch;gap:0.75rem"],
                @rui.field([
                  @rui.button(style=["width:100%"], "Verify"),
                  @html.div(
                    style=[
                      "color:var(--rui-muted-foreground);font-size:0.875rem;line-height:1.25rem;text-align:center",
                    ],
                    [
                      @html.span("Having trouble signing in? "),
                      @html.a(
                        href="#component-Input-OTP",
                        style=[
                          "color:inherit;text-decoration:underline;text-underline-offset:4px",
                        ],
                        "Contact support",
                      ),
                    ],
                  ),
                ]),
              ),
            ]),
            FormsOtpFormCode,
            variant=ShowcaseStageSurface,
            stage_style="--rui-showcase-stage-min-height:38rem",
          ),
        ),
      ],
    )
  })
}
