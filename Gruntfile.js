'use strict';

module.exports = function (grunt) {

  // Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt);

  // Automatically load required Grunt tasks
  require('jit-grunt')(grunt, {
    useminPrepare: 'grunt-usemin',
    ngtemplates: 'grunt-angular-templates',
    cdnify: 'grunt-google-cdn'
  });

  // Feature: generator prompt for html5mode support
  var modRewrite = require('connect-modrewrite')([
    '!\\.ttf|\\.woff|\\.ttf|\\.eot|\\.html|\\.js|\\.coffee|\\.css|\\.png|\\.jpg|\\.gif|\\.svg$ /index.html [L]'
  ]);

  // Configurable paths for the application
  var appConfig = {
    app: require('./bower.json').appPath || 'app',
    dist: 'dist'
  };

  // Define the configuration for all the tasks
  grunt.initConfig({

    // Project settings
    talkmore: appConfig,

    // Watches files for changes and runs tasks based on the changed files
    watch: {
      bower: {
        files: ['bower.json'],
        tasks: ['wiredep']
      },
      coffee: {
        files: ['<%= talkmore.app %>/scripts/{,*/}*.{coffee,litcoffee,coffee.md}'],
        tasks: ['newer:coffee:dist']
      },
      coffeeTest: {
        files: ['test/spec/{,*/}*.{coffee,litcoffee,coffee.md}'],
        tasks: ['newer:coffee:test', 'karma']
      },
      sass: {
        files: ['<%= talkmore.app %>/styles/{,*/}*.{scss,sass}'],
        tasks: ['sass:server', 'postcss:server']
      },
      gruntfile: {
        files: ['Gruntfile.js']
      },
      livereload: {
        files: [
          '<%= talkmore.app %>/{,*/}*.html',
          '.tmp/styles/{,*/}*.css',
          '.tmp/scripts/{,*/}*.js',
          '<%= talkmore.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
      }
    },

    // The actual grunt server settings
    browserSync: {
      livereload: {
        bsFiles: {
          src: [
            '<%= talkmore.app %>/{,*/}*.html',
            '.tmp/styles/{,*/}*.css',
            '<%= talkmore.app %>/scripts/{,*/}*.js',
            '<%= talkmore.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
          ]
        },
        options: {
          watchTask: true,
          server: {
            middleware: [
                modRewrite
            ],
            baseDir: [appConfig.app, '.tmp'],
            routes: {
              '/bower_components': 'bower_components'
            }
          }
        }
      },
      dist: {
        bsFiles: {
          src: '<%= talkmore.dist %>/{,*/}*.html'
        },
        options: {
          server: {
            baseDir: appConfig.dist
          }
        }
      },
      test: {
        bsFiles: {
          src: 'test/spec/{,*/}*.js'
        },
        options: {
          watchTask: true,
          port: 9001,
          open: false,
          logLevel: 'silent',
          server: {
            baseDir: ['test', '.tmp', appConfig.app],
            routes: {
              '/bower_components': 'bower_components'
            }
          }
        }
      }
    },

    // Make sure code styles are up to par and there are no obvious mistakes
    jshint: {
      options: {
        jshintrc: '.jshintrc',
        reporter: require('jshint-stylish')
      },
      all: {
        src: [
          'Gruntfile.js'
        ]
      }
    },

    // Empties folders to start fresh
    clean: {
      dist: {
        files: [{
          dot: true,
          src: [
            '.tmp',
            '<%= talkmore.dist %>/{,*/}*',
            '!<%= talkmore.dist %>/.git{,*/}*'
          ]
        }]
      },
      server: '.tmp'
    },

    // Add vendor prefixed styles
    postcss: {
      options: {
        processors: [
          require('autoprefixer')({browsers: ['last 2 version']})
        ]
      },
      server: {
        options: {
          map: true
        },
        files: [{
          expand: true,
          cwd: '.tmp/styles/',
          src: '{,*/}*.css',
          dest: '.tmp/styles/'
        }]
      },
      dist: {
        files: [{
          expand: true,
          cwd: '.tmp/styles/',
          src: '{,*/}*.css',
          dest: '.tmp/styles/'
        }]
      }
    },

    // Automatically inject Bower components into the app
    wiredep: {
      app: {
        src: ['<%= talkmore.app %>/index.html'],
        ignorePath:  /\.\.\//,
        exclude: [ 'jquery' ],

      },
      test: {
        devDependencies: true,
        src: '<%= karma.unit.configFile %>',
        ignorePath:  /\.\.\//,
        fileTypes:{
          coffee: {
            block: /(([\s\t]*)#\s*?bower:\s*?(\S*))(\n|\r|.)*?(#\s*endbower)/gi,
              detect: {
                js: /'(.*\.js)'/gi,
                coffee: /'(.*\.coffee)'/gi
              },
            replace: {
              js: '\'{{filePath}}\'',
              coffee: '\'{{filePath}}\''
            }
          }
        }
      },
      sass: {
        src: ['<%= talkmore.app %>/styles/{,*/}*.{scss,sass}'],
        ignorePath: /(\.\.\/){1,2}bower_components\//,
        exclude: [ 'bootstrap-sass-official/assets/stylesheets/_bootstrap.scss' ]
      }
    },

    // Compiles CoffeeScript to JavaScript
    coffee: {
      options: {
        sourceMap: true,
        sourceRoot: ''
      },
      dist: {
        files: [{
          expand: true,
          cwd: '<%= talkmore.app %>/scripts',
          src: '{,*/}*.coffee',
          dest: '.tmp/scripts',
          ext: '.js'
        }]
      },
      test: {
        files: [{
          expand: true,
          cwd: 'test/spec',
          src: '{,*/}*.coffee',
          dest: '.tmp/spec',
          ext: '.js'
        }]
      }
    },

    // Compiles Sass to CSS and generates necessary files if requested
    sass: {
      options: {
          includePaths: [
              'bower_components'
          ]
      },
      dist: {
          files: [{
              expand: true,
              cwd: '<%= talkmore.app %>/styles',
              src: ['*.scss'],
              dest: '.tmp/styles',
              ext: '.css'
          }]
      },
      server: {
          files: [{
              expand: true,
              cwd: '<%= talkmore.app %>/styles',
              src: ['*.scss'],
              dest: '.tmp/styles',
              ext: '.css'
          }]
      }
    },

    // Renames files for browser caching purposes
    filerev: {
      dist: {
        src: [
          '<%= talkmore.dist %>/scripts/{,*/}*.js',
          '<%= talkmore.dist %>/styles/{,*/}*.css',
          '<%= talkmore.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}',
          '<%= talkmore.dist %>/styles/fonts/*'
        ]
      }
    },

    // Reads HTML for usemin blocks to enable smart builds that automatically
    // concat, minify and revision files. Creates configurations in memory so
    // additional tasks can operate on them
    useminPrepare: {
      html: '<%= talkmore.app %>/index.html',
      options: {
        dest: '<%= talkmore.dist %>',
        flow: {
          html: {
            steps: {
              js: ['concat', 'uglifyjs'],
              css: ['cssmin']
            },
            post: {}
          }
        }
      }
    },

    // Performs rewrites based on filerev and the useminPrepare configuration
    usemin: {
      html: ['<%= talkmore.dist %>/{,*/}*.html'],
      css: ['<%= talkmore.dist %>/styles/{,*/}*.css'],
      js: ['<%= talkmore.dist %>/scripts/{,*/}*.js'],
      options: {
        assetsDirs: [
          '<%= talkmore.dist %>',
          '<%= talkmore.dist %>/images',
          '<%= talkmore.dist %>/styles'
        ],
        patterns: {
          js: [[/(images\/[^''""]*\.(png|jpg|jpeg|gif|webp|svg))/g, 'Replacing references to images']]
        }
      }
    },

    imagemin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= talkmore.app %>/images',
          src: '{,*/}*.{png,jpg,jpeg,gif}',
          dest: '<%= talkmore.dist %>/images'
        }]
      }
    },

    svgmin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= talkmore.app %>/images',
          src: '{,*/}*.svg',
          dest: '<%= talkmore.dist %>/images'
        }]
      }
    },

    htmlmin: {
      dist: {
        options: {
          collapseWhitespace: true,
          conservativeCollapse: true,
          collapseBooleanAttributes: true,
          removeCommentsFromCDATA: true
        },
        files: [{
          expand: true,
          cwd: '<%= talkmore.dist %>',
          src: ['*.html'],
          dest: '<%= talkmore.dist %>'
        }]
      }
    },

    ngtemplates: {
      dist: {
        options: {
          module: 'talkmoreApp',
          htmlmin: '<%= htmlmin.dist.options %>',
          usemin: 'scripts/scripts.js'
        },
        cwd: '<%= talkmore.app %>',
        src: 'views/{,*/}*.html',
        dest: '.tmp/templateCache.js'
      }
    },


    // ng-annotate tries to make the code safe for minification automatically
    // by using the Angular long form for dependency injection.
    ngAnnotate: {
      dist: {
        files: [{
          expand: true,
          cwd: '.tmp/concat/scripts',
          src: '*.js',
          dest: '.tmp/concat/scripts'
        }]
      }
    },

    // Replace Google CDN references
    cdnify: {
      dist: {
        html: ['<%= talkmore.dist %>/*.html']
      }
    },

    // Copies remaining files to places other tasks can use
    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= talkmore.app %>',
          dest: '<%= talkmore.dist %>',
          src: [
            '*.{ico,png,txt}',
            '*.html',
            'images/{,*/}*.{webp}',
            'styles/fonts/{,*/}*.*'
          ]
        }, {
          expand: true,
          cwd: '.tmp/images',
          dest: '<%= talkmore.dist %>/images',
          src: ['generated/*']
        }, {
          expand: true,
          cwd: '.',
          src: 'bower_components/bootstrap-sass-official/assets/fonts/bootstrap/*',
          dest: '<%= talkmore.dist %>'
        }]
      },
      styles: {
        expand: true,
        cwd: '<%= talkmore.app %>/styles',
        dest: '.tmp/styles/',
        src: '{,*/}*.css'
      },
      fonts: {
        expand: true,
        flatten: true,
        cwd: '.',
        src: ['bower_components/bootstrap-sass-official/assets/fonts/bootstrap/*', 'bower_components/font-awesome/fonts/*'],
        dest: '.tmp/fonts/',
        filter: 'isFile'
      }
    },

    // Run some tasks in parallel to speed up the build process
    concurrent: {
      server: [
        'sass:server',
        'coffee:dist',
        'copy:styles',
        'copy:fonts'
      ],
      test: [
        'coffee',
        'copy:styles',
        'copy:fonts'
      ],
      dist: [
        'coffee',
        'sass:dist',
        'copy:styles',
        'copy:fonts',
        'imagemin',
        'svgmin'
      ]
    },

    // Test settings
    karma: {
      unit: {
        configFile: 'test/karma.conf.coffee',
        singleRun: true
      }
    }
  });


  grunt.registerTask('serve', 'Compile then start a BrowserSync web server', function (target) {
    if (target === 'dist') {
      return grunt.task.run(['build', 'browserSync:dist']);
    }

    grunt.task.run([
      'clean:server',
      'wiredep',
      'concurrent:server',
      'postcss:server',
      'browserSync:livereload',
      'watch'
    ]);
  });


  grunt.registerTask('test', [
    'clean:server',
    'wiredep',
    'concurrent:test',
    'postcss',
    'browserSync:test',
    'karma'
  ]);

  grunt.registerTask('build', [
    'clean:dist',
    'wiredep',
    'useminPrepare',
    'concurrent:dist',
    'postcss',
    'ngtemplates',
    'concat',
    'ngAnnotate',
    'copy:dist',
    'cdnify',
    'cssmin',
    'uglify',
    'filerev',
    'usemin',
    'htmlmin'
  ]);

  grunt.registerTask('default', [
    'newer:jshint',
    'test',
    'build'
  ]);
};
