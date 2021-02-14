# Changelog

## 0.3.1
- Add support for common `<link>` tags: `next`, `canonical`, `alternate`
  and `apple-touch-icon-precomposed`
- Add `Metatags.put/4` to enable extra attributes to be set on the metatags.
  One example would be:

  ```elixir
  Metatags.put(conn, "alternate", "https://my-url.se", hreflang: "sv_SE")
  ```

## 0.3.0
- Move configuration of default values to the plug definition
- Extract the plug to `Metatags.Plug`

  *Migrate*:
  First, change the plug from `Metatags` to `Metatags.Plug`.
  After that you can move whatever you have in your configuration and put
  behind `plug Metatags.Plug` in your router. If you require environment
  specific defaults, use `Application.get_env/3`.

## 0.2.2
- Add `[String.t()]` to `Metatags.put/3` type spec
- Replace `ESpec` with `ExUnit` in internal test suite
