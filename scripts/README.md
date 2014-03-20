e-Document engineering pilot scripts
=====================================

This directory contains scripts to import into and export from the Semantic
Metadata Registry.

All scripts can be called with the `-h` argument to print a usage notice.


Prerequisites
--------------

You will need a [Python][] 3.3 or later interpreter with the following
additional modules:

* [rdflib][] 4
* [isodate][]
* [xlrd][]

[Python]: http://python.org/
[rdflib]: https://pypi.python.org/pypi/rdflib
[isodate]: https://pypi.python.org/pypi/isodate
[xlrd]: https://pypi.python.org/pypi/xlrd


edoc-xls2mdr.py
----------------

This script takes as input an XLS or XLSX spreadsheet containing goals,
transactions, high level requirements, information requirements, and business
rules. It produces RDF data using the [MDR vocabulary][].

An [example spreadsheet for the mini-pilot][xls-template] is available for
download.

[MDR vocabulary]: http://mdr.tesproject.eu/def
[xls-template]: http://mdr.semic.eu/downloads/e-Document_Engineering_Methods_-_Template_Activity_Registration.xlsx
