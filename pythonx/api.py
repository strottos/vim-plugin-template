"""
API for the VIM template plugin
"""
import vim


class API:
    """
    VIM Plugin API
    """
    @staticmethod
    def parse_output(text, param):
        """
        Parse text for the word 'param' and output the result
        """
        if param not in text:
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
