local config = import 'default.jsonnet';

config {
  'dhives_5438-1'+: {
    config+: {
      storage: {
        discard_abci_responses: true,
      },
    },
  },
}
