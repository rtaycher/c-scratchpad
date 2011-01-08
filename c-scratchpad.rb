#!/usr/bin/ruby
require 'Qt4'


def compile(program,compiler_options)
  File.open('temp.c', 'w') {|f| f.write(program) }
  `gcc #{compiler_options} temp.c`
end


Qt::Application.new(ARGV) do
    Qt::Widget.new do
 
        self.window_title = 'c scratchpad'
        resize(900, 500)
 
	hello_world_with_libs = <<-eos
	#include <assert.h>
	#include <errno.h>
	#include <limits.h>
	#include <math.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <time.h>
	
	int main(int argc, char *argv[]){

	printf("hello world\\n");
	return 0;
	}

	eos
	
	program_source_text = Qt::PlainTextEdit.new(self)
	program_source_text.set_plain_text(hello_world_with_libs)
	
	

	compiler_options_text = Qt::PlainTextEdit.new(self)
	compiler_options_text.set_plain_text("-Wall -Werror -pedantic -ansi")
	program_run_args_text = Qt::PlainTextEdit.new(self)
	program_output_text =   Qt::PlainTextEdit.new(self)
	
        button = Qt::PushButton.new('compile and run') do
            connect(SIGNAL :clicked) do 
	    compile(program_source_text.toPlainText(),compiler_options_text.toPlainText())
	    program_output_text.setPlainText(`./a.out #{program_run_args_text.toPlainText()}` )
	    #`rm temp.c a.out`
	  end
        end
 
	
	
 
        self.layout = Qt::VBoxLayout.new do
	    add_widget(Qt::Label.new('source'), 0, Qt::AlignCenter)
	    add_widget(program_source_text, 0, Qt::AlignCenter)
	    add_widget(Qt::Label.new('gcc options'), 0, Qt::AlignCenter)
            add_widget(compiler_options_text, 0, Qt::AlignCenter)
	    add_widget(Qt::Label.new('Run Arguments'), 0, Qt::AlignCenter)
            add_widget(program_run_args_text, 0, Qt::AlignCenter)
	    add_widget(Qt::Label.new('output'), 0, Qt::AlignCenter)
            add_widget(program_output_text, 0, Qt::AlignCenter)
            add_widget(button, 0, Qt::AlignCenter)
        end
 
        show
    end
 
    exec
end

