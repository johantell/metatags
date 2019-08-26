# Changelog

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
