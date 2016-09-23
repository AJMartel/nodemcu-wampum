var shell = require('shelljs');

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
    grunt.registerTask('upload', 'Generates JSON file with all shape files', function() {
        // List all SHAPE files in the templates directory.
        //
        var list = [];
        var shapes = grunt.file.expand({filter: "isFile", cwd: "./dist/"},["**/*"]);
        shapes.forEach(function(shape){
       //     console.log(shape);
            shell.exec('nodemcu-tool -b 115200 -p /dev/tty.wchusbserial640 upload ./dist/'+shape);
        });

    });

    // Task definition
    grunt.registerTask('default', [
        'clean',
        'copy',
        'upload'
    ]);
};

