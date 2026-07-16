///|
const FdvGridStyle : String = "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,15rem),1fr));gap:1rem;min-width:0"

///|
const FdvSpecimenStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.75rem"

///|
const FdvSpecimenTitleStyle : String = "font-size:0.8125rem;line-height:1.125rem;font-weight:600"

///|
const FdvImageStyle : String = "width:100%;height:100%;background:linear-gradient(135deg,color-mix(in oklab,var(--rui-primary) 22%,var(--rui-muted)),var(--rui-muted))"

///|
const FdvAttachmentCompositionStyle : String = "display:flex;width:min(100%,44rem);margin-inline:auto;flex-direction:column;gap:1.75rem"

///|
const FdvAttachmentImageRowStyle : String = "display:flex;max-width:100%;align-items:flex-start;justify-content:flex-start;gap:0.75rem;overflow-x:auto;padding:0.25rem;scroll-snap-type:x mandatory"

///|
const FdvAttachmentFileStackStyle : String = "display:flex;width:min(100%,34rem);margin-inline:auto;flex-direction:column;gap:0.625rem"

///|
const FdvAttachmentVerticalStyle : String = "width:10.5rem;--rui-attachment-content-width:auto"

///|
const FdvAttachmentUtilitiesStyle : String = "display:grid;width:min(100%,52rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,21rem),1fr));gap:clamp(1.5rem,4vw,3rem);align-items:start"

///|
const FdvAttachmentUtilityStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.75rem"

///|
const FdvAttachmentUtilityTitleStyle : String = "margin:0;font-size:0.875rem;line-height:1.25rem;font-weight:600"

///|
const FdvAttachmentCompositionCode : String =
  #|let stroke_icon = path => {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=[
  #|      "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
  #|    ],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|let close_icon = () => stroke_icon("M18 6 6 18M6 6l12 12")
  #|let file_icon = () =>
  #|  stroke_icon(
  #|    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
  #|  )
  #|let attachment_content = (title, description) =>
  #|  @ui.attachment_content([
  #|    @ui.attachment_title(title),
  #|    @ui.attachment_description(description),
  #|  ])
  #|let image_style = "width:100%;height:100%;background:linear-gradient(135deg,color-mix(in oklab,var(--rui-primary) 22%,var(--rui-muted)),var(--rui-muted))"
  #|let vertical_style = "width:10.5rem;--rui-attachment-content-width:auto"
  #|
  #|@html.div(
  #|  style=[
  #|    "display:flex;width:min(100%,44rem);margin-inline:auto;flex-direction:column;gap:1.75rem",
  #|  ],
  #|  [
  #|    @ui.attachment_group(
  #|      style=[
  #|        "display:flex;max-width:100%;align-items:flex-start;justify-content:flex-start;gap:0.75rem;overflow-x:auto;padding:0.25rem;scroll-snap-type:x mandatory",
  #|      ],
  #|      [
  #|        @ui.attachment(
  #|          orientation=@ui.AttachmentVertical,
  #|          style=[vertical_style],
  #|          [
  #|            @ui.attachment_media(
  #|              variant=@ui.AttachmentImage,
  #|              @html.div(
  #|                style=[
  #|                  image_style,
  #|                  "background:linear-gradient(145deg,#d7dfeb,#8ba0b5)",
  #|                ],
  #|                @html.nothing,
  #|              ),
  #|            ),
  #|            attachment_content("workspace.png", "PNG · 820 KB"),
  #|            @ui.attachment_trigger_link(
  #|              href="#data-display",
  #|              aria_label="Open workspace image attachment",
  #|              @html.nothing,
  #|            ),
  #|          ],
  #|        ),
  #|        @ui.attachment(
  #|          orientation=@ui.AttachmentVertical,
  #|          style=[vertical_style],
  #|          [
  #|            @ui.attachment_media(
  #|              variant=@ui.AttachmentImage,
  #|              @html.div(
  #|                style=[
  #|                  image_style,
  #|                  "background:linear-gradient(135deg,#e8e2d8,#9c8e78)",
  #|                ],
  #|                @html.nothing,
  #|              ),
  #|            ),
  #|            attachment_content("desk-reference.jpg", "JPG · 1.1 MB"),
  #|            @ui.attachment_actions(
  #|              @ui.attachment_action(
  #|                aria_label="Remove desk image",
  #|                close_icon(),
  #|              ),
  #|            ),
  #|          ],
  #|        ),
  #|        @ui.attachment(
  #|          orientation=@ui.AttachmentVertical,
  #|          style=[vertical_style],
  #|          [
  #|            @ui.attachment_media(
  #|              variant=@ui.AttachmentImage,
  #|              @html.div(
  #|                style=[
  #|                  image_style,
  #|                  "background:linear-gradient(145deg,#d8ddd8,#7d9282)",
  #|                ],
  #|                @html.nothing,
  #|              ),
  #|            ),
  #|            attachment_content("office-reference.jpg", "JPG · 940 KB"),
  #|            @ui.attachment_actions(
  #|              @ui.attachment_action(
  #|                aria_label="Remove office image",
  #|                close_icon(),
  #|              ),
  #|            ),
  #|          ],
  #|        ),
  #|      ],
  #|    ),
  #|    @html.div(
  #|      style=[
  #|        "display:flex;width:min(100%,34rem);margin-inline:auto;flex-direction:column;gap:0.625rem",
  #|      ],
  #|      [
  #|        @ui.attachment(
  #|          state=@ui.AttachmentUploading,
  #|          style=["width:100%"],
  #|          [
  #|            @ui.attachment_media(
  #|              @ui.spinner(label="Uploading sales dashboard"),
  #|            ),
  #|            attachment_content("sales-dashboard.pdf", "Uploading · 64%"),
  #|            @ui.attachment_actions(
  #|              @ui.attachment_action(
  #|                aria_label="Cancel sales dashboard upload",
  #|                close_icon(),
  #|              ),
  #|            ),
  #|          ],
  #|        ),
  #|        @ui.attachment(style=["width:100%"], [
  #|          @ui.attachment_media(file_icon()),
  #|          attachment_content("message-renderer.mbt", "MoonBit · 12 KB"),
  #|          @ui.attachment_actions(
  #|            @ui.attachment_action(
  #|              aria_label="Remove component source",
  #|              close_icon(),
  #|            ),
  #|          ),
  #|        ]),
  #|      ],
  #|    ),
  #|  ],
  #|)
  #|

///|
const FdvAttachmentStatesCode : String =
  #|let stroke_icon = path => {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=[
  #|      "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
  #|    ],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|let file_icon = () =>
  #|  stroke_icon(
  #|    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
  #|  )
  #|let error_icon = () =>
  #|  stroke_icon(
  #|    "M21.73 18 13.73 4a2 2 0 0 0-3.46 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3ZM12 9v4M12 17h.01",
  #|  )
  #|let check_icon = () => stroke_icon("M20 6 9 17l-5-5")
  #|let attachment_content = (title, description) =>
  #|  @ui.attachment_content([
  #|    @ui.attachment_title(title),
  #|    @ui.attachment_description(description),
  #|  ])
  #|
  #|@html.div(
  #|  style=[
  #|    "display:flex;width:min(100%,34rem);margin-inline:auto;flex-direction:column;gap:0.625rem",
  #|  ],
  #|  [
  #|    @ui.attachment(
  #|      state=@ui.AttachmentIdle,
  #|      style=["width:100%"],
  #|      [
  #|        @ui.attachment_media(file_icon()),
  #|        attachment_content("selected-file.pdf", "Ready to upload"),
  #|      ],
  #|    ),
  #|    @ui.attachment(
  #|      state=@ui.AttachmentUploading,
  #|      style=["width:100%"],
  #|      [
  #|        @ui.attachment_media(
  #|          @ui.spinner(label="Uploading design system"),
  #|        ),
  #|        attachment_content("design-system.zip", "Uploading · 64%"),
  #|      ],
  #|    ),
  #|    @ui.attachment(
  #|      state=@ui.AttachmentProcessing,
  #|      style=["width:100%"],
  #|      [
  #|        @ui.attachment_media(
  #|          @ui.spinner(label="Processing market research"),
  #|        ),
  #|        attachment_content("market-research.pdf", "Processing document"),
  #|      ],
  #|    ),
  #|    @ui.attachment(
  #|      state=@ui.AttachmentError,
  #|      style=["width:100%"],
  #|      [
  #|        @ui.attachment_media(error=true, error_icon()),
  #|        attachment_content(
  #|          "financial-model.xlsx",
  #|          "Upload failed. Try again.",
  #|        ),
  #|      ],
  #|    ),
  #|    @ui.attachment(
  #|      state=@ui.AttachmentDone,
  #|      style=["width:100%"],
  #|      [
  #|        @ui.attachment_media(check_icon()),
  #|        attachment_content("uploaded-report.pdf", "Uploaded · 1.8 MB"),
  #|      ],
  #|    ),
  #|  ],
  #|)
  #|

///|
const FdvAttachmentUtilitiesCode : String =
  #|let stroke_icon = path => {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=[
  #|      "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
  #|    ],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|let close_icon = () => stroke_icon("M18 6 6 18M6 6l12 12")
  #|let file_icon = () =>
  #|  stroke_icon(
  #|    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
  #|  )
  #|let attachment_content = (title, description) =>
  #|  @ui.attachment_content([
  #|    @ui.attachment_title(title),
  #|    @ui.attachment_description(description),
  #|  ])
  #|let utility_style = "display:flex;min-width:0;flex-direction:column;gap:0.75rem"
  #|let title_style = "margin:0;font-size:0.875rem;line-height:1.25rem;font-weight:600"
  #|
  #|@html.div(
  #|  style=[
  #|    "display:grid;width:min(100%,52rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,21rem),1fr));gap:clamp(1.5rem,4vw,3rem);align-items:start",
  #|  ],
  #|  [
  #|    @html.div(style=[utility_style], [
  #|      @html.h5(style=[title_style], "Sizes"),
  #|      @ui.attachment(
  #|        size=@ui.AttachmentDefaultSize,
  #|        style=["width:100%"],
  #|        [
  #|          @ui.attachment_media(file_icon()),
  #|          attachment_content("Default attachment", "PDF · 2.4 MB"),
  #|        ],
  #|      ),
  #|      @ui.attachment(
  #|        size=@ui.AttachmentSm,
  #|        style=["width:100%"],
  #|        [
  #|          @ui.attachment_media(file_icon()),
  #|          attachment_content("Small attachment", "PDF · 2.4 MB"),
  #|        ],
  #|      ),
  #|      @ui.attachment(
  #|        size=@ui.AttachmentXs,
  #|        style=["width:100%"],
  #|        [
  #|          @ui.attachment_media(file_icon()),
  #|          attachment_content("Extra small attachment", "PDF · 2.4 MB"),
  #|        ],
  #|      ),
  #|    ]),
  #|    @html.div(style=[utility_style], [
  #|      @html.h5(
  #|        style=[title_style],
  #|        "Scrollable group and full-card trigger",
  #|      ),
  #|      @ui.attachment_group([
  #|        @ui.attachment(style=["width:16rem"], [
  #|          @ui.attachment_media(file_icon()),
  #|          attachment_content("briefing-notes.pdf", "PDF · 1.4 MB"),
  #|          @ui.attachment_actions(
  #|            @ui.attachment_action(
  #|              aria_label="Remove briefing notes",
  #|              close_icon(),
  #|            ),
  #|          ),
  #|          @ui.attachment_trigger_link(
  #|            href="#data-display",
  #|            aria_label="Open briefing notes",
  #|            @html.nothing,
  #|          ),
  #|        ]),
  #|        @ui.attachment(style=["width:16rem"], [
  #|          @ui.attachment_media(file_icon()),
  #|          attachment_content("customers.csv", "CSV · 18 KB"),
  #|          @ui.attachment_actions(
  #|            @ui.attachment_action(
  #|              aria_label="Remove customer export",
  #|              close_icon(),
  #|            ),
  #|          ),
  #|          @ui.attachment_trigger_link(
  #|            href="#data-display",
  #|            aria_label="Open customer export",
  #|            @html.nothing,
  #|          ),
  #|        ]),
  #|      ]),
  #|    ]),
  #|  ],
  #|)
  #|

///|
const FdvTypographyStyle : String = "display:grid;width:min(100%,52rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(2rem,6vw,4rem);align-items:start"

///|
const FdvTypographyColumnStyle : String = "display:flex;min-width:0;flex-direction:column;gap:1rem"

///|
priv struct FdvPayment {
  id : String
  status : String
  email : String
  amount : String
  amount_sort : String
}

///|
fn fdv_specimen(title : String, body : @html.Html) -> @html.Html {
  @html.div(style=[FdvSpecimenStyle], [
    @html.strong(style=[FdvSpecimenTitleStyle], title),
    body,
  ])
}

///|
fn fdv_attachment_content(title : String, description : String) -> @html.Html {
  @ui.attachment_content([
    @ui.attachment_title(title),
    @ui.attachment_description(description),
  ])
}

///|
fn fdv_attachment_error_icon() -> @html.Html {
  showcase_stroke_icon(
    "M21.73 18 13.73 4a2 2 0 0 0-3.46 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3ZM12 9v4M12 17h.01",
  )
}

///|
fn fdv_attachment_composition() -> @html.Html {
  @html.div(style=[FdvAttachmentCompositionStyle], [
    @ui.attachment_group(style=[FdvAttachmentImageRowStyle], [
      @ui.attachment(
        orientation=@ui.AttachmentVertical,
        style=[FdvAttachmentVerticalStyle],
        [
          @ui.attachment_media(
            variant=@ui.AttachmentImage,
            @html.div(
              style=[
                FdvImageStyle,
                "background:linear-gradient(145deg,#d7dfeb,#8ba0b5)",
              ],
              @html.nothing,
            ),
          ),
          fdv_attachment_content("workspace.png", "PNG · 820 KB"),
          @ui.attachment_trigger_link(
            href="#data-display",
            aria_label="Open workspace image attachment",
            @html.nothing,
          ),
        ],
      ),
      @ui.attachment(
        orientation=@ui.AttachmentVertical,
        style=[FdvAttachmentVerticalStyle],
        [
          @ui.attachment_media(
            variant=@ui.AttachmentImage,
            @html.div(
              style=[
                FdvImageStyle,
                "background:linear-gradient(135deg,#e8e2d8,#9c8e78)",
              ],
              @html.nothing,
            ),
          ),
          fdv_attachment_content("desk-reference.jpg", "JPG · 1.1 MB"),
          @ui.attachment_actions(
            @ui.attachment_action(
              aria_label="Remove desk image",
              showcase_close_icon(),
            ),
          ),
        ],
      ),
      @ui.attachment(
        orientation=@ui.AttachmentVertical,
        style=[FdvAttachmentVerticalStyle],
        [
          @ui.attachment_media(
            variant=@ui.AttachmentImage,
            @html.div(
              style=[
                FdvImageStyle,
                "background:linear-gradient(145deg,#d8ddd8,#7d9282)",
              ],
              @html.nothing,
            ),
          ),
          fdv_attachment_content("office-reference.jpg", "JPG · 940 KB"),
          @ui.attachment_actions(
            @ui.attachment_action(
              aria_label="Remove office image",
              showcase_close_icon(),
            ),
          ),
        ],
      ),
    ]),
    @html.div(style=[FdvAttachmentFileStackStyle], [
      @ui.attachment(state=@ui.AttachmentUploading, style=["width:100%"], [
        @ui.attachment_media(@ui.spinner(label="Uploading sales dashboard")),
        fdv_attachment_content("sales-dashboard.pdf", "Uploading · 64%"),
        @ui.attachment_actions(
          @ui.attachment_action(
            aria_label="Cancel sales dashboard upload",
            showcase_close_icon(),
          ),
        ),
      ]),
      @ui.attachment(style=["width:100%"], [
        @ui.attachment_media(showcase_file_icon()),
        fdv_attachment_content("message-renderer.mbt", "MoonBit · 12 KB"),
        @ui.attachment_actions(
          @ui.attachment_action(
            aria_label="Remove component source",
            showcase_close_icon(),
          ),
        ),
      ]),
    ]),
  ])
}

///|
fn fdv_attachment_states() -> @html.Html {
  @html.div(style=[FdvAttachmentFileStackStyle], [
    @ui.attachment(state=@ui.AttachmentIdle, style=["width:100%"], [
      @ui.attachment_media(showcase_file_icon()),
      fdv_attachment_content("selected-file.pdf", "Ready to upload"),
    ]),
    @ui.attachment(state=@ui.AttachmentUploading, style=["width:100%"], [
      @ui.attachment_media(@ui.spinner(label="Uploading design system")),
      fdv_attachment_content("design-system.zip", "Uploading · 64%"),
    ]),
    @ui.attachment(state=@ui.AttachmentProcessing, style=["width:100%"], [
      @ui.attachment_media(@ui.spinner(label="Processing market research")),
      fdv_attachment_content("market-research.pdf", "Processing document"),
    ]),
    @ui.attachment(state=@ui.AttachmentError, style=["width:100%"], [
      @ui.attachment_media(error=true, fdv_attachment_error_icon()),
      fdv_attachment_content(
        "financial-model.xlsx", "Upload failed. Try again.",
      ),
    ]),
    @ui.attachment(state=@ui.AttachmentDone, style=["width:100%"], [
      @ui.attachment_media(showcase_check_icon()),
      fdv_attachment_content("uploaded-report.pdf", "Uploaded · 1.8 MB"),
    ]),
  ])
}

///|
fn fdv_attachment_utilities() -> @html.Html {
  @html.div(style=[FdvAttachmentUtilitiesStyle], [
    @html.div(style=[FdvAttachmentUtilityStyle], [
      @html.h5(style=[FdvAttachmentUtilityTitleStyle], "Sizes"),
      @ui.attachment(size=@ui.AttachmentDefaultSize, style=["width:100%"], [
        @ui.attachment_media(showcase_file_icon()),
        fdv_attachment_content("Default attachment", "PDF · 2.4 MB"),
      ]),
      @ui.attachment(size=@ui.AttachmentSm, style=["width:100%"], [
        @ui.attachment_media(showcase_file_icon()),
        fdv_attachment_content("Small attachment", "PDF · 2.4 MB"),
      ]),
      @ui.attachment(size=@ui.AttachmentXs, style=["width:100%"], [
        @ui.attachment_media(showcase_file_icon()),
        fdv_attachment_content("Extra small attachment", "PDF · 2.4 MB"),
      ]),
    ]),
    @html.div(style=[FdvAttachmentUtilityStyle], [
      @html.h5(
        style=[FdvAttachmentUtilityTitleStyle],
        "Scrollable group and full-card trigger",
      ),
      @ui.attachment_group([
        @ui.attachment(style=["width:16rem"], [
          @ui.attachment_media(showcase_file_icon()),
          fdv_attachment_content("briefing-notes.pdf", "PDF · 1.4 MB"),
          @ui.attachment_actions(
            @ui.attachment_action(
              aria_label="Remove briefing notes",
              showcase_close_icon(),
            ),
          ),
          @ui.attachment_trigger_link(
            href="#data-display",
            aria_label="Open briefing notes",
            @html.nothing,
          ),
        ]),
        @ui.attachment(style=["width:16rem"], [
          @ui.attachment_media(showcase_file_icon()),
          fdv_attachment_content("customers.csv", "CSV · 18 KB"),
          @ui.attachment_actions(
            @ui.attachment_action(
              aria_label="Remove customer export",
              showcase_close_icon(),
            ),
          ),
          @ui.attachment_trigger_link(
            href="#data-display",
            aria_label="Open customer export",
            @html.nothing,
          ),
        ]),
      ]),
    ]),
  ])
}

///|
fn fdv_attachments_demo() -> @html.Html {
  showcase_component_demos(
    "Attachment",
    "Displays a file or image attachment with media, metadata, upload state, and actions.",
    [
      showcase_demo_section(
        "Images and files",
        "Image previews, upload progress, metadata, and actions share one grouped composition.",
        showcase_demo_stage(
          fdv_attachment_composition(),
          FdvAttachmentCompositionCode,
          tall=true,
          stage_style="--rui-showcase-stage-min-height:34rem",
        ),
      ),
      showcase_demo_section(
        "Upload states",
        "Idle, uploading, processing, error, and done each carry their own visual treatment.",
        showcase_demo_stage(
          fdv_attachment_states(),
          FdvAttachmentStatesCode,
          tall=true,
        ),
      ),
      showcase_demo_section(
        "Sizes, grouping, and trigger",
        "Use the three sizes directly, then group interactive attachments without sacrificing independent actions.",
        showcase_demo_stage(
          fdv_attachment_utilities(),
          FdvAttachmentUtilitiesCode,
          tall=true,
        ),
      ),
    ],
  )
}

///|
const FdvTypographyCode : String =
  #|let column_style = "display:flex;min-width:0;flex-direction:column;gap:1rem"
  #|
  #|@html.div(
  #|  style=[
  #|    "display:grid;width:min(100%,52rem);margin-inline:auto;grid-template-columns:repeat(auto-fit,minmax(min(100%,19rem),1fr));gap:clamp(2rem,6vw,4rem);align-items:start",
  #|  ],
  #|  [
  #|    @html.article(style=[column_style], [
  #|      @ui.typography_h1(style=["text-align:start"], "Taxing Laughter"),
  #|      @ui.typography_lead(
  #|        "A king, a court jester, and one very expensive sense of humor.",
  #|      ),
  #|      @ui.typography_h2("The Joke Tax Chronicles"),
  #|      @ui.typography_p([
  #|        @html.text(
  #|          "Once upon a time, jokes were taxed by the punchline. The people called the rule ",
  #|        ),
  #|        @ui.typography_inline_code("joke_tax"),
  #|        @html.text(" and quietly kept laughing."),
  #|      ]),
  #|      @ui.typography_blockquote(
  #|        "After all, he said, everyone enjoys a good joke—so why not charge for it?",
  #|      ),
  #|      @ui.typography_h3("The people's response"),
  #|      @ui.typography_list([
  #|        @html.li("First-class jokes: one gold coin"),
  #|        @html.li("Second-class jokes: one silver coin"),
  #|        @html.li("Bad jokes: no charge"),
  #|      ]),
  #|    ]),
  #|    @html.div(style=[column_style], [
  #|      @ui.typography_h4("A compact heading"),
  #|      @ui.typography_large("Are you absolutely sure?"),
  #|      @ui.typography_p(
  #|        "This action cannot be undone. The body recipe keeps long-form copy readable without imposing application layout.",
  #|      ),
  #|      @ui.separator(),
  #|      @ui.typography_small("Email address"),
  #|      @ui.typography_muted(
  #|        "Enter the address associated with your account.",
  #|      ),
  #|    ]),
  #|  ],
  #|)
  #|

///|
const FdvDataTableCode : String =
  #|priv struct Payment {
  #|  id : String
  #|  status : String
  #|  email : String
  #|  amount : String
  #|  amount_sort : String
  #|}
  #|
  #|///|
  #|fn payments_table() -> @rabbita.Val[@html.Html] {
  #|  let rows : Array[Payment] = [
  #|    {
  #|      id: "pay-001",
  #|      status: "Success",
  #|      email: "ada@example.com",
  #|      amount: "316.00",
  #|      amount_sort: "0316.00",
  #|    },
  #|    {
  #|      id: "pay-002",
  #|      status: "Processing",
  #|      email: "grace@example.com",
  #|      amount: "242.00",
  #|      amount_sort: "0242.00",
  #|    },
  #|    {
  #|      id: "pay-003",
  #|      status: "Failed",
  #|      email: "linus@example.com",
  #|      amount: "837.00",
  #|      amount_sort: "0837.00",
  #|    },
  #|    {
  #|      id: "pay-004",
  #|      status: "Success",
  #|      email: "margaret@example.com",
  #|      amount: "874.00",
  #|      amount_sort: "0874.00",
  #|    },
  #|    {
  #|      id: "pay-005",
  #|      status: "Success",
  #|      email: "donald@example.com",
  #|      amount: "721.00",
  #|      amount_sort: "0721.00",
  #|    },
  #|    {
  #|      id: "pay-006",
  #|      status: "Processing",
  #|      email: "barbara@example.com",
  #|      amount: "450.00",
  #|      amount_sort: "0450.00",
  #|    },
  #|  ]
  #|  let columns : Array[@ui.DataTableColumn[Payment]] = [
  #|    @ui.data_table_column(
  #|      key="status",
  #|      label="Status",
  #|      value=row => row.status,
  #|      render=row => {
  #|        let variant : @ui.BadgeVariant = if row.status == "Failed" {
  #|          @ui.BadgeVariant::Destructive
  #|        } else if row.status == "Processing" {
  #|          @ui.BadgeVariant::Secondary
  #|        } else {
  #|          @ui.BadgeVariant::Outline
  #|        }
  #|        @ui.badge(variant~, row.status)
  #|      },
  #|    ),
  #|    @ui.data_table_column(
  #|      key="email",
  #|      label="Email",
  #|      value=row => row.email,
  #|    ),
  #|    @ui.data_table_column(
  #|      key="amount",
  #|      label="Amount",
  #|      value=row => row.amount_sort,
  #|      numeric=true,
  #|      render=row => @html.strong("$\{row.amount}"),
  #|    ),
  #|  ]
  #|  @ui.data_table(
  #|    id="showcase-payments",
  #|    rows~,
  #|    columns~,
  #|    row_key=row => row.id,
  #|    page_size=4,
  #|    default_sort_key="amount",
  #|    default_selected=["pay-002"],
  #|    aria_label="Recent payments",
  #|  ).map(table_html =>
  #|    @html.div(
  #|      style=["width:min(100%,58rem);margin-inline:auto"],
  #|      table_html,
  #|    ),
  #|  )
  #|}
  #|

///|
const FdvItemCode : String =
  #|let stroke_icon = path => {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=[
  #|      "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
  #|    ],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|let file_icon = () =>
  #|  stroke_icon(
  #|    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
  #|  )
  #|let runtime_icon = () =>
  #|  stroke_icon(
  #|    "M9 3v2M15 3v2M9 19v2M15 19v2M3 9h2M3 15h2M19 9h2M19 15h2M7 7h10v10H7z",
  #|  )
  #|let specimen = (title, body) =>
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.strong(
  #|        style=["font-size:0.8125rem;line-height:1.125rem;font-weight:600"],
  #|        title,
  #|      ),
  #|      body,
  #|    ],
  #|  )
  #|
  #|@html.div(
  #|  style=[
  #|    "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,15rem),1fr));gap:1rem;min-width:0",
  #|  ],
  #|  [
  #|    specimen(
  #|      "Default",
  #|      @ui.item(
  #|        variant=@ui.ItemDefault,
  #|        size=@ui.ItemDefaultSize,
  #|        [
  #|          @ui.item_media(variant=@ui.ItemMediaDefault, file_icon()),
  #|          @ui.item_content([
  #|            @ui.item_title("Release notes"),
  #|            @ui.item_description(
  #|              "Documentation for the current release.",
  #|            ),
  #|          ]),
  #|        ],
  #|      ),
  #|    ),
  #|    specimen(
  #|      "Outline · small",
  #|      @ui.item(variant=@ui.ItemOutline, size=@ui.ItemSm, [
  #|        @ui.item_media(variant=@ui.ItemMediaIcon, runtime_icon()),
  #|        @ui.item_content([
  #|          @ui.item_title("Runtime"),
  #|          @ui.item_description("JS and native targets are healthy."),
  #|        ]),
  #|        @ui.item_actions(
  #|          @ui.button(variant=@ui.Ghost, size=@ui.Xs, "Inspect"),
  #|        ),
  #|      ]),
  #|    ),
  #|    specimen(
  #|      "Muted · image",
  #|      @ui.item(variant=@ui.ItemMuted, size=@ui.ItemDefaultSize, [
  #|        @ui.item_media(
  #|          variant=@ui.ItemMediaImage,
  #|          @html.div(
  #|            style=[
  #|              "width:100%;height:100%;background:linear-gradient(135deg,color-mix(in oklab,var(--rui-primary) 22%,var(--rui-muted)),var(--rui-muted))",
  #|            ],
  #|            @html.nothing,
  #|          ),
  #|        ),
  #|        @ui.item_content([
  #|          @ui.item_header("Preview build"),
  #|          @ui.item_title("Vega surface"),
  #|          @ui.item_description("Generated from the current token set."),
  #|          @ui.item_footer("Updated moments ago"),
  #|        ]),
  #|      ]),
  #|    ),
  #|  ],
  #|)
  #|

///|
const FdvEmptyCode : String =
  #|let stroke_icon = path => {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=[
  #|      "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
  #|    ],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|let archive_icon = () =>
  #|  stroke_icon("M21 8v13H3V8M1 3h22v5H1zM10 12h4")
  #|let plus_icon = () => stroke_icon("M12 5v14M5 12h14")
  #|
  #|@html.div(
  #|  style=[
  #|    "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,15rem),1fr));gap:1rem;min-width:0",
  #|  ],
  #|  [
  #|    @ui.empty(style=["padding:1.5rem 1rem"], [
  #|      @ui.empty_header([
  #|        @ui.empty_media(
  #|          variant=@ui.EmptyMediaDefault,
  #|          archive_icon(),
  #|        ),
  #|        @ui.empty_title("No archives"),
  #|        @ui.empty_description("Archived projects will appear here."),
  #|      ]),
  #|      @ui.empty_content(@ui.button(size=@ui.Sm, "Browse projects")),
  #|    ]),
  #|    @ui.empty(style=["padding:1.5rem 1rem"], [
  #|      @ui.empty_header([
  #|        @ui.empty_media(variant=@ui.EmptyMediaIcon, plus_icon()),
  #|        @ui.empty_title("No release channels"),
  #|        @ui.empty_description("Create a channel for preview builds."),
  #|      ]),
  #|      @ui.empty_content(@ui.button(size=@ui.Sm, "Create channel")),
  #|    ]),
  #|  ],
  #|)
  #|

///|
const FdvMarkerCode : String =
  #|let stroke_icon = path => {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=[
  #|      "display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none",
  #|    ],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [
  #|        @svg.path(
  #|          d=path,
  #|          fill="none",
  #|          stroke="currentColor",
  #|          stroke_width=2,
  #|          attrs=line_attrs,
  #|        ),
  #|      ],
  #|    ),
  #|  )
  #|}
  #|let activity_icon = () => stroke_icon("M3 12h4l2-8 4 16 2-8h6")
  #|let separator_icon = () => stroke_icon("M12 12h.01")
  #|let check_icon = () => stroke_icon("M20 6 9 17l-5-5")
  #|
  #|@html.div(style=["display:flex;flex-direction:column;gap:1rem"], [
  #|  @ui.marker(variant=@ui.MarkerDefault, [
  #|    @ui.marker_icon(activity_icon()),
  #|    @ui.marker_content("Deployment started"),
  #|  ]),
  #|  @ui.marker(variant=@ui.MarkerSeparator, [
  #|    @ui.marker_icon(separator_icon()),
  #|    @ui.marker_content("Today"),
  #|  ]),
  #|  @ui.marker(variant=@ui.MarkerBorder, [
  #|    @ui.marker_icon(check_icon()),
  #|    @ui.marker_content("Validation complete"),
  #|  ]),
  #|])
  #|

///|
const FdvProgressCode : String =
  #|let specimen = (title, body) =>
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.strong(
  #|        style=["font-size:0.8125rem;line-height:1.125rem;font-weight:600"],
  #|        title,
  #|      ),
  #|      body,
  #|    ],
  #|  )
  #|
  #|@html.div(
  #|  style=[
  #|    "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,15rem),1fr));gap:1rem;min-width:0",
  #|  ],
  #|  [
  #|    specimen(
  #|      "Indeterminate",
  #|      @ui.progress(aria_label="Preparing release", children=[
  #|        @ui.progress_label("Preparing release"),
  #|        @ui.progress_value(text="Working"),
  #|      ]),
  #|    ),
  #|    specimen(
  #|      "Determinate",
  #|      @ui.progress(value=54, aria_label="Build progress", children=[
  #|        @ui.progress_label(value=54, "Build"),
  #|        @ui.progress_value(value=54),
  #|      ]),
  #|    ),
  #|  ],
  #|)
  #|

///|
fn fdv_typography_demo() -> @html.Html {
  showcase_component_demos(
    "Typography",
    "Semantic heading, body, list, quotation, code, and supporting-text recipes.",
    [
      showcase_demo_section(
        "Type scale and prose",
        "Headings, body copy, lists, quotations, inline code, and supporting text share one semantic rhythm.",
        showcase_demo_stage(
          @html.div(style=[FdvTypographyStyle], [
            @html.article(style=[FdvTypographyColumnStyle], [
              @ui.typography_h1(style=["text-align:start"], "Taxing Laughter"),
              @ui.typography_lead(
                "A king, a court jester, and one very expensive sense of humor.",
              ),
              @ui.typography_h2("The Joke Tax Chronicles"),
              @ui.typography_p([
                @html.text(
                  "Once upon a time, jokes were taxed by the punchline. The people called the rule ",
                ),
                @ui.typography_inline_code("joke_tax"),
                @html.text(" and quietly kept laughing."),
              ]),
              @ui.typography_blockquote(
                "After all, he said, everyone enjoys a good joke—so why not charge for it?",
              ),
              @ui.typography_h3("The people's response"),
              @ui.typography_list([
                @html.li("First-class jokes: one gold coin"),
                @html.li("Second-class jokes: one silver coin"),
                @html.li("Bad jokes: no charge"),
              ]),
            ]),
            @html.div(style=[FdvTypographyColumnStyle], [
              @ui.typography_h4("A compact heading"),
              @ui.typography_large("Are you absolutely sure?"),
              @ui.typography_p(
                "This action cannot be undone. The body recipe keeps long-form copy readable without imposing application layout.",
              ),
              @ui.separator(),
              @ui.typography_small("Email address"),
              @ui.typography_muted(
                "Enter the address associated with your account.",
              ),
            ]),
          ]),
          FdvTypographyCode,
          variant=ShowcaseStagePlain,
          tall=true,
        ),
      ),
    ],
  )
}

///|
fn fdv_data_table_view() -> @rabbita.Val[@html.Html] {
  let rows : Array[FdvPayment] = [
    {
      id: "pay-001",
      status: "Success",
      email: "ada@example.com",
      amount: "316.00",
      amount_sort: "0316.00",
    },
    {
      id: "pay-002",
      status: "Processing",
      email: "grace@example.com",
      amount: "242.00",
      amount_sort: "0242.00",
    },
    {
      id: "pay-003",
      status: "Failed",
      email: "linus@example.com",
      amount: "837.00",
      amount_sort: "0837.00",
    },
    {
      id: "pay-004",
      status: "Success",
      email: "margaret@example.com",
      amount: "874.00",
      amount_sort: "0874.00",
    },
    {
      id: "pay-005",
      status: "Success",
      email: "donald@example.com",
      amount: "721.00",
      amount_sort: "0721.00",
    },
    {
      id: "pay-006",
      status: "Processing",
      email: "barbara@example.com",
      amount: "450.00",
      amount_sort: "0450.00",
    },
  ]
  let columns : Array[@ui.DataTableColumn[FdvPayment]] = [
    @ui.data_table_column(
      key="status",
      label="Status",
      value=row => row.status,
      render=row => {
        let variant : @ui.BadgeVariant = if row.status == "Failed" {
          @ui.BadgeVariant::Destructive
        } else if row.status == "Processing" {
          @ui.BadgeVariant::Secondary
        } else {
          @ui.BadgeVariant::Outline
        }
        @ui.badge(variant~, row.status)
      },
    ),
    @ui.data_table_column(key="email", label="Email", value=row => row.email),
    @ui.data_table_column(
      key="amount",
      label="Amount",
      value=row => row.amount_sort,
      numeric=true,
      render=row => @html.strong("$\{row.amount}"),
    ),
  ]
  @ui.data_table(
    id="showcase-payments",
    rows~,
    columns~,
    row_key=row => row.id,
    page_size=4,
    default_sort_key="amount",
    default_selected=["pay-002"],
    aria_label="Recent payments",
  )
}

///|
fn fdv_data_table_demo(data_table_html : @html.Html) -> @html.Html {
  showcase_component_demos(
    "Data Table",
    "Filter, sort, paginate, select rows, and change visible columns in component-local state.",
    [
      showcase_demo_section(
        "Filtering, columns, and pagination",
        "The black-box table keeps search, sort, selection, visibility, and page state local.",
        showcase_demo_stage(
          @html.div(
            style=["width:min(100%,58rem);margin-inline:auto"],
            data_table_html,
          ),
          FdvDataTableCode,
          tall=true,
        ),
      ),
    ],
  )
}

///|
fn fdv_item_body(
  media : @html.Html,
  title : String,
  description : String,
) -> Array[@html.Html] {
  [
    media,
    @ui.item_content([@ui.item_title(title), @ui.item_description(description)]),
  ]
}

///|
fn fdv_items_demo() -> @html.Html {
  showcase_component_demos(
    "Item",
    "Default, outline, and muted surfaces in complete item compositions.",
    [
      showcase_demo_section(
        "Variants and media",
        "Default, outline, and muted items combine text, icons, images, metadata, and actions.",
        showcase_demo_stage(
          @html.div(style=[FdvGridStyle], [
            fdv_specimen(
              "Default",
              @ui.item(
                variant=@ui.ItemDefault,
                size=@ui.ItemDefaultSize,
                fdv_item_body(
                  @ui.item_media(
                    variant=@ui.ItemMediaDefault,
                    showcase_file_icon(),
                  ),
                  "Release notes",
                  "Documentation for the current release.",
                ),
              ),
            ),
            fdv_specimen(
              "Outline · small",
              @ui.item(variant=@ui.ItemOutline, size=@ui.ItemSm, [
                @ui.item_media(
                  variant=@ui.ItemMediaIcon,
                  showcase_runtime_icon(),
                ),
                @ui.item_content([
                  @ui.item_title("Runtime"),
                  @ui.item_description("JS and native targets are healthy."),
                ]),
                @ui.item_actions(
                  @ui.button(variant=@ui.Ghost, size=@ui.Xs, "Inspect"),
                ),
              ]),
            ),
            fdv_specimen(
              "Muted · image",
              @ui.item(variant=@ui.ItemMuted, size=@ui.ItemDefaultSize, [
                @ui.item_media(
                  variant=@ui.ItemMediaImage,
                  @html.div(style=[FdvImageStyle], @html.nothing),
                ),
                @ui.item_content([
                  @ui.item_header("Preview build"),
                  @ui.item_title("Vega surface"),
                  @ui.item_description("Generated from the current token set."),
                  @ui.item_footer("Updated moments ago"),
                ]),
              ]),
            ),
          ]),
          FdvItemCode,
          tall=true,
        ),
      ),
    ],
  )
}

///|
fn fdv_empty_demo() -> @html.Html {
  showcase_component_demos(
    "Empty",
    "Complete empty-state compositions for common actions.",
    [
      showcase_demo_section(
        "Action compositions",
        "Default and icon media treatments pair an explanation with a clear next action.",
        showcase_demo_stage(
          @html.div(style=[FdvGridStyle], [
            @ui.empty(style=["padding:1.5rem 1rem"], [
              @ui.empty_header([
                @ui.empty_media(
                  variant=@ui.EmptyMediaDefault,
                  showcase_archive_icon(),
                ),
                @ui.empty_title("No archives"),
                @ui.empty_description("Archived projects will appear here."),
              ]),
              @ui.empty_content(@ui.button(size=@ui.Sm, "Browse projects")),
            ]),
            @ui.empty(style=["padding:1.5rem 1rem"], [
              @ui.empty_header([
                @ui.empty_media(
                  variant=@ui.EmptyMediaIcon,
                  showcase_plus_icon(),
                ),
                @ui.empty_title("No release channels"),
                @ui.empty_description("Create a channel for preview builds."),
              ]),
              @ui.empty_content(@ui.button(size=@ui.Sm, "Create channel")),
            ]),
          ]),
          FdvEmptyCode,
          variant=ShowcaseStagePlain,
          tall=true,
        ),
      ),
    ],
  )
}

///|
fn fdv_marker_demo() -> @html.Html {
  showcase_component_demos(
    "Marker",
    "Default, separator, and border treatments in a release timeline.",
    [
      showcase_demo_section(
        "Timeline treatments",
        "Default, separator, and bordered markers retain their semantic content and real icon slots.",
        showcase_demo_stage(
          @html.div(style=[StackStyle], [
            @ui.marker(variant=@ui.MarkerDefault, [
              @ui.marker_icon(showcase_activity_icon()),
              @ui.marker_content("Deployment started"),
            ]),
            @ui.marker(variant=@ui.MarkerSeparator, [
              @ui.marker_icon(showcase_separator_dot_icon()),
              @ui.marker_content("Today"),
            ]),
            @ui.marker(variant=@ui.MarkerBorder, [
              @ui.marker_icon(showcase_check_icon()),
              @ui.marker_content("Validation complete"),
            ]),
          ]),
          FdvMarkerCode,
        ),
      ),
    ],
  )
}

///|
fn fdv_progress_demo() -> @html.Html {
  showcase_component_demos(
    "Progress",
    "Indeterminate and determinate progress in complete labelled compositions.",
    [
      showcase_demo_section(
        "Determinate and indeterminate",
        "Both progress modes expose labels and readable values while sharing the same track.",
        showcase_demo_stage(
          @html.div(style=[FdvGridStyle], [
            fdv_specimen(
              "Indeterminate",
              @ui.progress(aria_label="Preparing release", children=[
                @ui.progress_label("Preparing release"),
                @ui.progress_value(text="Working"),
              ]),
            ),
            fdv_specimen(
              "Determinate",
              @ui.progress(value=54, aria_label="Build progress", children=[
                @ui.progress_label(value=54, "Build"),
                @ui.progress_value(value=54),
              ]),
            ),
          ]),
          FdvProgressCode,
          variant=ShowcaseStagePlain,
        ),
      ),
    ],
  )
}

///|
fn foundations_data_variants(data_table_html : @html.Html) -> @html.Html {
  @html.fragment([
    fdv_attachments_demo(),
    fdv_typography_demo(),
    fdv_data_table_demo(data_table_html),
    fdv_items_demo(),
    fdv_empty_demo(),
    fdv_marker_demo(),
    fdv_progress_demo(),
  ])
}
