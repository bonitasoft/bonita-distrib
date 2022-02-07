'use strict';

module.exports = function (grunt) {

    // Load grunt tasks automatically
    require('load-grunt-tasks')(grunt);

    // Time how long tasks take. Can help when optimizing build times
    require('time-grunt')(grunt);

    // Define the configuration for all the tasks
    grunt.initConfig({

        /* jshint camelcase: false */
        nggettext_extract: {
            pot: {
                files: {
                    'resources.pot': ['../**/src/**/*.js', '../**/src/**/*.html']
                }
            }
        }
    });

    grunt.registerTask('pot', [
        'nggettext_extract'
    ]);

    grunt.registerTask('default', [
        'pot'
    ]);
};