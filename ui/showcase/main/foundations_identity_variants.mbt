///|
const IdentityVariantsStackStyle : String = "display:flex;min-width:0;flex-direction:column;gap:4rem;align-items:stretch"

///|
const IdentityVariantsGridStyle : String = "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,14rem),1fr));gap:1rem;align-items:start"

///|
const IdentityVariantStyle : String = "display:flex;min-width:0;flex-direction:column;gap:0.75rem"

///|
const IdentityVariantLabelStyle : String = "margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.25rem;font-weight:500"

///|
const IdentitySurfaceStyle : String = "box-sizing:border-box;min-width:0;padding:0.25rem"

///|
const IdentityAspectSurfaceStyle : String = "display:flex;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:calc(var(--rui-radius) - 0.125rem);background:color-mix(in oklab,var(--rui-muted) 55%,var(--rui-background));color:var(--rui-muted-foreground);font-size:0.8125rem;font-weight:600"

///|
const IdentityAvatarImage : String = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 80 80'%3E%3Crect width='80' height='80' rx='16' fill='%2318171b'/%3E%3Ccircle cx='40' cy='30' r='14' fill='%23fafafa'/%3E%3Cpath d='M14 80c2-20 12-31 26-31s24 11 26 31' fill='%23fafafa'/%3E%3C/svg%3E"

///|
const IdentityAvatarCode : String =
  #|fn avatar_variant(label : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.p(
  #|        style=[
  #|          "margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.25rem;font-weight:500",
  #|        ],
  #|        label,
  #|      ),
  #|      body,
  #|    ],
  #|  )
  #|}
  #|
  #|fn avatar_demo() -> @html.Html {
  #|  let image = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 80 80'%3E%3Crect width='80' height='80' rx='16' fill='%2318171b'/%3E%3Ccircle cx='40' cy='30' r='14' fill='%23fafafa'/%3E%3Cpath d='M14 80c2-20 12-31 26-31s24 11 26 31' fill='%23fafafa'/%3E%3C/svg%3E"
  #|  @html.div(
  #|    style=[
  #|      "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,14rem),1fr));gap:1rem;align-items:start",
  #|    ],
  #|    [
  #|      avatar_variant("Default", @html.div(style=["padding:0.25rem"], [
  #|        @ui.avatar(@ui.avatar_fallback("AV")),
  #|      ])),
  #|      avatar_variant("Sm", @html.div(style=["padding:0.25rem"], [
  #|        @ui.avatar(size=@ui.Sm, @ui.avatar_fallback("SM")),
  #|      ])),
  #|      avatar_variant("Lg", @html.div(style=["padding:0.25rem"], [
  #|        @ui.avatar(size=@ui.Lg, @ui.avatar_fallback("LG")),
  #|      ])),
  #|      avatar_variant(
  #|        "Image, fallback, and badge",
  #|        @html.div(style=["padding:0.25rem"], [
  #|          @ui.avatar(size=@ui.Lg, [
  #|            @ui.avatar_image(src=image, alt="Alex Rivera", width=80, height=80),
  #|            @ui.avatar_fallback("AR"),
  #|            @ui.avatar_badge(""),
  #|          ]),
  #|        ]),
  #|      ),
  #|      avatar_variant("Group and count", @html.div(style=["padding:0.25rem"], [
  #|        @ui.avatar_group([
  #|          @ui.avatar(@ui.avatar_fallback("YO")),
  #|          @ui.avatar(@ui.avatar_fallback("RA")),
  #|          @ui.avatar(@ui.avatar_fallback("MB")),
  #|          @ui.avatar_group_count("+4"),
  #|        ]),
  #|      ])),
  #|    ],
  #|  )
  #|}
  #|

///|
const IdentityCardCode : String =
  #|fn card_variant(label : String, body : @html.Html) -> @html.Html {
  #|  @html.div(
  #|    style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|    [
  #|      @html.p(
  #|        style=[
  #|          "margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.25rem;font-weight:500",
  #|        ],
  #|        label,
  #|      ),
  #|      body,
  #|    ],
  #|  )
  #|}
  #|
  #|fn card_demo() -> @html.Html {
  #|  @html.div(
  #|    style=[
  #|      "display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,14rem),1fr));gap:1rem;align-items:start",
  #|    ],
  #|    [
  #|      card_variant("Default", @ui.card([
  #|        @ui.card_header([
  #|          @ui.card_title("Release notes"),
  #|          @ui.card_description("Review the changes included in this release."),
  #|          @ui.card_action(@ui.button(variant=@ui.Ghost, size=@ui.Sm, "Open")),
  #|        ]),
  #|        @ui.card_content(@html.p(
  #|          style=["margin:0;font-size:0.875rem;line-height:1.4"],
  #|          "The component package is ready for final review.",
  #|        )),
  #|        @ui.card_footer(style=["justify-content:space-between"], [
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.8125rem"],
  #|            "Updated just now",
  #|          ),
  #|          @ui.button(size=@ui.Sm, "Review"),
  #|        ]),
  #|      ])),
  #|      card_variant("Sm", @ui.card(size=@ui.Sm, [
  #|        @ui.card_header([
  #|          @ui.card_title("Preview build"),
  #|          @ui.card_description("A compact card using the same composition."),
  #|          @ui.card_action(@ui.button(variant=@ui.Ghost, size=@ui.Xs, "Open")),
  #|        ]),
  #|        @ui.card_content(@html.p(
  #|          style=["margin:0;font-size:0.8125rem;line-height:1.4"],
  #|          "Checks passed and the preview is available.",
  #|        )),
  #|        @ui.card_footer(style=["justify-content:space-between"], [
  #|          @html.span(
  #|            style=["color:var(--rui-muted-foreground);font-size:0.75rem"],
  #|            "Ready",
  #|          ),
  #|          @ui.button(size=@ui.Xs, "View"),
  #|        ]),
  #|      ])),
  #|    ],
  #|  )
  #|}
  #|

///|
const IdentityAspectRatioCode : String =
  #|fn aspect_ratio_demo() -> @html.Html {
  #|  let surface = "display:flex;align-items:center;justify-content:center;border:1px solid var(--rui-border);border-radius:calc(var(--rui-radius) - 0.125rem);background:color-mix(in oklab,var(--rui-muted) 55%,var(--rui-background));color:var(--rui-muted-foreground);font-size:0.8125rem;font-weight:600"
  #|  let variant = fn(label, body) {
  #|    @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|      [
  #|        @html.p(
  #|          style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.25rem;font-weight:500"],
  #|          label,
  #|        ),
  #|        body,
  #|      ],
  #|    )
  #|  }
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,14rem),1fr));gap:1rem;align-items:start"],
  #|    [
  #|      variant("1:1", @ui.aspect_ratio(ratio=1.0, style=[surface], @html.span("1:1"))),
  #|      variant("4:3", @ui.aspect_ratio(ratio=1.3333333333, style=[surface], @html.span("4:3"))),
  #|      variant("16:9", @ui.aspect_ratio(ratio=1.7777777778, style=[surface], @html.span("16:9"))),
  #|    ],
  #|  )
  #|}
  #|

///|
const IdentityDirectionCode : String =
  #|fn direction_demo() -> @html.Html {
  #|  let variant = fn(label, body) {
  #|    @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|      [
  #|        @html.p(
  #|          style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.25rem;font-weight:500"],
  #|          label,
  #|        ),
  #|        body,
  #|      ],
  #|    )
  #|  }
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,14rem),1fr));gap:1rem;align-items:start"],
  #|    [
  #|      variant("Ltr", @ui.direction(
  #|        direction=@ui.Ltr,
  #|        style=["box-sizing:border-box;min-width:0;padding:0.25rem", "text-align:start"],
  #|        [
  #|          @html.div(style=["font-weight:600"], "Build complete"),
  #|          @html.div(
  #|            style=["margin-top:0.25rem;color:var(--rui-muted-foreground);font-size:0.8125rem"],
  #|            "The release is ready to publish.",
  #|          ),
  #|        ],
  #|      )),
  #|      variant("Rtl", @ui.direction(
  #|        direction=@ui.Rtl,
  #|        style=["box-sizing:border-box;min-width:0;padding:0.25rem", "text-align:start"],
  #|        [
  #|          @html.div(style=["font-weight:600"], "اكتمل البناء"),
  #|          @html.div(
  #|            style=["margin-top:0.25rem;color:var(--rui-muted-foreground);font-size:0.8125rem"],
  #|            "الإصدار جاهز للنشر.",
  #|          ),
  #|        ],
  #|      )),
  #|    ],
  #|  )
  #|}
  #|

///|
const IdentitySeparatorCode : String =
  #|fn separator_demo() -> @html.Html {
  #|  let variant = fn(label, body) {
  #|    @html.div(
  #|      style=["display:flex;min-width:0;flex-direction:column;gap:0.75rem"],
  #|      [
  #|        @html.p(
  #|          style=["margin:0;color:var(--rui-muted-foreground);font-size:0.8125rem;line-height:1.25rem;font-weight:500"],
  #|          label,
  #|        ),
  #|        body,
  #|      ],
  #|    )
  #|  }
  #|  @html.div(
  #|    style=["display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,14rem),1fr));gap:1rem;align-items:start"],
  #|    [
  #|      variant("Horizontal", @html.div(
  #|        style=["box-sizing:border-box;min-width:0;padding:0.25rem", "display:flex;flex-direction:column;gap:0.75rem"],
  #|        [
  #|          @html.span("Release"),
  #|          @ui.separator(orientation=@ui.Horizontal),
  #|          @html.span("Activity"),
  #|        ],
  #|      )),
  #|      variant("Vertical", @html.div(
  #|        style=["box-sizing:border-box;min-width:0;padding:0.25rem", "display:flex;min-height:4rem;align-items:center;gap:1rem"],
  #|        [
  #|          @html.span("Release"),
  #|          @ui.separator(orientation=@ui.Vertical, style=["height:2.5rem"]),
  #|          @html.span("Activity"),
  #|        ],
  #|      )),
  #|    ],
  #|  )
  #|}
  #|

///|
fn identity_variant(label : String, body : @html.Html) -> @html.Html {
  @html.div(style=[IdentityVariantStyle], [
    @html.p(style=[IdentityVariantLabelStyle], label),
    body,
  ])
}

///|
fn identity_component_demo(
  title : String,
  description : String,
  variant_title : String,
  variant_description : String,
  body : @html.Html,
  code : String,
  tall? : Bool = false,
  stage_variant? : ShowcaseStageVariant = ShowcaseStageSurface,
) -> @html.Html {
  showcase_component_demos(title, description, [
    showcase_demo_section(
      variant_title,
      variant_description,
      showcase_demo_stage(body, code, variant=stage_variant, tall~),
    ),
  ])
}

///|
fn foundations_identity_variants() -> @html.Html {
  @html.div(style=[IdentityVariantsStackStyle], [
    identity_component_demo(
      "Avatar",
      "Fallbacks, images, badges, sizes, and grouped identities.",
      "Sizes, media, and groups",
      "Fallback, image, badge, and grouped compositions use the same avatar surface.",
      @html.div(style=[IdentityVariantsGridStyle], [
        identity_variant(
          "Default",
          @html.div(style=[IdentitySurfaceStyle], [
            @ui.avatar(@ui.avatar_fallback("AV")),
          ]),
        ),
        identity_variant(
          "Sm",
          @html.div(style=[IdentitySurfaceStyle], [
            @ui.avatar(size=@ui.Sm, @ui.avatar_fallback("SM")),
          ]),
        ),
        identity_variant(
          "Lg",
          @html.div(style=[IdentitySurfaceStyle], [
            @ui.avatar(size=@ui.Lg, @ui.avatar_fallback("LG")),
          ]),
        ),
        identity_variant(
          "Image, fallback, and badge",
          @html.div(style=[IdentitySurfaceStyle], [
            @ui.avatar(size=@ui.Lg, [
              @ui.avatar_image(
                src=IdentityAvatarImage,
                alt="Alex Rivera",
                width=80,
                height=80,
              ),
              @ui.avatar_fallback("AR"),
              @ui.avatar_badge(""),
            ]),
          ]),
        ),
        identity_variant(
          "Group and count",
          @html.div(style=[IdentitySurfaceStyle], [
            @ui.avatar_group([
              @ui.avatar(@ui.avatar_fallback("YO")),
              @ui.avatar(@ui.avatar_fallback("RA")),
              @ui.avatar(@ui.avatar_fallback("MB")),
              @ui.avatar_group_count("+4"),
            ]),
          ]),
        ),
      ]),
      IdentityAvatarCode,
    ),
    identity_component_demo(
      "Card",
      "Default and compact compositions with headers, actions, content, and footers.",
      "Default and compact",
      "Both sizes preserve the complete header, content, action, and footer composition.",
      @html.div(style=[IdentityVariantsGridStyle], [
        identity_variant(
          "Default",
          @ui.card([
            @ui.card_header([
              @ui.card_title("Release notes"),
              @ui.card_description(
                "Review the changes included in this release.",
              ),
              @ui.card_action(
                @ui.button(variant=@ui.Ghost, size=@ui.Sm, "Open"),
              ),
            ]),
            @ui.card_content(
              @html.p(
                style=["margin:0;font-size:0.875rem;line-height:1.4"],
                "The component package is ready for final review.",
              ),
            ),
            @ui.card_footer(style=["justify-content:space-between"], [
              @html.span(
                style=["color:var(--rui-muted-foreground);font-size:0.8125rem"],
                "Updated just now",
              ),
              @ui.button(size=@ui.Sm, "Review"),
            ]),
          ]),
        ),
        identity_variant(
          "Sm",
          @ui.card(size=@ui.Sm, [
            @ui.card_header([
              @ui.card_title("Preview build"),
              @ui.card_description("A compact card using the same composition."),
              @ui.card_action(
                @ui.button(variant=@ui.Ghost, size=@ui.Xs, "Open"),
              ),
            ]),
            @ui.card_content(
              @html.p(
                style=["margin:0;font-size:0.8125rem;line-height:1.4"],
                "Checks passed and the preview is available.",
              ),
            ),
            @ui.card_footer(style=["justify-content:space-between"], [
              @html.span(
                style=["color:var(--rui-muted-foreground);font-size:0.75rem"],
                "Ready",
              ),
              @ui.button(size=@ui.Xs, "View"),
            ]),
          ]),
        ),
      ]),
      IdentityCardCode,
      tall=true,
    ),
    identity_component_demo(
      "Aspect Ratio",
      "Common media proportions keep their geometry across responsive widths.",
      "Common ratios",
      "Square, landscape, and widescreen frames retain their ratio as their container changes.",
      @html.div(style=[IdentityVariantsGridStyle], [
        identity_variant(
          "1:1",
          @ui.aspect_ratio(
            ratio=1.0,
            style=[IdentityAspectSurfaceStyle],
            @html.span("1:1"),
          ),
        ),
        identity_variant(
          "4:3",
          @ui.aspect_ratio(
            ratio=1.3333333333,
            style=[IdentityAspectSurfaceStyle],
            @html.span("4:3"),
          ),
        ),
        identity_variant(
          "16:9",
          @ui.aspect_ratio(
            ratio=1.7777777778,
            style=[IdentityAspectSurfaceStyle],
            @html.span("16:9"),
          ),
        ),
      ]),
      IdentityAspectRatioCode,
      stage_variant=ShowcaseStagePlain,
    ),
    identity_component_demo(
      "Direction",
      "Left-to-right and right-to-left content share the same component surface.",
      "Writing directions",
      "Logical alignment follows the local direction without changing the component API.",
      @html.div(style=[IdentityVariantsGridStyle], [
        identity_variant(
          "Ltr",
          @ui.direction(
            direction=@ui.Ltr,
            style=[IdentitySurfaceStyle, "text-align:start"],
            [
              @html.div(style=["font-weight:600"], "Build complete"),
              @html.div(
                style=[
                  "margin-top:0.25rem;color:var(--rui-muted-foreground);font-size:0.8125rem",
                ],
                "The release is ready to publish.",
              ),
            ],
          ),
        ),
        identity_variant(
          "Rtl",
          @ui.direction(
            direction=@ui.Rtl,
            style=[IdentitySurfaceStyle, "text-align:start"],
            [
              @html.div(style=["font-weight:600"], "اكتمل البناء"),
              @html.div(
                style=[
                  "margin-top:0.25rem;color:var(--rui-muted-foreground);font-size:0.8125rem",
                ],
                "الإصدار جاهز للنشر.",
              ),
            ],
          ),
        ),
      ]),
      IdentityDirectionCode,
      stage_variant=ShowcaseStagePlain,
    ),
    identity_component_demo(
      "Separator",
      "Horizontal and vertical separators divide related content without adding a container.",
      "Orientations",
      "Horizontal and vertical separators divide related content with native semantics.",
      @html.div(style=[IdentityVariantsGridStyle], [
        identity_variant(
          "Horizontal",
          @html.div(
            style=[
              IdentitySurfaceStyle,
              "display:flex;flex-direction:column;gap:0.75rem",
            ],
            [
              @html.span("Release"),
              @ui.separator(orientation=@ui.Horizontal),
              @html.span("Activity"),
            ],
          ),
        ),
        identity_variant(
          "Vertical",
          @html.div(
            style=[
              IdentitySurfaceStyle,
              "display:flex;min-height:4rem;align-items:center;gap:1rem",
            ],
            [
              @html.span("Release"),
              @ui.separator(orientation=@ui.Vertical, style=["height:2.5rem"]),
              @html.span("Activity"),
            ],
          ),
        ),
      ]),
      IdentitySeparatorCode,
    ),
  ])
}
