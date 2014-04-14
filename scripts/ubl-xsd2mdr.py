#!/usr/bin/env python3
# Convert a XSD files of the UBL Common Library 2.1 to RDF satisfying
# the MDR vocabulary.
#
# Copyright 2014 European Union
# Author: Vianney le Clément de Saint-Marcq (PwC EU Services)
#
# Licensed under the EUPL, Version 1.1 or - as soon they
# will be approved by the European Commission - subsequent
# versions of the EUPL (the "Licence");
# You may not use this work except in compliance with the
# Licence.
# You may obtain a copy of the Licence at:
# http://ec.europa.eu/idabc/eupl
#
# Unless required by applicable law or agreed to in
# writing, software distributed under the Licence is
# distributed on an "AS IS" basis,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied.
# See the Licence for the specific language governing
# permissions and limitations under the Licence.

import argparse
import sys
import re
import os.path

import xml.etree.ElementTree

import rdflib

from rdflib import URIRef, Literal
from rdflib.namespace import RDF, XSD, RDFS, SKOS, DCTERMS
MDR = rdflib.Namespace("http://mdr.semic.eu/def#")
ADMS = rdflib.Namespace("http://www.w3.org/ns/adms#")
CAC = rdflib.Namespace("urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2:")
CBC = rdflib.Namespace("urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2:")
UDT = rdflib.Namespace("urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2:")
CCTS = rdflib.Namespace("urn:un:unece:uncefact:documentation:2:")

# Extend rdflib Namespace to generate XML tags
rdflib.namespace.Namespace.xml = lambda self, term: "{" + str(self).strip("#:") + "}" + term


XMLSchema = URIRef("http://purl.org/adms/representationtechnique/XMLSchema")
RIGHTS = URIRef("https://www.oasis-open.org/policies-guidelines/ipr")
RIGHTS_HOLDER = URIRef("https://www.oasis-open.org/org")


class UBLLibrary:

    '''The UBLLibrary class handles a directory containing the XSD schemas
    of UBL 2.1.'''

    def __init__(self, directory, namespace):
        '''Initialize a UBLLibrary.

        Arguments:
        directory -- the path to the XSD files
        namespace -- the namespace of the resulting graph
        '''
        self.directory = directory
        self.ns = rdflib.Namespace(namespace)

    # Utility methods

    def openxsd(self, name):
        '''Open an XSD and return the root element.'''
        tree = xml.etree.ElementTree.parse(os.path.join(self.directory, name))
        return tree.getroot()

    def cctsdoc(self, e, name):
        '''Return the CCTS documentation named name from the element e.'''
        doc = e.find(XSD.xml("annotation") + "/" +
                     XSD.xml("documentation") + "//" +
                     CCTS.xml(name))
        if doc is None:
            return None
        return doc.text

    def attriburi(self, value):
        '''Return the URI of the attribute value.'''
        if value.startswith('udt:'):
            return UDT.term(value[4:])
        elif value.startswith('cac:'):
            return CAC.term(value[4:])
        elif value.startswith('cbc:'):
            return CBC.term(value[4:])
        else:
            return URIRef(value)

    def uri(self, concept, name):
        '''Return the URI of name.'''
        return self.ns.term(concept + "/" + name)

    def text(self, text):
        '''Return an RDF Literal with the text.'''
        return Literal(text, lang="en")

    def integer(self, num):
        '''Return an RDF Literal with the integer number.'''
        return Literal(num, datatype=XSD.integer)

    def nonneg(self, num):
        '''Return an RDF Literal with the non-negative integer number.'''
        assert num >= 0
        return Literal(num, datatype=XSD.nonNegativeInteger)

    # Main methods

    def convert(self):
        '''Return the RDF Graph corresponding to the spreadsheet.'''
        g = rdflib.Graph()
        g.bind("skos", str(SKOS))
        g.bind("dcterms", str(DCTERMS))
        g.bind("mdr", str(MDR))
        g.bind("adms", str(ADMS))
        g.bind("cac", str(CAC))
        g.bind("cbc", str(CBC))
        g.bind("udt", str(UDT))
        g.add((URIRef(self.ns), RDF.type, MDR.Context))
        g.add((URIRef(self.ns), RDFS.label, self.text("UBL")))
        g.add((URIRef(self.ns), RDFS.comment,
               self.text("The UBL Common Library")))
        self.convert_datatypes(g)
        self.convert_basic(g)
        self.convert_aggregate(g)
        return g

    def convert_datatypes(self, g):
        '''Convert data types.'''
        root = self.openxsd("UBL-UnqualifiedDataTypes-2.1.xsd")
        for e in root.findall(XSD.xml('complexType')):
            uri = UDT.term(e.attrib['name'])
            g.add((uri, RDF.type, MDR.DataType))
            g.add((uri, MDR.context, URIRef(self.ns)))
            g.add((uri, DCTERMS.rights, RIGHTS))
            g.add((uri, DCTERMS.rightsHolder, RIGHTS_HOLDER))
            g.add((uri, SKOS.definition,
                   self.text(self.cctsdoc(e, "Definition"))))
            g.add((uri, MDR.representationTerm,
                   Literal(self.cctsdoc(e, "RepresentationTermName"))))
            g.add((uri, ADMS.representationTechnique, XMLSchema))

    def convert_basic(self, g):
        '''Convert basic components.'''
        root = self.openxsd("UBL-CommonBasicComponents-2.1.xsd")
        for e in root.findall(XSD.xml('element')):
            t = root.find(XSD.xml("complexType") +
                          "[@name='" + e.attrib['type'] + "']")
            datatype = t.find(XSD.xml("simpleContent") + "/" +
                              XSD.xml("extension")).attrib['base']
            uri = CBC.term(e.attrib['name'])
            g.add((uri, RDF.type, MDR.Property))
            g.add((uri, MDR.context, URIRef(self.ns)))
            g.add((uri, DCTERMS.rights, RIGHTS))
            g.add((uri, DCTERMS.rightsHolder, RIGHTS_HOLDER))
            g.add((uri, MDR.representation, self.attriburi(datatype)))
            # Property terms are defined in convert_aggregate

    def convert_aggregate(self, g):
        '''Convert aggregate components.'''
        root = self.openxsd("UBL-CommonAggregateComponents-2.1.xsd")
        for cls in root.findall(XSD.xml('complexType')):
            clsuri = CAC.term(cls.attrib['name'])
            clsubl = re.sub(r"Type$", r"", cls.attrib['name'])
            clsname = self.cctsdoc(cls, "ObjectClass")
            # Object class
            g.add((clsuri, RDF.type, MDR.ObjectClass))
            g.add((clsuri, MDR.context, URIRef(self.ns)))
            g.add((clsuri, DCTERMS.rights, RIGHTS))
            g.add((clsuri, DCTERMS.rightsHolder, RIGHTS_HOLDER))
            g.add((clsuri, RDFS.label, self.text(clsname)))
            g.add((clsuri, MDR.objectClassName, Literal(clsname)))
            g.add((clsuri, SKOS.definition,
                   self.text(self.cctsdoc(cls, "Definition"))))
            for i, e in enumerate(cls.findall(XSD.xml('sequence') + "/" +
                                              XSD.xml('element'))):
                propuri = self.attriburi(e.attrib['ref'])
                propubl = re.sub(r"^[^:]*:", r"", e.attrib['ref'])
                uri = self.uri("element", clsubl + propubl)
                # Data Element
                g.add((uri, RDF.type, MDR.DataElement))
                g.add((uri, MDR.context, URIRef(self.ns)))
                g.add((uri, DCTERMS.rights, RIGHTS))
                g.add((uri, DCTERMS.rightsHolder, RIGHTS_HOLDER))
                g.add((uri, MDR.objectClass, clsuri))
                g.add((uri, MDR.property, propuri))
                g.add((uri, SKOS.definition,
                       self.text(self.cctsdoc(e, "Definition"))))
                g.add((uri, MDR.order, self.integer(i + 1)))
                example = self.cctsdoc(e, "Examples")
                if example:
                    g.add((uri, MDR.example, Literal(example)))
                cardmin = int(e.attrib['minOccurs'])
                if cardmin != 0:
                    g.add((uri, MDR.minCardinality, self.nonneg(cardmin)))
                cardmax = e.attrib['maxOccurs']
                if cardmax != "unbounded":
                    g.add((uri, MDR.maxCardinality, self.nonneg(int(cardmax))))
                # Property
                g.add((propuri, RDF.type, MDR.Property))
                g.add((propuri, MDR.context, URIRef(self.ns)))
                g.add((propuri, DCTERMS.rights, RIGHTS))
                g.add((propuri, DCTERMS.rightsHolder, RIGHTS_HOLDER))
                g.add((propuri, MDR.propertyTerm,
                       Literal(self.cctsdoc(e, "PropertyTerm"))))
                propqualifier = self.cctsdoc(e, "PropertyTermQualifier")
                if propqualifier:
                    g.add((propuri, MDR.propertyTermQualifier,
                           Literal(propqualifier)))
                proptype = self.cctsdoc(e, "ComponentType")
                if proptype == "BBIE":
                    # The representation term is set by convert_basic
                    dtqualifier = self.cctsdoc(e, "DataTypeQualifier")
                    if dtqualifier:
                        g.add((propuri, MDR.representationQualifier,
                               Literal(dtqualifier)))
                elif proptype == "ASBIE":
                    assoc = root.find(XSD.xml('element') +
                                      "[@name='" + propubl + "']")
                    assocuri = CAC.term(assoc.attrib['type'])
                    g.add((propuri, MDR.representation, assocuri))
                else:
                    assert False


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.description = "Convert UBL XSD to MDR RDF."
    ap.add_argument("-d", "--directory", default=".",
                    help="directory containing the common XSDs "+
                         "(default: %(default)s)")
    ap.add_argument("-N", "--namespace",
                    default="http://mdr.semic.eu/id/ubl/",
                    help="output namespace (default: %(default)s)")
    ap.add_argument("-f", "--format", default="turtle",
                    help="serialization format (default: %(default)s)")
    args = ap.parse_args()
    ubl = UBLLibrary(args.directory, args.namespace)
    g = ubl.convert()
    print(g.serialize(format=args.format).decode())
