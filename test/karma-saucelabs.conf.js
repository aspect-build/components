const {customLaunchers, platformMap} = require('./browser-providers');
const path = require('path');

module.exports = karmaConfig => {
  const config = {
    plugins: [
      require('../tools/saucelabs-bazel/launcher/index.js').default,
    ],

    customLaunchers: customLaunchers,

    browserNoActivityTimeout: 90000,
    browserDisconnectTimeout: 90000,
    browserDisconnectTolerance: 2,
    captureTimeout: 90000,
    browsers: platformMap.saucelabs,
    transports: ['polling'],
    // Configure the Karma spec reporter so that spec timing is captured.
    specReporter: {
      showSpecTiming: true,
    },
  };

  // Setup the Karma spec reporter so that debugging of slow tests on CI is easier.
  // Note that we need to override it using `defineProperty` because otherwise
  // `@bazel/concatjs` always appends the `progress` reporter that causes unreadable
  // console output on CI.
  Object.defineProperty(config, 'reporters', {
    get: () => ['spec'],
    set: () => {},
    enumerable: true,
  });

  karmaConfig.set(config);
};
