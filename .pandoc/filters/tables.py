#!/usr/bin/env python

import pandocfilters as pf
import logging

def latex(s):
    return pf.RawBlock('latex', s)

def inlatex(s):
    return pf.RawInline('latex', s)

def tbl_caption(s):
    return pf.Para([inlatex(r'\tablecaption{')] + s + [inlatex('}')])

def tbl_alignment(s):
    aligns = {
        "AlignDefault": 'l',
        "AlignLeft": 'l',
        "AlignCenter": 'c',
        "AlignRight": 'r',
    }
    return ''.join([aligns[e['t']] for e in s])

def tbl_headers(s):
    header = s[0][0]['c'][0]['c']
    result = [inlatex(r'\toprule' '\n')]
    result.append(inlatex(r'\multicolumn{1}{c}{%s}' % header))
    for i in range(1, len(s)):
        if len(s[i]) > 0:
            header = s[i][0]['c'][0]['c']
            result.append(inlatex(r' & \multicolumn{1}{c}{%s}' % header))
    result.append(inlatex(r'\\' '\n'))
    result.append(inlatex(r'\midrule' '\n'))
    return pf.Para(result)

def tbl_contents(s):
    result = []
    for row in s:
        para = []
        for col in row:
            if len(col) > 0:
                para.extend(col[0]['c'])
                para.append(inlatex(' & '))
            else:
                para.append(inlatex(' & '))
        result.extend(para)
        result[-1] = inlatex(r' \\' '\n')
    return pf.Para(result)

def do_filter(k, v, f, m):
    if k == "Table":
        return [latex(r'\begin{center}'),
                latex(r'\tablehead{%'),
                tbl_headers(v[3]),
                latex(r'}'),
                latex(r'\tabletail{\bottomrule}'),
                tbl_caption(v[0]),
                latex(r'\begin{supertabular}{@{}%s@{}}' % tbl_alignment(v[1])),
                tbl_contents(v[4]),
                latex(r'\end{supertabular}'),
                latex(r'\end{center}')]

if __name__ == "__main__":
    pf.toJSONFilter(do_filter)
