""" Simple index page linking other markdown files generator
Input Markdown file should be formatted like:

    ---
    layout: post
    title: Code         <-- the link name <link_title>
    comments: false
    indexing: true      <-- it's mandatory (true: this markdown will show in index list.
    ---

    # Code Collection   <-- h1 title mandatory. (take this link)

    ---

    blah blah blah

Output file Format: 
    ---
    layout: post
    title: <title>
    comments: false
    ---

    # <title>'s index

    1. [<input_title1>](./path/to/folder/target1.md)
    2. [<input_title2>](./path/to/folder/target2.md)

    ---

Usage:

    auto_list.py <target_folder> <output_index_filename>
"""

import sys
import os


def search_files(directory):
    pass


class MarkdownFile(object):
    DEFAULT_LINKABLE = False

    def __init__(self, path):
        pass



if __name__ == "__main__":
    pass

