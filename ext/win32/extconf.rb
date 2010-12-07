require 'mkmf'

dir_config('win32-daemon')
have_func('RegisterServiceCtrlHandlerEx')
create_makefile('win32/daemon')
