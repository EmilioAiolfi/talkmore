# Karma configuration
# http://karma-runner.github.io/0.12/config/configuration-file.html
# Generated on 2016-02-04 using
# generator-karma 1.0.0

module.exports = (config) ->
  config.set
    # base path, that will be used to resolve files and exclude
    basePath: '../'

    # testing framework to use (jasmine/mocha/qunit/...)
    # as well as any additional frameworks (requirejs/chai/sinon/...)
    frameworks: [
      "jasmine"
    ]

    # list of files / patterns to load in the browser
    files: [
      # bower:js
      'bower_components/jquery/dist/jquery.js'
      'bower_components/angular/angular.js'
      'bower_components/angular-mocks/angular-mocks.js'
      'bower_components/angular-animate/angular-animate.js'
      'bower_components/angular-aria/angular-aria.js'
      'bower_components/angular-cookies/angular-cookies.js'
      'bower_components/angular-messages/angular-messages.js'
      'bower_components/angular-resource/angular-resource.js'
      'bower_components/angular-sanitize/angular-sanitize.js'
      'bower_components/angular-touch/angular-touch.js'
      'bower_components/angular-ui-router/release/angular-ui-router.js'
      'bower_components/angular-bootstrap/ui-bootstrap-tpls.js'
      'bower_components/lodash/lodash.js'
      'bower_components/restangular/dist/restangular.js'
      'bower_components/fastclick/lib/fastclick.js'
      'bower_components/angular-loading-bar/build/loading-bar.js'
      # endbower
      # bower:coffee
      # endbower
      "app/scripts/**/*.coffee"
      "app/views/**/*.html"
      "test/mock/**/*.coffee"
      "test/spec/**/*.coffee"
    ],

    # list of files / patterns to exclude
    exclude: [
    ]

    # web server port
    port: 8080

    # level of logging
    # possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
    logLevel: config.LOG_INFO

    # Start these browsers, currently available:
    # - Chrome
    # - ChromeCanary
    # - Firefox
    # - Opera
    # - Safari (only Mac)
    # - PhantomJS
    # - IE (only Windows)
    browsers: [
      "PhantomJS"
    ]

    # Which plugins to enable
    plugins: [
      "karma-phantomjs-launcher",
      "karma-jasmine",
      "karma-coffee-preprocessor",
      "karma-ng-html2js-preprocessor"
    ]

    reporters: 'progress'

    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true

    # Continuous Integration mode
    # if true, it capture browsers, run tests and exit
    singleRun: false

    colors: true

    preprocessors:
      '**/*.coffee': ['coffee']
      '**/*.html': ['ng-html2js']

    ngHtml2JsPreprocessor:
      moduleName: 'talkmoreApp'

    # Uncomment the following lines if you are using grunt's server to run the tests
    # proxies: '/': 'http://localhost:9000/'
    # URL root prevent conflicts with the site root
    # urlRoot: '_karma_'
