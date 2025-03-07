## WMS Client 1.3.0 Test Suite - Release Notes

### 1.8 (2025-03-07)

Attention: Java 17 and Tomcat 10.1 are required.

  - [#77](https://github.com/opengeospatial/ets-wms-client13/issues/77) - Migrate test suite to TEAM Engine 6 (Java 17)

### 1.7 (2024-04-30)

  - [#68](https://github.com/opengeospatial/ets-wms-client13/issues/68) - The WMS Client test does not put "Perform GetMap request for all the layers" on passed when all child tests have been passed
  - [#70](https://github.com/opengeospatial/ets-wms-client13/pull/70) - Upgrade TEAM Engine dependencies and update URL to used remote service
  - [#76](https://github.com/opengeospatial/ets-wms-client13/pull/76) - Exclude old versions of xerces and junit

### 1.6.1 (2024-03-19)

  - [#74](https://github.com/opengeospatial/ets-wms-client13/issues/74) - Test suite does not work on Beta and Production as remote endpoints must be updated

### 1.6 (2022-05-31)

  - [#61](https://github.com/opengeospatial/ets-wms-client13/issues/61) - Update URL to deegree reference implementation
  - [#62](https://github.com/opengeospatial/ets-wms-client13/pull/62) - Bump gson from 2.2.2 to 2.8.9
  - [#56](https://github.com/opengeospatial/ets-wms-client13/pull/56) - Bump commons-io from 2.4 to 2.7

### 1.5 (2021-07-30)

  - [#57](https://github.com/opengeospatial/ets-wms-client13/issues/57) - Update deegree service to v3.4.16
  - [#53](https://github.com/opengeospatial/ets-wms-client13/issues/53) - Artifacts cannot be published to Central Maven Repository
  - [#55](https://github.com/opengeospatial/ets-wms-client13/pull/55) - Set Docker TEAM Engine version to 5.4.1

### 1.4 (2020-11-24)
  - [#51](https://github.com/opengeospatial/ets-wms-client13/pull/51) - Bump junit from 4.12 to 4.13.1
  - [#47](https://github.com/opengeospatial/ets-wms-client13/issues/47) - Multiple layers that the test expects are missing in the test WMS service
  - [#45](https://github.com/opengeospatial/ets-wms-client13/pull/45) - Updated the dependency commons-io and fixed PR by removing some changes.
  - [#43](https://github.com/opengeospatial/ets-wms-client13/issues/43) - Enable creation of Docker Image
  - [#37](https://github.com/opengeospatial/ets-wms-client13/issues/37) - Adding multiple layers in QGIS is not recognized
  - [#32](https://github.com/opengeospatial/ets-wms-client13/issues/32) - Layer cite:Terrain not provided

### 1.3 (2018-01-26)
  - [#27](https://github.com/opengeospatial/ets-wms-client13/issues/27) - Result view (tree) is missing
  - [#24](https://github.com/opengeospatial/ets-wms-client13/issues/24) - The WMS client test fails to capture all GetMap requests
  - [#28](https://github.com/opengeospatial/ets-wms-client13/issues/28) - FileNotFoundException in wms-client test

### 1.2 (2016-01-29)
  - [#20](https://github.com/opengeospatial/ets-wms-client13/issues/20) - Modify REST endpoints for default web config
  - [#19](https://github.com/opengeospatial/ets-wms-client13/issues/19) - Update reference implementation links
  - [#18](https://github.com/opengeospatial/ets-wms-client13/issues/18) - Move JAX-RS resources from `teamenegine-spi` module

### 1.1 (2015-07-30)
- Update pom.xml to build with Maven 2

### 1.0 (2015-06-18)
  * test was approved by OGC to be moved to production
  * [13](https://github.com/opengeospatial/ets-wms-client13/issues/13) - Update Reference Implementation link

### 0.8 (2015-03-26)
    
   * [11](https://github.com/opengeospatial/ets-wms-client13/issues/8) - 'teamengine' hardcoded in the code
    
### 0.7 (2015-03-25)

   * [7](https://github.com/opengeospatial/ets-wms-client13/issues/7) - Test not updating in Safari

### 0.6 (2015-02-20)

   * Clean documentation and prepare for release
   * [4](https://github.com/opengeospatial/ets-wms-client13/issues/4) - Test should report on the console the request that are required to perform by the client
   * [3](https://github.com/opengeospatial/ets-wms-client13/issues/3) - Improve failure reporting
   * [6](https://github.com/opengeospatial/ets-wms-client13/issues/6) - Remove option to select coverage reporting
    
### 0.5 (2014-03-11)
  
  * Resolved CITE-937: Service proxy is bypassed (requires teamengine-4.0.5 or later).
  * Moved coverage reporting into profile.
  
### 0.4 (2014-02-11)

  * Changed endpoint of target WMS (to reference implementation hosted by lat/lon).
  * Updated main.ctl to point to correct link to the web folder.

### 0.3 (2013-07-09)

  * Updated user information on the test form.
  * Updated general documentation.
