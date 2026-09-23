///|
const FdvAttachmentStageContentStyle : String = "display:flex;width:min(100%,24rem);min-width:0;margin-inline:auto;align-items:center;justify-content:center"

///|
const FdvAttachmentVerticalStyle : String = "width:7.5rem;--rui-attachment-content-width:auto"

///|
const FdvAttachmentImageStyle : String = "display:block;width:100%;height:100%;object-fit:cover"

///|
const FdvStrokeIconCode : String =
  #|fn stroke_icon(path : String) -> @html.Html {
  #|  let line_attrs = @svg.Attrs::build()
  #|    .stroke_linecap("round")
  #|    .stroke_linejoin("round")
  #|  @html.span(
  #|    style=["display:inline-flex;width:1rem;height:1rem;flex:none;align-items:center;justify-content:center;vertical-align:middle;pointer-events:none;user-select:none"],
  #|    attrs=@html.Attrs::build().aria_hidden("true"),
  #|    @svg.svg(
  #|      width=24,
  #|      height=24,
  #|      view_box="0 0 24 24",
  #|      style=["display:block;width:100%;height:100%"],
  #|      [@svg.path(
  #|        d=path,
  #|        fill="none",
  #|        stroke="currentColor",
  #|        stroke_width=2,
  #|        attrs=line_attrs,
  #|      )],
  #|    ),
  #|  )
  #|}
  #|

///|
const FdvAttachmentImageCode : String =
  #|@rui.attachment_group(style=["width:100%"], [
  #|  @rui.attachment(
  #|    orientation=@rui.AttachmentVertical,
  #|    style=["width:7.5rem;--rui-attachment-content-width:auto"],
  #|    [
  #|      @rui.attachment_media(
  #|        variant=@rui.AttachmentImage,
  #|        @html.img(
  #|          src="https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=900&auto=format&fit=crop&q=80",
  #|          alt="Workspace",
  #|          style=["display:block;width:100%;height:100%;object-fit:cover"],
  #|        ),
  #|      ),
  #|      @rui.attachment_content([
  #|        @rui.attachment_title("workspace.png"),
  #|        @rui.attachment_description("PNG · 820 KB"),
  #|      ]),
  #|    ],
  #|  ),
  #|  @rui.attachment(
  #|    orientation=@rui.AttachmentVertical,
  #|    style=["width:7.5rem;--rui-attachment-content-width:auto"],
  #|    [
  #|      @rui.attachment_media(
  #|        variant=@rui.AttachmentImage,
  #|        @html.img(
  #|          src="https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=900&auto=format&fit=crop&q=80",
  #|          alt="Desk",
  #|          style=["display:block;width:100%;height:100%;object-fit:cover"],
  #|        ),
  #|      ),
  #|      @rui.attachment_content([
  #|        @rui.attachment_title("desk-reference.jpg"),
  #|        @rui.attachment_description("JPG · 1.1 MB"),
  #|      ]),
  #|    ],
  #|  ),
  #|  @rui.attachment(
  #|    orientation=@rui.AttachmentVertical,
  #|    style=["width:7.5rem;--rui-attachment-content-width:auto"],
  #|    [
  #|      @rui.attachment_media(
  #|        variant=@rui.AttachmentImage,
  #|        @html.img(
  #|          src="https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=900&auto=format&fit=crop&q=80",
  #|          alt="Office",
  #|          style=["display:block;width:100%;height:100%;object-fit:cover"],
  #|        ),
  #|      ),
  #|      @rui.attachment_content([
  #|        @rui.attachment_title("office-reference.jpg"),
  #|        @rui.attachment_description("JPG · 940 KB"),
  #|      ]),
  #|    ],
  #|  ),
  #|])
  #|

///|
const FdvAttachmentFileCode : String = FdvStrokeIconCode +
  (
    #|@rui.attachment(style=["width:100%"], [
    #|  @rui.attachment_media(stroke_icon(
    #|    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
    #|  )),
    #|  @rui.attachment_content([
    #|    @rui.attachment_title("message-renderer.mbt"),
    #|    @rui.attachment_description("MoonBit · 12 KB"),
    #|  ]),
    #|])
    #|
  )

///|
const FdvAttachmentIdleCode : String = FdvStrokeIconCode +
  (
    #|@rui.attachment(state=@rui.AttachmentIdle, style=["width:100%"], [
    #|  @rui.attachment_media(stroke_icon(
    #|    "M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0M12 6v6h4",
    #|  )),
    #|  @rui.attachment_content([
    #|    @rui.attachment_title("selected-file.pdf"),
    #|    @rui.attachment_description("Ready to upload"),
    #|  ]),
    #|  @rui.attachment_actions(
    #|    @rui.attachment_action(
    #|      aria_label="Remove selected-file.pdf",
    #|      stroke_icon("M18 6 6 18M6 6l12 12"),
    #|    ),
    #|  ),
    #|])
    #|
  )

///|
const FdvAttachmentUploadingCode : String = FdvStrokeIconCode +
  (
    #|@rui.attachment(state=@rui.AttachmentUploading, style=["width:100%"], [
    #|  @rui.attachment_media(@rui.spinner(label="Uploading design system")),
    #|  @rui.attachment_content([
    #|    @rui.attachment_title("design-system.zip"),
    #|    @rui.attachment_description("Uploading · 64%"),
    #|  ]),
    #|  @rui.attachment_actions(
    #|    @rui.attachment_action(
    #|      aria_label="Cancel upload",
    #|      stroke_icon("M18 6 6 18M6 6l12 12"),
    #|    ),
    #|  ),
    #|])
    #|
  )

///|
const FdvAttachmentProcessingCode : String = FdvStrokeIconCode +
  (
    #|@rui.attachment(state=@rui.AttachmentProcessing, style=["width:100%"], [
    #|  @rui.attachment_media(stroke_icon(
    #|    "M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2zM14 2v5a1 1 0 0 0 1 1h5M10 9H8M16 13H8M16 17H8",
    #|  )),
    #|  @rui.attachment_content([
    #|    @rui.attachment_title("market-research.pdf"),
    #|    @rui.attachment_description("Processing document"),
    #|  ]),
    #|  @rui.attachment_actions(
    #|    @rui.attachment_action(
    #|      aria_label="Remove market-research.pdf",
    #|      stroke_icon("M18 6 6 18M6 6l12 12"),
    #|    ),
    #|  ),
    #|])
    #|
  )

///|
const FdvAttachmentErrorCode : String = FdvStrokeIconCode +
  (
    #|@rui.attachment(state=@rui.AttachmentError, style=["width:100%"], [
    #|  @rui.attachment_media(stroke_icon(
    #|    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6M12 11v3M12 18h.01",
    #|  )),
    #|  @rui.attachment_content([
    #|    @rui.attachment_title("financial-model.xlsx"),
    #|    @rui.attachment_description("Upload failed. Try again."),
    #|  ]),
    #|  @rui.attachment_actions([
    #|    @rui.attachment_action(
    #|      aria_label="Retry upload",
    #|      stroke_icon("M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8M21 3v5h-5M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16M8 16H3v5"),
    #|    ),
    #|    @rui.attachment_action(
    #|      aria_label="Remove financial-model.xlsx",
    #|      stroke_icon("M18 6 6 18M6 6l12 12"),
    #|    ),
    #|  ]),
    #|])
    #|
  )

///|
const FdvAttachmentDoneCode : String = FdvStrokeIconCode +
  (
    #|@rui.attachment(state=@rui.AttachmentDone, style=["width:100%"], [
    #|  @rui.attachment_media(stroke_icon("M20 6 9 17l-5-5")),
    #|  @rui.attachment_content([
    #|    @rui.attachment_title("uploaded-report.pdf"),
    #|    @rui.attachment_description("Uploaded · 1.8 MB"),
    #|  ]),
    #|  @rui.attachment_actions(
    #|    @rui.attachment_action(
    #|      aria_label="Remove uploaded-report.pdf",
    #|      stroke_icon("M18 6 6 18M6 6l12 12"),
    #|    ),
    #|  ),
    #|])
    #|
  )

///|
const FdvAttachmentDefaultSizeCode : String = FdvStrokeIconCode +
  (
    #|@rui.attachment(size=@rui.AttachmentDefaultSize, style=["width:100%"], [
    #|  @rui.attachment_media(stroke_icon(
    #|    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
    #|  )),
    #|  @rui.attachment_content([
    #|    @rui.attachment_title("Default attachment"),
    #|    @rui.attachment_description("PDF · 2.4 MB"),
    #|  ]),
    #|])
    #|
  )

///|
const FdvAttachmentSmallCode : String = FdvStrokeIconCode +
  (
    #|@rui.attachment(size=@rui.AttachmentSm, style=["width:100%"], [
    #|  @rui.attachment_media(stroke_icon(
    #|    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
    #|  )),
    #|  @rui.attachment_content([
    #|    @rui.attachment_title("Small attachment"),
    #|    @rui.attachment_description("PDF · 2.4 MB"),
    #|  ]),
    #|])
    #|
  )

///|
const FdvAttachmentExtraSmallCode : String = FdvStrokeIconCode +
  (
    #|@rui.attachment(size=@rui.AttachmentXs, style=["width:100%"], [
    #|  @rui.attachment_media(stroke_icon(
    #|    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
    #|  )),
    #|  @rui.attachment_content([
    #|    @rui.attachment_title("Extra small attachment"),
    #|    @rui.attachment_description("PDF · 2.4 MB"),
    #|  ]),
    #|])
    #|
  )

///|
const FdvAttachmentGroupCode : String = FdvStrokeIconCode +
  (
    #|@rui.attachment_group(style=["width:100%;max-width:24rem"], [
    #|  @rui.attachment(style=["width:16rem"], [
    #|    @rui.attachment_media(stroke_icon(
    #|      "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
    #|    )),
    #|    @rui.attachment_content([
    #|      @rui.attachment_title("briefing-notes.pdf"),
    #|      @rui.attachment_description("PDF · 1.4 MB"),
    #|    ]),
    #|    @rui.attachment_trigger_link(
    #|      href="#component-Attachment",
    #|      aria_label="Open briefing notes in group",
    #|      @html.nothing,
    #|    ),
    #|  ]),
    #|  @rui.attachment(style=["width:16rem"], [
    #|    @rui.attachment_media(stroke_icon(
    #|      "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
    #|    )),
    #|    @rui.attachment_content([
    #|      @rui.attachment_title("customers.csv"),
    #|      @rui.attachment_description("CSV · 18 KB"),
    #|    ]),
    #|    @rui.attachment_trigger_link(
    #|      href="#component-Attachment",
    #|      aria_label="Open customers in group",
    #|      @html.nothing,
    #|    ),
    #|  ]),
    #|])
    #|
  )

///|
const FdvAttachmentTriggerCode : String = FdvStrokeIconCode +
  (
    #|@rui.attachment(style=["width:100%"], [
    #|  @rui.attachment_media(stroke_icon(
    #|    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6",
    #|  )),
    #|  @rui.attachment_content([
    #|    @rui.attachment_title("briefing-notes.pdf"),
    #|    @rui.attachment_description("PDF · 1.4 MB"),
    #|  ]),
    #|  @rui.attachment_trigger_link(
    #|    href="#data-display",
    #|    aria_label="Open briefing notes",
    #|    @html.nothing,
    #|  ),
    #|])
    #|
  )

///|
priv struct FdvPayment {
  id : String
  status : String
  email : String
  amount : String
  amount_sort : String
}

///|
fn fdv_demo_section(
  title : String,
  description : String,
  body : @html.Html,
  code : String,
  stage_variant? : ShowcaseStageVariant = ShowcaseStagePlain,
  tall? : Bool = false,
) -> ShowcaseDemoEntry {
  showcase_demo_section(
    title,
    description,
    showcase_demo_stage(body, code, variant=stage_variant, tall~),
  )
}

///|
fn fdv_attachment_content(title : String, description : String) -> @html.Html {
  @rui.attachment_content([
    @rui.attachment_title(title),
    @rui.attachment_description(description),
  ])
}

///|
fn fdv_attachment_clock_icon() -> @html.Html {
  showcase_stroke_icon("M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0M12 6v6h4")
}

///|
fn fdv_attachment_processing_icon() -> @html.Html {
  showcase_stroke_icon(
    "M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2zM14 2v5a1 1 0 0 0 1 1h5M10 9H8M16 13H8M16 17H8",
  )
}

///|
fn fdv_attachment_error_icon() -> @html.Html {
  showcase_stroke_icon(
    "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6M12 11v3M12 18h.01",
  )
}

///|
fn fdv_attachment_retry_icon() -> @html.Html {
  showcase_stroke_icon(
    "M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8M21 3v5h-5M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16M8 16H3v5",
  )
}

///|
fn fdv_attachment_stage(
  body : @html.Html,
  code : String,
) -> ShowcasePreparedStage {
  showcase_demo_stage(
    @html.div(
      class="rui-showcase-attachment-stage-content",
      style=[FdvAttachmentStageContentStyle],
      body,
    ),
    code,
  )
}

///|
fn fdv_attachments_demo() -> @html.Html {
  showcase_component_demos(
    "Attachment",
    "Displays a file or image attachment with media, metadata, upload state, and actions.",
    [
      showcase_demo_section(
        "Image attachment",
        "A group of image attachments presents real media and metadata.",
        fdv_attachment_stage(
          @rui.attachment_group(style=["width:100%"], [
            @rui.attachment(
              orientation=AttachmentVertical,
              style=[FdvAttachmentVerticalStyle],
              [
                @rui.attachment_media(
                  variant=AttachmentImage,
                  @html.img(
                    src="https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=900&auto=format&fit=crop&q=80",
                    alt="Workspace",
                    style=[FdvAttachmentImageStyle],
                  ),
                ),
                fdv_attachment_content("workspace.png", "PNG · 820 KB"),
              ],
            ),
            @rui.attachment(
              orientation=AttachmentVertical,
              style=[FdvAttachmentVerticalStyle],
              [
                @rui.attachment_media(
                  variant=AttachmentImage,
                  @html.img(
                    src="https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=900&auto=format&fit=crop&q=80",
                    alt="Desk",
                    style=[FdvAttachmentImageStyle],
                  ),
                ),
                fdv_attachment_content("desk-reference.jpg", "JPG · 1.1 MB"),
              ],
            ),
            @rui.attachment(
              orientation=AttachmentVertical,
              style=[FdvAttachmentVerticalStyle],
              [
                @rui.attachment_media(
                  variant=AttachmentImage,
                  @html.img(
                    src="https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=900&auto=format&fit=crop&q=80",
                    alt="Office",
                    style=[FdvAttachmentImageStyle],
                  ),
                ),
                fdv_attachment_content("office-reference.jpg", "JPG · 940 KB"),
              ],
            ),
          ]),
          FdvAttachmentImageCode,
        ),
      ),
      showcase_demo_section(
        "File attachment",
        "A default horizontal file attachment.",
        fdv_attachment_stage(
          @rui.attachment(style=["width:100%"], [
            @rui.attachment_media(showcase_file_icon()),
            fdv_attachment_content("message-renderer.mbt", "MoonBit · 12 KB"),
          ]),
          FdvAttachmentFileCode,
        ),
      ),
      showcase_demo_section(
        "Idle",
        "A selected file waiting to upload.",
        fdv_attachment_stage(
          @rui.attachment(state=AttachmentIdle, style=["width:100%"], [
            @rui.attachment_media(fdv_attachment_clock_icon()),
            fdv_attachment_content("selected-file.pdf", "Ready to upload"),
            @rui.attachment_actions(
              @rui.attachment_action(
                aria_label="Remove selected-file.pdf",
                showcase_close_icon(),
              ),
            ),
          ]),
          FdvAttachmentIdleCode,
        ),
      ),
      showcase_demo_section(
        "Uploading",
        "An in-progress upload with a spinner.",
        fdv_attachment_stage(
          @rui.attachment(state=AttachmentUploading, style=["width:100%"], [
            @rui.attachment_media(@rui.spinner(label="Uploading design system")),
            fdv_attachment_content("design-system.zip", "Uploading · 64%"),
            @rui.attachment_actions(
              @rui.attachment_action(
                aria_label="Cancel upload",
                showcase_close_icon(),
              ),
            ),
          ]),
          FdvAttachmentUploadingCode,
        ),
      ),
      showcase_demo_section(
        "Processing",
        "A file being processed after upload.",
        fdv_attachment_stage(
          @rui.attachment(state=AttachmentProcessing, style=["width:100%"], [
            @rui.attachment_media(fdv_attachment_processing_icon()),
            fdv_attachment_content("market-research.pdf", "Processing document"),
            @rui.attachment_actions(
              @rui.attachment_action(
                aria_label="Remove market-research.pdf",
                showcase_close_icon(),
              ),
            ),
          ]),
          FdvAttachmentProcessingCode,
        ),
      ),
      showcase_demo_section(
        "Error",
        "A failed upload with destructive media treatment.",
        fdv_attachment_stage(
          @rui.attachment(state=AttachmentError, style=["width:100%"], [
            @rui.attachment_media(fdv_attachment_error_icon()),
            fdv_attachment_content(
              "financial-model.xlsx", "Upload failed. Try again.",
            ),
            @rui.attachment_actions([
              @rui.attachment_action(
                aria_label="Retry upload",
                fdv_attachment_retry_icon(),
              ),
              @rui.attachment_action(
                aria_label="Remove financial-model.xlsx",
                showcase_close_icon(),
              ),
            ]),
          ]),
          FdvAttachmentErrorCode,
        ),
      ),
      showcase_demo_section(
        "Done",
        "A completed upload with a success icon.",
        fdv_attachment_stage(
          @rui.attachment(state=AttachmentDone, style=["width:100%"], [
            @rui.attachment_media(showcase_check_icon()),
            fdv_attachment_content("uploaded-report.pdf", "Uploaded · 1.8 MB"),
            @rui.attachment_actions(
              @rui.attachment_action(
                aria_label="Remove uploaded-report.pdf",
                showcase_close_icon(),
              ),
            ),
          ]),
          FdvAttachmentDoneCode,
        ),
      ),
      showcase_demo_section(
        "Default size",
        "The default attachment size.",
        fdv_attachment_stage(
          @rui.attachment(size=AttachmentDefaultSize, style=["width:100%"], [
            @rui.attachment_media(showcase_file_icon()),
            fdv_attachment_content("Default attachment", "PDF · 2.4 MB"),
          ]),
          FdvAttachmentDefaultSizeCode,
        ),
      ),
      showcase_demo_section(
        "Small",
        "A compact attachment row.",
        fdv_attachment_stage(
          @rui.attachment(size=AttachmentSm, style=["width:100%"], [
            @rui.attachment_media(showcase_file_icon()),
            fdv_attachment_content("Small attachment", "PDF · 2.4 MB"),
          ]),
          FdvAttachmentSmallCode,
        ),
      ),
      showcase_demo_section(
        "Extra small",
        "The most compact attachment row.",
        fdv_attachment_stage(
          @rui.attachment(size=AttachmentXs, style=["width:100%"], [
            @rui.attachment_media(showcase_file_icon()),
            fdv_attachment_content("Extra small attachment", "PDF · 2.4 MB"),
          ]),
          FdvAttachmentExtraSmallCode,
        ),
      ),
      showcase_demo_section(
        "Group",
        "A scrollable group keeps attachments as independent items.",
        fdv_attachment_stage(
          @rui.attachment_group(style=["width:100%;max-width:24rem"], [
            @rui.attachment(style=["width:16rem"], [
              @rui.attachment_media(showcase_file_icon()),
              fdv_attachment_content("briefing-notes.pdf", "PDF · 1.4 MB"),
              @rui.attachment_trigger_link(
                href="#component-Attachment",
                aria_label="Open briefing notes in group",
                @html.nothing,
              ),
            ]),
            @rui.attachment(style=["width:16rem"], [
              @rui.attachment_media(showcase_file_icon()),
              fdv_attachment_content("customers.csv", "CSV · 18 KB"),
              @rui.attachment_trigger_link(
                href="#component-Attachment",
                aria_label="Open customers in group",
                @html.nothing,
              ),
            ]),
          ]),
          FdvAttachmentGroupCode,
        ),
      ),
      showcase_demo_section(
        "Full-card trigger",
        "The attachment surface acts as a link without hiding its semantics.",
        fdv_attachment_stage(
          @rui.attachment(style=["width:100%"], [
            @rui.attachment_media(showcase_file_icon()),
            fdv_attachment_content("briefing-notes.pdf", "PDF · 1.4 MB"),
            @rui.attachment_trigger_link(
              href="#data-display",
              aria_label="Open briefing notes",
              @html.nothing,
            ),
          ]),
          FdvAttachmentTriggerCode,
        ),
      ),
    ],
  )
}

///|
const FdvTypographyH1Code : String =
  #|@rui.typography_h1(style=["text-align:start"], "Taxing Laughter")
  #|

///|
const FdvTypographyH2Code : String =
  #|@rui.typography_h2("The Joke Tax Chronicles")
  #|

///|
const FdvTypographyH3Code : String =
  #|@rui.typography_h3("The people's response")
  #|

///|
const FdvTypographyH4Code : String =
  #|@rui.typography_h4("A compact heading")
  #|

///|
const FdvTypographyParagraphCode : String =
  #|@rui.typography_p(
  #|  "Body copy stays readable without imposing application layout.",
  #|)
  #|

///|
const FdvTypographyLeadCode : String =
  #|@rui.typography_lead(
  #|  "A king, a court jester, and one very expensive sense of humor.",
  #|)
  #|

///|
const FdvTypographyLargeCode : String =
  #|@rui.typography_large("Are you absolutely sure?")
  #|

///|
const FdvTypographySmallCode : String =
  #|@rui.typography_small("Email address")
  #|

///|
const FdvTypographyMutedCode : String =
  #|@rui.typography_muted("Enter the address associated with your account.")
  #|

///|
const FdvTypographyBlockquoteCode : String =
  #|@rui.typography_blockquote(
  #|  "After all, everyone enjoys a good joke—so why not charge for it?",
  #|)
  #|

///|
const FdvTypographyListCode : String =
  #|@rui.typography_list([
  #|  @html.li("First-class jokes: one gold coin"),
  #|  @html.li("Second-class jokes: one silver coin"),
  #|  @html.li("Bad jokes: no charge"),
  #|])
  #|

///|
const FdvTypographyInlineCodeCode : String =
  #|@rui.typography_p([
  #|  @html.text("The rule was named "),
  #|  @rui.typography_inline_code("joke_tax"),
  #|  @html.text("."),
  #|])
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
  #|  let columns : Array[@rui.DataTableColumn[Payment]] = [
  #|    @rui.data_table_column(
  #|      key="status",
  #|      label="Status",
  #|      value=row => row.status,
  #|      render=row => {
  #|        let variant : @rui.BadgeVariant = if row.status == "Failed" {
  #|          @rui.BadgeVariant::Destructive
  #|        } else if row.status == "Processing" {
  #|          @rui.BadgeVariant::Secondary
  #|        } else {
  #|          @rui.BadgeVariant::Outline
  #|        }
  #|        @rui.badge(variant~, row.status)
  #|      },
  #|    ),
  #|    @rui.data_table_column(
  #|      key="email",
  #|      label="Email",
  #|      value=row => row.email,
  #|    ),
  #|    @rui.data_table_column(
  #|      key="amount",
  #|      label="Amount",
  #|      value=row => row.amount_sort,
  #|      numeric=true,
  #|      render=row => @html.strong("$\{row.amount}"),
  #|    ),
  #|  ]
  #|  @rui.data_table(
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
const FdvItemDefaultCode : String =
  #|@rui.item(variant=@rui.ItemDefault, size=@rui.ItemDefaultSize, [
  #|  @rui.item_content([
  #|    @rui.item_title("Release notes"),
  #|    @rui.item_description("Documentation for the current release."),
  #|  ]),
  #|])
  #|

///|
const FdvItemOutlineSmallCode : String = FdvStrokeIconCode +
  (
    #|@rui.item(variant=@rui.ItemOutline, size=@rui.ItemSm, [
    #|  @rui.item_media(
    #|    variant=@rui.ItemMediaIcon,
    #|    stroke_icon(
    #|      "M9 3v2M15 3v2M9 19v2M15 19v2M3 9h2M3 15h2M19 9h2M19 15h2M7 7h10v10H7z",
    #|    ),
    #|  ),
    #|  @rui.item_content([
    #|    @rui.item_title("Runtime"),
    #|    @rui.item_description("JS and native targets are healthy."),
    #|  ]),
    #|  @rui.item_actions(@rui.button(variant=@rui.Ghost, size=@rui.Xs, "Inspect")),
    #|])
    #|
  )

///|
const FdvItemMutedImageCode : String =
  #|@rui.item(variant=@rui.ItemMuted, size=@rui.ItemDefaultSize, [
  #|  @rui.item_media(
  #|    variant=@rui.ItemMediaImage,
  #|    @html.div(
  #|      style=["width:100%;height:100%;background:var(--rui-muted)"],
  #|      @html.nothing,
  #|    ),
  #|  ),
  #|  @rui.item_content([
  #|    @rui.item_header("Preview build"),
  #|    @rui.item_title("Nova surface"),
  #|    @rui.item_description("Generated from the current token set."),
  #|    @rui.item_footer("Updated moments ago"),
  #|  ]),
  #|])
  #|

///|
const FdvEmptyDefaultCode : String = FdvStrokeIconCode +
  (
    #|@rui.empty(style=["padding:1.5rem 1rem"], [
    #|  @rui.empty_header([
    #|    @rui.empty_media(
    #|      variant=@rui.EmptyMediaDefault,
    #|      stroke_icon("M21 8v13H3V8M1 3h22v5H1zM10 12h4"),
    #|    ),
    #|    @rui.empty_title("No archives"),
    #|    @rui.empty_description("Archived projects will appear here."),
    #|  ]),
    #|  @rui.empty_content(@rui.button(size=@rui.Sm, "Browse projects")),
    #|])
    #|
  )

///|
const FdvEmptyIconCode : String = FdvStrokeIconCode +
  (
    #|@rui.empty(style=["padding:1.5rem 1rem"], [
    #|  @rui.empty_header([
    #|    @rui.empty_media(
    #|      variant=@rui.EmptyMediaIcon,
    #|      stroke_icon("M12 5v14M5 12h14"),
    #|    ),
    #|    @rui.empty_title("No release channels"),
    #|    @rui.empty_description("Create a channel for preview builds."),
    #|  ]),
    #|  @rui.empty_content(@rui.button(size=@rui.Sm, "Create channel")),
    #|])
    #|
  )

///|
const FdvMarkerDefaultCode : String = FdvStrokeIconCode +
  (
    #|@rui.marker(variant=@rui.MarkerDefault, [
    #|  @rui.marker_icon(stroke_icon("M3 12h4l2-8 4 16 2-8h6")),
    #|  @rui.marker_content("Deployment started"),
    #|])
    #|
  )

///|
const FdvMarkerSeparatorCode : String = FdvStrokeIconCode +
  (
    #|@rui.marker(variant=@rui.MarkerSeparator, [
    #|  @rui.marker_icon(stroke_icon("M12 12h.01")),
    #|  @rui.marker_content("Today"),
    #|])
    #|
  )

///|
const FdvMarkerBorderCode : String = FdvStrokeIconCode +
  (
    #|@rui.marker(variant=@rui.MarkerBorder, [
    #|  @rui.marker_icon(stroke_icon("M20 6 9 17l-5-5")),
    #|  @rui.marker_content("Validation complete"),
    #|])
    #|
  )

///|
const FdvProgressIndeterminateCode : String =
  #|@rui.progress(aria_label="Preparing release", children=[
  #|  @rui.progress_label("Preparing release"),
  #|  @rui.progress_value(text="Working"),
  #|])
  #|

///|
const FdvProgressDeterminateCode : String =
  #|@rui.progress(value=54, aria_label="Build progress", children=[
  #|  @rui.progress_label(value=54, "Build"),
  #|  @rui.progress_value(value=54),
  #|])
  #|

///|
fn fdv_typography_demo() -> @html.Html {
  showcase_component_demos(
    "Typography",
    "Semantic heading, body, list, quotation, code, and supporting-text recipes.",
    [
      fdv_demo_section(
        "H1",
        "Top-level page heading.",
        @rui.typography_h1(style=["text-align:start"], "Taxing Laughter"),
        FdvTypographyH1Code,
      ),
      fdv_demo_section(
        "H2",
        "Second-level section heading.",
        @rui.typography_h2("The Joke Tax Chronicles"),
        FdvTypographyH2Code,
      ),
      fdv_demo_section(
        "H3",
        "Third-level section heading.",
        @rui.typography_h3("The people's response"),
        FdvTypographyH3Code,
      ),
      fdv_demo_section(
        "H4",
        "Compact fourth-level heading.",
        @rui.typography_h4("A compact heading"),
        FdvTypographyH4Code,
      ),
      fdv_demo_section(
        "Paragraph",
        "Readable body copy.",
        @rui.typography_p(
          "Body copy stays readable without imposing application layout.",
        ),
        FdvTypographyParagraphCode,
      ),
      fdv_demo_section(
        "Lead",
        "Introductory copy with stronger presence.",
        @rui.typography_lead(
          "A king, a court jester, and one very expensive sense of humor.",
        ),
        FdvTypographyLeadCode,
      ),
      fdv_demo_section(
        "Large",
        "Large supporting text.",
        @rui.typography_large("Are you absolutely sure?"),
        FdvTypographyLargeCode,
      ),
      fdv_demo_section(
        "Small",
        "Compact supporting label.",
        @rui.typography_small("Email address"),
        FdvTypographySmallCode,
      ),
      fdv_demo_section(
        "Muted",
        "Low-emphasis supporting copy.",
        @rui.typography_muted("Enter the address associated with your account."),
        FdvTypographyMutedCode,
      ),
      fdv_demo_section(
        "Blockquote",
        "Quoted prose with a semantic border.",
        @rui.typography_blockquote(
          "After all, everyone enjoys a good joke—so why not charge for it?",
        ),
        FdvTypographyBlockquoteCode,
      ),
      fdv_demo_section(
        "List",
        "A semantic unordered list.",
        @rui.typography_list([
          @html.li("First-class jokes: one gold coin"),
          @html.li("Second-class jokes: one silver coin"),
          @html.li("Bad jokes: no charge"),
        ]),
        FdvTypographyListCode,
      ),
      fdv_demo_section(
        "Inline code",
        "Inline code embedded in a paragraph.",
        @rui.typography_p([
          @html.text("The rule was named "),
          @rui.typography_inline_code("joke_tax"),
          @html.text("."),
        ]),
        FdvTypographyInlineCodeCode,
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
  let columns : Array[@rui.DataTableColumn[FdvPayment]] = [
    @rui.data_table_column(
      key="status",
      label="Status",
      value=row => row.status,
      render=row => {
        let variant : @rui.BadgeVariant = if row.status == "Failed" {
          Destructive
        } else if row.status == "Processing" {
          Secondary
        } else {
          Outline
        }
        @rui.badge(variant~, row.status)
      },
    ),
    @rui.data_table_column(key="email", label="Email", value=row => row.email),
    @rui.data_table_column(
      key="amount",
      label="Amount",
      value=row => row.amount_sort,
      numeric=true,
      render=row => @html.strong("$\{row.amount}"),
    ),
  ]
  @rui.data_table(
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
fn fdv_items_demo() -> @html.Html {
  showcase_component_demos(
    "Item",
    "Default, outline, and muted surfaces in complete item compositions.",
    [
      fdv_demo_section(
        "Default",
        "A default item with title and description.",
        @rui.item(variant=ItemDefault, size=ItemDefaultSize, [
          @rui.item_content([
            @rui.item_title("Release notes"),
            @rui.item_description("Documentation for the current release."),
          ]),
        ]),
        FdvItemDefaultCode,
        stage_variant=ShowcaseStageSurface,
      ),
      fdv_demo_section(
        "Outline small",
        "A compact outlined item with an action.",
        @rui.item(variant=ItemOutline, size=ItemSm, [
          @rui.item_media(variant=ItemMediaIcon, showcase_runtime_icon()),
          @rui.item_content([
            @rui.item_title("Runtime"),
            @rui.item_description("JS and native targets are healthy."),
          ]),
          @rui.item_actions(@rui.button(variant=Ghost, size=Xs, "Inspect")),
        ]),
        FdvItemOutlineSmallCode,
        stage_variant=ShowcaseStageSurface,
      ),
      fdv_demo_section(
        "Muted image",
        "A muted item with image media and metadata.",
        @rui.item(variant=ItemMuted, size=ItemDefaultSize, [
          @rui.item_media(
            variant=ItemMediaImage,
            @html.div(
              style=["width:100%;height:100%;background:var(--rui-muted)"],
              @html.nothing,
            ),
          ),
          @rui.item_content([
            @rui.item_header("Preview build"),
            @rui.item_title("Nova surface"),
            @rui.item_description("Generated from the current token set."),
            @rui.item_footer("Updated moments ago"),
          ]),
        ]),
        FdvItemMutedImageCode,
        stage_variant=ShowcaseStageSurface,
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
      fdv_demo_section(
        "Default media",
        "A default media treatment and action.",
        @rui.empty(style=["padding:1.5rem 1rem"], [
          @rui.empty_header([
            @rui.empty_media(variant=EmptyMediaDefault, showcase_archive_icon()),
            @rui.empty_title("No archives"),
            @rui.empty_description("Archived projects will appear here."),
          ]),
          @rui.empty_content(@rui.button(size=Sm, "Browse projects")),
        ]),
        FdvEmptyDefaultCode,
        tall=true,
      ),
      fdv_demo_section(
        "Icon media",
        "A framed icon treatment and action.",
        @rui.empty(style=["padding:1.5rem 1rem"], [
          @rui.empty_header([
            @rui.empty_media(variant=EmptyMediaIcon, showcase_plus_icon()),
            @rui.empty_title("No release channels"),
            @rui.empty_description("Create a channel for preview builds."),
          ]),
          @rui.empty_content(@rui.button(size=Sm, "Create channel")),
        ]),
        FdvEmptyIconCode,
        tall=true,
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
      fdv_demo_section(
        "Default",
        "A default timeline marker.",
        @rui.marker(variant=MarkerDefault, [
          @rui.marker_icon(showcase_activity_icon()),
          @rui.marker_content("Deployment started"),
        ]),
        FdvMarkerDefaultCode,
        stage_variant=ShowcaseStageSurface,
      ),
      fdv_demo_section(
        "Separator",
        "A marker that divides timeline sections.",
        @rui.marker(variant=MarkerSeparator, [
          @rui.marker_icon(showcase_separator_dot_icon()),
          @rui.marker_content("Today"),
        ]),
        FdvMarkerSeparatorCode,
        stage_variant=ShowcaseStageSurface,
      ),
      fdv_demo_section(
        "Border",
        "A bordered marker for a completed event.",
        @rui.marker(variant=MarkerBorder, [
          @rui.marker_icon(showcase_check_icon()),
          @rui.marker_content("Validation complete"),
        ]),
        FdvMarkerBorderCode,
        stage_variant=ShowcaseStageSurface,
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
      fdv_demo_section(
        "Indeterminate",
        "Progress without a known completion value.",
        @rui.progress(aria_label="Preparing release", children=[
          @rui.progress_label("Preparing release"),
          @rui.progress_value(text="Working"),
        ]),
        FdvProgressIndeterminateCode,
      ),
      fdv_demo_section(
        "Determinate",
        "Progress with a readable completion value.",
        @rui.progress(value=54, aria_label="Build progress", children=[
          @rui.progress_label(value=54, "Build"),
          @rui.progress_value(value=54),
        ]),
        FdvProgressDeterminateCode,
      ),
    ],
  )
}
