local default = import 'default.jsonnet';

default {
  'dhives_5438-1'+: {
    config+: {
      consensus+: {
        timeout_commit: '5s',
      },
    },
  },
}
