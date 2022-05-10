Mox.defmock(Tesla.MockAdapter, for: Tesla.Adapter)

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true, seed: 0)
