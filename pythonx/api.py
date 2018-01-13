import vim


def testing():
    """
    Test function, empty so far
    """
    # vim.command('timer_start(2000, {-> execute(\'echom "Testing Python"\', '')}, {\'repeat\': 3})')
    vim.command('rightbelow 10 new')
    vim.command('silent edit \[STR_Test_Buffer_1\]')
    vim.command('setlocal noswapfile')
    vim.command('setlocal filetype=STRTestBuf')
    vim.command('setlocal nomodifiable')
    vim.command('setlocal nobuflisted')
