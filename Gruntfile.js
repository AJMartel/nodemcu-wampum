var shell = require('shelljs');
var glob = require("glob")

module.exports = function (grunt) {

    //Initializing the configuration object
    grunt.initConfig({


        clean: ['dist'],


        copy: {
            shapes:{
                expand: true,
                cwd: 'src/',
                src: ['**/*'],
                dest: 'dist'
            }
        }


    });


    // Plugin loading
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-compress');

    grunt.registerTask('upload', 'Generates JSON file with all shape files', function() {
        // List all SHAPE files in the templates directory.
        //
        var files =glob("./dist/**/*",  {sync:true, nodir:true});
        files.forEach(function(file,index){
           var target = file.replace("./dist/","");
            shell.exec("nodemcu-uploader --timeout 1000 --baud 115200  --port  /dev/cu.wchusbserial1410  upload "+file+"   "+target+" ");
           // shell.exec('nodemcu-tool -b 115200 -p /dev/tty.wchusbserial640 upload ./dist/'+shape);

        });
    });

    // Task definition
    grunt.registerTask('default', [
        'clean',
        'copy'

    ]);
};

