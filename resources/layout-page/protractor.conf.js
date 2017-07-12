// A reference configuration file.
'use strict';
exports.config = {
    //seleniumServerJar: './node_modules/protractor/selenium/selenium-server-standalone-2.42.0.jar',
    //seleniumPort: null,
    chromeDriver: './node_modules/protractor/node_modules/webdriver-manager/selenium/chromedriver_2.26',
    //seleniumArgs: [],
    directConnect: true,

    specs: [
        'src/test/js/e2e/**/*.e2e.js'
    ],

    capabilities: {
        'browserName': 'chrome'
    },

    baseUrl: 'http://localhost:8083',

    rootElement: 'body',

};
