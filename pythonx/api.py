"""
API for the VIM template plugin
"""
import subprocess

import vim

import buffers
import utils


class BufferNotFoundException(Exception):
    """
    Buffer not found exception class
    """
    pass


class API(object):
    """
    VIM Plugin API
    """
    def __init__(self):
        self._server_popen = None
        self._buffers_list = buffers.BufferList()

    def run_echo_server(self):
        """
        Run an echo server
        """
        server_port = utils.get_unused_localhost_port()
        args = ['./go/bin/echo_server',
                '--port={0}'.format(server_port)]

        self._server_popen = subprocess.Popen(args,
                                              stdout=subprocess.PIPE,
                                              stderr=subprocess.PIPE)

    def create_buffer(self, name, options):
        """
        API call to create a vim buffer
        """
        return self._buffers_list.create_buffer(name, options).buffer_number

    def prepend_buffer(self, name, line, text):
        """
        API call to write to the buffer specified
        """
        buf = self._buffers_list.get_buffer(name)
        if buf is None:
            raise BufferNotFoundException(name)
        buf.prepend(line, text)

    def append_buffer(self, name, line, text):
        """
        API call to write to the buffer specified
        """
        buf = self._buffers_list.get_buffer(name)
        if buf is None:
            raise BufferNotFoundException(name)
        buf.append(line, text)

    def replace_buffer(self, name, line_from, line_to, text):
        """
        API call to write to the buffer specified
        """
        buf = self._buffers_list.get_buffer(name)
        if buf is None:
            raise BufferNotFoundException(name)
        buf.replace(line_from, line_to, text)

    def clear_buffer(self, name):
        """
        Empty the buffer specified.
        """
        buf = self._buffers_list.get_buffer(name)
        if buf is None:
            raise BufferNotFoundException(name)
        buf.replace(1, '$', None)

    @staticmethod
    def parse_output(text, param):
        """
        Parse text for the word 'param' and output the result
        """
        if param not in text:
            return

        for suffix in vim.eval('g:strotter_template_ignore_files_with_suffix'):
            if text.split('.')[-1] == suffix:
                return

        output_buffer = None
        for buf in vim.buffers:
            # buf.name gives the full path annoyingly
            if buf.name.split('/')[-1] == 'File_Search_Buffer':
                output_buffer = buf
        if not output_buffer:
            return
        output_buffer.options['modifiable'] = True
        output_buffer.append(text)
        output_buffer.options['modifiable'] = False
