local config = import 'default.jsonnet';

config {
  'egax_5438-1'+: {
    config+: {
      storage: {
        discard_abci_responses: true,
      },
    },
  },
}
