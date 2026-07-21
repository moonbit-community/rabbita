///|
#cfg(target="native")
#warnings("-alert_unstable")
test "map19 and view19 combine nineteen values" {
  let a = @rabbita.Val::constant(1)
  let b = @rabbita.Val::constant("two")
  let c = @rabbita.Val::constant(true)
  let d = @rabbita.Val::constant(4)
  let e = @rabbita.Val::constant("five")
  let f = @rabbita.Val::constant(false)
  let g = @rabbita.Val::constant(7)
  let h = @rabbita.Val::constant("eight")
  let i = @rabbita.Val::constant(true)
  let j = @rabbita.Val::constant(10)
  let k = @rabbita.Val::constant("eleven")
  let l = @rabbita.Val::constant(false)
  let m = @rabbita.Val::constant(13)
  let n = @rabbita.Val::constant("fourteen")
  let o = @rabbita.Val::constant(true)
  let p = @rabbita.Val::constant(16)
  let q = @rabbita.Val::constant("seventeen")
  let r = @rabbita.Val::constant(false)
  let s = @rabbita.Val::constant(19)
  let mapped = a.map19(b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, (
    a,
    b,
    c,
    d,
    e,
    f,
    g,
    h,
    i,
    j,
    k,
    l,
    m,
    n,
    o,
    p,
    q,
    r,
    s,
  ) => {
    "\{a}|\{b}|\{c}|\{d}|\{e}|\{f}|\{g}|\{h}|\{i}|\{j}|\{k}|\{l}|\{m}|\{n}|\{o}|\{p}|\{q}|\{r}|\{s}"
  })
  inspect(
    @rabbita.render_to_string(() => mapped.view(value => @html.div("\{value}"))),
    content="<div>1|two|true|4|five|false|7|eight|true|10|eleven|false|13|fourteen|true|16|seventeen|false|19</div>",
  )

  let viewed = a.view19(b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, (
    a,
    b,
    c,
    d,
    e,
    f,
    g,
    h,
    i,
    j,
    k,
    l,
    m,
    n,
    o,
    p,
    q,
    r,
    s,
  ) => {
    @html.div(
      "\{a}|\{b}|\{c}|\{d}|\{e}|\{f}|\{g}|\{h}|\{i}|\{j}|\{k}|\{l}|\{m}|\{n}|\{o}|\{p}|\{q}|\{r}|\{s}",
    )
  })
  inspect(
    @rabbita.render_to_string(() => viewed),
    content="<div>1|two|true|4|five|false|7|eight|true|10|eleven|false|13|fourteen|true|16|seventeen|false|19</div>",
  )
}
