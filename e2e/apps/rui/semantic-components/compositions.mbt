///|
fn semantic_compositions_fixture() -> Html {
  @fixture.section(
    "fixture-section-semantic-compositions",
    "Content Compositions",
    [
      @rui.card(id="fixture-card", style=["width:18rem"], [
        @rui.card_header([
          @rui.card_title("Fixture card"),
          @rui.card_description("A complete card composition."),
        ]),
        @rui.card_content("Stable component content"),
        @rui.card_footer(@rui.badge(variant=Outline, "Ready")),
      ]),
      @rui.empty(id="fixture-empty", style=["width:18rem"], [
        @rui.empty_header([
          @rui.empty_media(variant=EmptyMediaIcon, "∅"),
          @rui.empty_title("No fixture results"),
          @rui.empty_description("Try another semantic query."),
        ]),
        @rui.empty_content(
          @rui.button(variant=Outline, "Reset fixture filters"),
        ),
      ]),
      @rui.item_group(
        id="fixture-item-group",
        style=["width:18rem"],
        @rui.item([
          @rui.item_media(variant=ItemMediaIcon, "F"),
          @rui.item_content([
            @rui.item_title("Fixture item"),
            @rui.item_description("Item description"),
          ]),
        ]),
      ),
      @rui.message(id="fixture-message", align=AlignEnd, [
        @rui.message_avatar(@rui.avatar(@rui.avatar_fallback("RU"))),
        @rui.message_content([
          @rui.message_header("RUI fixture"),
          @rui.bubble_group(
            @rui.bubble(
              variant=BubbleSecondary,
              align=AlignEnd,
              @rui.bubble_content("Semantic message bubble"),
            ),
          ),
          @rui.message_footer("Delivered"),
        ]),
      ]),
    ],
  )
}
