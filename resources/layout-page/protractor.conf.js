// A reference configuration file.
'use strict';
exports.config = {
    seleniumServerJar: './node_modules/webdriver-manager/selenium/selenium-server-standalone-2.53.1.jar',
    seleniumPort: null,
    //chromeDriver: './node_modules/protractor/selenium/chromedriver',
    seleniumArgs: [],
    chromeDriver: './node_modules/webdriver-manager/selenium/chromedriver_2.24',  
    // If true, only ChromeDriver will be started, not a Selenium Server.
    // Tests for browsers other than Chrome will not run.
    chromeOnly: false,
    seleniumAddress: null,
    sauceUser: null,
    sauceKey: null,
    sauceSeleniumAddress: null,
    
    specs: [
        'src/test/js/e2e/**/*.e2e.js'
    ],

    exclude: [],
    
    capabilities: {
        browserName: 'chrome',
    
        // Number of times to run this set of capabilities (in parallel, unless
        // limited by maxSessions). Default is 1.
        count: 1,
    
        // If this is set to be true, specs will be sharded by file (i.e. all
        // files to be run by this set of capabilities will run in parallel).
        // Default is false.
        shardTestFiles: false,
    
        // Maximum number of browser instances that can run in parallel for this
        // set of capabilities. This is only needed if shardTestFiles is true.
        // Default is 1.
        maxInstances: 1,
    
        // This option allows to hide the warning "--ignore-certificate-errors" in chrome
        chromeOptions: {
          args: ['--test-type']
        }
    
        // Additional spec files to be run on this capability only.
        // specs: ['spec/chromeOnlySpec.js']
    
    },
    
    multiCapabilities: [],
    maxSessions: -1,
    
    baseUrl: 'http://localhost:8083',

    rootElement: 'body',
    
    allScriptsTimeout: 11000,
    
      // How long to wait for a page to load.
    getPageTimeout: 10000,
    
    params: {
        //login: {
        //    user: 'Jane',
        //    password: '1234'
        //}
    },

    
};
