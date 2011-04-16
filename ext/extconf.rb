require 'mkmf'

dir_config('win32-daemon')
dir_config('seh')

have_func('RegisterServiceCtrlHandlerEx')
have_header('seh.h')

create_makefile('win32/daemon', 'win32')
