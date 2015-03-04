# OGC Web Map Service Client Executable Test Suite

## Overview

The OGC Web Map Service Client Test-Suite provides the Executable Test Script (ETS) to test implementations against the following specification(s):

* Web Map Server Implementation Specification, version 1.3.0 [OGC 06-042 (or ISO [19128:2005](http://www.iso.org/iso/iso_catalogue/catalogue_tc/catalogue_detail.htm?csnumber=32546))]([PDF version](http://portal.opengeospatial.org/files/?artifact_id=14416))


## What is tested

In order to test a client, this test suite creates an intercepting proxy for interacting with the WMS 1.3.0 reference implementation available at:

   <http://cite.lat-lon.de/deegree-webservices-3.3.6-2/services/wms?service=WMS&amp;version=1.3.0&amp;request=GetCapabilities 

The test test suite will record the request performed by the client to check if the client has performed correctly all the required operations, as specified in the Annex A of the [OGC 06-042](http://portal.opengeospatial.org/files/?artifact_id=14416). 

The Annex A list two conformance classes that only apply for clients:

* A.1.1 Basic WMS Client:
      * A.1.1.1 Basic service elements
      * A.1.1.2 GetCapabilities request
      * A.1.1.3 GetMap request

* A.2.1 Client for queryable WMS – GetFeatureInfo request


The client is required to perform the following minimum operations, based on the Annex A:


* Get Capabilities: Perform **at least** one valid request
* GetMap: Perform **all** get map request for all the layers advertise in the server GetCapabilities document.
* GetFeatureInfo: Perform **at least** one GetfeatureInfo valid request

If at any point in time while the client is interacting with the server, the client performs a non-valid request, the test will fail.

## Capabilities not tested
The client capabilities listed below are **not** currently tested. The
relevant specification references are enclosed in square brackets.

  * GetMap: Valid BBOX extent [cl. 6.7.4, 7.3.3.6]
  * GetMap: BBOX values consistent with CRS [cl. 7.3.3.6]
  * GetCapabilities request with Format parameter [cl. 7.2.3.1]
  * Version negotiation: GetCapabilities with Version parameter 1.3.0 OR no Version parameter [cl. 6.2.4, 7.2.3.2]
  * Follow redirect response (status code 3xx) [cl. 6.4]
  * GetCapabilities request with UpdateSequence parameter [cl. 7.2.3.5, Table 4]
  * GetMap request for transparent picture [7.3.3.9]
  * GetMap request with BGCOLOR param [cl. 7.3.3.10]
  * GetMap: Commensurate aspect ratio [cl. 7.3.3.8]
  * GetFeatureInfo request with FEATURE_COUNT param [cl. 7.4.3.6]
  * Automatic CRS: GetMap request with "AUTO2" CRS reference [cl. 6.7.3.4]
  * Submit POST request [cl. 6.3.4]
  * GetMap request with TIME param [cl. 7.3.3.12]
  * GetMap request with ELEVATION param [cl. 7.3.3.13]

## Test identification
The executable test cases that comprise this test suite are briefly summarized
below.
### Test Suite name: main:ets-wms-client

#### Basic WMS Client Test Suite

* Validates WMS client requests.
* Total number of tests in this suite: 29
* The root test is: main:wms-client

###  Test Name: main:wms-client

**Test Assertion:** The WMS client is valid. 

  * Invoke test: [gc:check-GetCapabilities-request](#Test_Name:_gc:check-GetCapabilities-request)
  * Invoke test: [gm:check-GetMap-request](#Test_Name:_gm:check-GetMap-request)
  * Invoke test: [gfi:check-GetFeatureInfo-request](#Test_Name:_gfi:check-GetFeatureInfo-request)

###  Test Name: gc:check-GetCapabilities-request
Total number of tests in this group: 3

**Test Assertion:** The client GetCapabilities request is valid. 

  * Invoke test: [basic:mandatory-params](#Test_Name:_basic:mandatory-params)
  * Invoke test: [gc:service](#Test_Name:_gc:service)
  * Invoke test: [basic:request](#Test_Name:_basic:request)

###  Test Name: basic:mandatory-params

**Test Assertion:** Each of the mandatory parameters is present (SERVICE and REQUEST). 

###  Test Name: gc:service

**Test Assertion:** The value of the SERVICE parameter is "WMS". 

###  Test Name: basic:request

**Test Assertion:** The value of the REQUEST parameter is GetCapabilities, GetMap or GetFeatureInfo. 

###  Test Name: gm:check-GetMap-request
Total number of tests in this group: 16

**Test Assertion:** The client GetMap request is valid. 

  * Invoke test: [basic:mandatory-params](#Test_Name:_basic:mandatory-params)
  * Invoke test: [basic:version](#Test_Name:_basic:version)
  * Invoke test: [basic:request](#Test_Name:_basic:request)
  * Invoke test: [gm:core-map-request](#Test_Name:_gm:core-map-request)
  * Invoke test: [gm:exceptions](#Test_Name:_gm:exceptions)

###  Test Name: basic:version
**Test Assertion:** The value of the VERSION parameter is "1.3.0". 

###  Test Name: gm:core-map-request
**Test Assertion:** The core parameters for a GetMap request are valid. 

  * Invoke test: [gm:layers-count](#Test_Name:_gm:layers-count)
  * Invoke test: [gm:layers-names](#Test_Name:_gm:layers-names)
  * Invoke test: [gm:styles-count](#Test_Name:_gm:styles-count)
  * Invoke test: [gm:styles-names](#Test_Name:_gm:styles-names)
  * Invoke test: [gm:crs](#Test_Name:_gm:crs)
  * Invoke test: [gm:bbox-format](#Test_Name:_gm:bbox-format)
  * Invoke test: [gm:bbox-non-subsettable-layers](#Test_Name:_gm:bbox-non-subsettable-layers)
  * Invoke test: [gm:format](#Test_Name:_gm:format)
  * Invoke test: [gm:width-height](#Test_Name:_gm:width-height)
  * Invoke test: [gm:transparent](#Test_Name:_gm:transparent)

###  Test Name: gm:layers-count
**Test Assertion:** The number of the LAYERS requested does not exceed the layer limit. 


###  Test Name: gm:layers-names

**Test Assertion:** Each of the values in the LAYERS parameter is a valid layer name. 

###  Test Name: gm:styles-count

**Test Assertion:** The number of styles requested matches the number of layers requested. 

###  Test Name: gm:styles-names

**Test Assertion:** Each of the values in the STYLES parameter is a valid style for its matching layer. 

###  Test Name: gm:crs

**Test Assertion:** The CRS is valid style for each requested layer. 

###  Test Name: gm:bbox-format
**Test Assertion:** The BBOX is a list of comma-separated real numbers in the form "minx,miny,maxx,maxy". 

###  Test Name: gm:bbox-non-subsettable-layers
**Test Assertion:** For layers that are not subsettable, the BBOX parameter must match the bounding box declared for the layer. 

###  Test Name: gm:format

**Test Assertion:** The value of the FORMAT parameter is one of the formats listed in the service metadata. 

###  Test Name: gm:width-height
**Test Assertion:** 
  
  * The value of the WIDTH parameter is a positive integer value that does not exceed the declared MaxWidth.
  * The value of the HEIGHT parameter is a positive integer value that does not exceed the declared MaxHeight.  

###  Test Name: gm:transparent

**Test Assertion:**T he value of the TRANSPARENT parameter is 'TRUE' or 'FALSE'. 


###  Test Name: gm:exceptions

**Test Assertion:** The value of the EXCEPTIONS parameter is one of the formats listed in the service metadata. 


###  Test Name: gfi:check-GetFeatureInfo-request

Total number of tests in this group: 10

**Test Assertion:** The client GetFeatureInfo request is valid. 

  * Invoke test: [basic:mandatory-params](#Test_Name:_basic:mandatory-params)
  * Invoke test: [basic:version](#Test_Name:_basic:version)
  * Invoke test: [basic:request](#Test_Name:_basic:request)
  * Invoke test: [gm:core-map-request](#Test_Name:_gm:core-map-request)
  * Invoke test: [gfi:query_layers-count](#Test_Name:_gfi:query_layers-count)
  * Invoke test: [gfi:query_layers-values](#Test_Name:_gfi:query_layers-values)
  * Invoke test: [gfi:query_layers-queryable](#Test_Name:_gfi:query_layers-queryable)
  * Invoke test: [gfi:info_format](#Test_Name:_gfi:info_format)
  * Invoke test: [gfi:i](#Test_Name:_gfi:i)
  * Invoke test: [gfi:j](#Test_Name:_gfi:j)

###  Test Name: gfi:query_layers-count

**Test Assertion:** The QUERY_LAYERS parameter contains at least one layer name. 

###  Test Name: gfi:query_layers-value

**Test Assertion:** Each of the values in the QUERY_LAYERS parameter is a layer from the original GetMap request. 

###  Test Name: gfi:query_layers-queryable
**Test Assertion:** Each of the values in the QUERY_LAYERS parameter must be a queryable layer. That is, the layer attribute "queryable" must evaluate to true (xsd:boolean); it may be inherited. 

**Test description** See ISO 19128:2005, cl. 7.2.4.7.2: Queryable layers. See ISO 19128:2005, cl. 7.4.1: General.

###  Test Name: gfi:info_format
**Test Assertion:** The value of the INFO_FORMAT parameter is one of the formats listed in the service metadata. 

###  Test Name: gfi:i
**Test Assertion:** The value of the I parameter is an integer between 0 and the maximum value of the i axis (WIDTH-1). 

###  Test Name: gfi:j
**Test Assertion:** The value of the J parameter is an integer between 0 and the maximum value of the i axis (HEIGHT-1). 


##  License

[Apache License, Version 2.0](http://opensource.org/licenses/Apache-2.0 "Apache License")

## Bugs

Issue tracker is available at [github](https://github.com/opengeospatial/ets-wms-client13/issues)

## Mailing Lists

The [cite-forum](http://cite.opengeospatial.org/forum) is where software developers discuss issues and solutions related to OGC tests. 


## Release notes
Release notes are available [here](relnotes.html).
