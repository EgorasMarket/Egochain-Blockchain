local default = import 'default.jsonnet';

default {
  'egax_5438-1'+: {
    config+: {
      consensus+: {
        timeout_commit: '5s',
      },
    },
  },
}
