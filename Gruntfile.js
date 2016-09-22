module.exports = function (grunt) {

    //Initializing the configuration object
    grunt.initConfig({


        clean: ['dist'],


        copy: {
            shapes:{
                expand: true,
                cwd: 'src/',
                src: ['*'],
                dest: 'dist'
            }

        }
    });

    // Plugin loading
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-clean');

    // Task definition
    grunt.registerTask('default', [
        'clean',
        'copy'
    ]);
};

