<?xml version="1.0" encoding="UTF-8"?>
<ctl:package
  xmlns:ctl="http://www.occamlab.com/ctl"
  xmlns:ctlp="http://www.occamlab.com/te/parsers"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:wms="http://www.opengis.net/wms"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:main="urn:wms_client_test_suite/main"
  xmlns:basic="urn:wms_client_test_suite/basic_elements"
  xmlns:gc="urn:wms_client_test_suite/GetCapabilities"
  xmlns:gm="urn:wms_client_test_suite/GetMap"
  xmlns:gfi="urn:wms_client_test_suite/GetFeatureInfo"
  xmlns:tec="java:com.occamlab.te.TECore"
  xmlns:saxon="http://saxon.sf.net/">

  <ctl:suite name="main:ets-wms-client">
    <ctl:title>WMS Client Test Suite</ctl:title>
    <ctl:description>Validates WMS Client Requests.</ctl:description>
    <ctl:link title="Test suite overview">about/wms-client/1.3.0/</ctl:link>
    <ctl:starting-test>main:wms-client</ctl:starting-test>
  </ctl:suite>

  <ctl:test name="main:wms-client">
    <ctl:assertion>The WMS client submits valid requests.</ctl:assertion>
    <ctl:code>
      <ctl:message>TestName: GetCapabilities</ctl:message>
      <ctl:message>
        Clause: A.1.1.2</ctl:message>
        <ctl:message>
          Purpose: Verify that a basic WMS client satisfies all requirements for a GetCapabilities request.</ctl:message>
       <ctl:message>TestName: GetMap</ctl:message>
        <ctl:message>Clause: A.1.1.3</ctl:message>
       <ctl:message>Purpose: Verify that a basic WMS client satisfies all requirements for a GetMap request.</ctl:message>
     <ctl:message>TestName: GetFeatureInfo</ctl:message>
       <ctl:message>Clause: A.2</ctl:message>
       <ctl:message>Purpose: 
         1. Verify that a basic WMS client satisfies all requirements for a GetFeatureInfo request.
         2. Verify that a WMS interface satisfies all requirements for the operation GetFeatureInfo.
       </ctl:message>
            
    <xsl:variable name="wms-url" >
     <xsl:choose>
       <xsl:when test="doc-available('http://cite.deegree.org/deegree-webservices-3.3.14-2/services/wms?service=WMS&amp;version=1.3.0&amp;request=GetCapabilities')">
         <xsl:value-of select="'http://cite.deegree.org/deegree-webservices-3.3.14-2/services/wms?service=WMS&amp;version=1.3.0&amp;request=GetCapabilities'"/>
       </xsl:when>
       <xsl:when test="doc-available('http://cite.demo.opengeo.org:8080/geoserver_wms13/wms?service=WMS&amp;request=GetCapabilities&amp;version=1.3.0')">
         <xsl:value-of select="'http://cite.demo.opengeo.org:8080/geoserver_wms13/wms?service=WMS&amp;request=GetCapabilities&amp;version=1.3.0'"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="'http://services.interactive-instruments.de/cite-xs-46/cite/cgi-bin/wms/wms/wms?request=GetCapabilities&amp;version=1.3'"/>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:variable>
      <xsl:variable name="capabilities">
        <ctl:request>
          <ctl:url>
            <xsl:value-of select="$wms-url" />
          </ctl:url>
          <ctl:method>GET</ctl:method>
        </ctl:request>
      </xsl:variable>
  
      <xsl:variable name="monitor-urls">
        <xsl:for-each select="$capabilities/wms:WMS_Capabilities/wms:Capability/wms:Request">
          <xsl:for-each select="wms:GetCapabilities|wms:GetMap|wms:GetFeatureInfo">
            <xsl:copy>
              <ctl:allocate-monitor-url>
                <xsl:value-of select="wms:DCPType/wms:HTTP/wms:Get/wms:OnlineResource/@xlink:href"/>
              </ctl:allocate-monitor-url>
            </xsl:copy>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:variable>

      <xsl:if test="string-length($monitor-urls/wms:GetCapabilities) gt 0">
        <ctl:create-monitor>
          <ctl:url>
            <xsl:value-of select="$monitor-urls/wms:GetCapabilities"/>
          </ctl:url>
          <ctl:triggers-test name="gc:check-GetCapabilities-request">
            <ctl:with-param name="capabilities" select="$capabilities/wms:WMS_Capabilities"/>
          </ctl:triggers-test>
          <ctl:with-parser modifies-response="true">
            <ctlp:XSLTransformationParser resource="rewrite-capabilities.xsl">
              <ctlp:with-param name="GetCapabilities-proxy">
                <xsl:value-of select="$monitor-urls/wms:GetCapabilities"/>
              </ctlp:with-param>
              <ctlp:with-param name="GetMap-proxy">
                <xsl:value-of select="$monitor-urls/wms:GetMap"/>
              </ctlp:with-param>
              <ctlp:with-param name="GetFeatureInfo-proxy">
                <xsl:value-of select="$monitor-urls/wms:GetFeatureInfo"/>
              </ctlp:with-param>
            </ctlp:XSLTransformationParser>
          </ctl:with-parser>
        </ctl:create-monitor>
      </xsl:if>

      <xsl:if test="string-length($monitor-urls/wms:GetMap) gt 0">
        <ctl:create-monitor>
          <ctl:url>
            <xsl:value-of select="$monitor-urls/wms:GetMap"/>
          </ctl:url>
          <ctl:triggers-test name="gm:check-GetMap-request">
            <ctl:with-param name="capabilities" select="$capabilities/wms:WMS_Capabilities"/>
          </ctl:triggers-test>
          <ctl:with-parser>
            <ctlp:NullParser/>
          </ctl:with-parser>
        </ctl:create-monitor>
      </xsl:if>

      <xsl:if test="string-length($monitor-urls/wms:GetFeatureInfo) gt 0">
        <ctl:create-monitor>
          <ctl:url>
            <xsl:value-of select="$monitor-urls/wms:GetFeatureInfo"/>
          </ctl:url>
          <ctl:triggers-test name="gfi:check-GetFeatureInfo-request">
            <ctl:with-param name="capabilities" select="$capabilities/wms:WMS_Capabilities"/>
          </ctl:triggers-test>
          <ctl:with-parser>
            <ctlp:NullParser/>
          </ctl:with-parser>
        </ctl:create-monitor>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="not($capabilities/wms:WMS_Capabilities)">
          <ctl:message>FAILURE: Did not receive a WMS_Capabilities document! Skipping remaining tests.</ctl:message>	
          <ctl:fail/>
        </xsl:when>
        <xsl:when test="string-length($monitor-urls/wms:GetCapabilities) gt 0 and string-length($monitor-urls/wms:GetMap) gt 0">
          <ctl:form method="POST" width="800" height="600" xmlns="http://www.w3.org/1999/xhtml">
            <h2>WMS 1.3 Client Test Suite</h2>
            <p>This test suite verifies that a WMS 1.3 client submits valid requests to a WMS 1.3 server. Each of the requests that 
              the client submits will be inspected and validated. The details of the requests that are required to be executed by 
              the client are documented in the <a href="." target="_blank">test suite summary</a>, and presented bellow.</p>

            <p>The client will interact with a proxy server that intercepts the requests and passed them to the 
              <xsl:element name="a">
                <xsl:attribute name="target">_blank</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="$wms-url"/>
                </xsl:attribute>
                <xsl:text>WMS 1.3 reference implementation.</xsl:text>
              </xsl:element>
              The client shall perform the request presented in the box bellow. 
            </p>

            <p>To start testing, configure the client application to use the following WMS 1.3 end point (the proxy endpoint):</p>
            <div style="background-color:#F0F8FF">
              <big><b><p>
                <xsl:value-of select="$monitor-urls/wms:GetCapabilities"/>
              </p></b></big>
            </div>

            <p><b>NOTE:</b> </p>
            <p style="margin-top: 0px;margin-bottom: 0px;">Leave this form open while you use the client. Press the 'Stop testing' button when you are finished.</p>
            <br/>
            <p style="margin-top: 0px;margin-bottom: 0px;">
             After clicking the 'Stop testing' button the proxy endpoint "<xsl:value-of select="$monitor-urls/wms:GetCapabilities"/>" will not be available any more.</p>

             <br/>
             <br/>

            <legend style="font-family: sans-serif; color: #000099; 
			                 background-color:#F0F8FF; border-style: solid; 
                       border-width: medium; padding:4px">Conformance classes and required requests to be performed by the client</legend>
            <fieldset style="background:#ccffff">
              <div id="WMS-Client">
                <img src="../../../../images/minus.png" name="image1" id="WMS-Client__result" align="middle" onclick="toggleDiv(this);"/>
                <img src="../../../../images/warning.png" id="WMS-Client-result" align="middle" alt="Begin" />
                <b>Test WMS-Client 1.3</b>
              </div>
              <div id="WMS-Client_result">
              <div id="Basic" style="margin-left:20px;">
                <img src="../../../../images/minus.png" name="image1" id="Basic__result" align="middle" onclick="toggleDiv(this);"/>
                <b>A.1.1 Basic WMS Client </b>
              </div>
              <div id="Basic_result">
                <div id="capability" style="margin-left:40px;">
                  <img src="../../../../images/minus.png" name="image1" id="capability__result" align="middle" onclick="toggleDiv(this);"></img>
                  <img src="../../../../images/warning.png" id="capability_img" align="middle" alt="Begin" />
                  <b>Perform at least one GetCapabilities request</b>
                </div>
                            
                <div id="capability_result" style="margin-left:60px;">
                </div>
                            
                <div id="map" style="margin-left:40px;">
                  <img src="../../../../images/minus.png" name="image1" id="map__result" align="middle" onclick="toggleDiv(this);"></img>
                  <img src="../../../../images/warning.png" id="map_img" align="middle" alt="Begin" />
                  <b>Perform GetMap request for all the layers</b>
                </div>
                <div id="map_result">
                            
                  <div id="Autos" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="Autos_img" align="middle" alt="Begin" ></img>
                    <b>cite:Autos</b>
                  </div>
                            
                  <div id="Autos_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="BasicPolygons" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="BasicPolygons_img" align="middle" alt="Begin" ></img>
                    <b>cite:BasicPolygons</b>
                  </div>
                            
                  <div id="BasicPolygons_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="Bridges" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="Bridges_img" align="middle" alt="Begin" ></img>
                    <b>cite:Bridges</b>
                  </div>
                            
                  <div id="Bridges_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="BuildingCenters" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="BuildingCenters_img" align="middle" alt="Begin" ></img>
                    <b>cite:BuildingCenters</b>
                  </div>
                            
                  <div id="BuildingCenters_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="Buildings" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="Buildings_img" align="middle" alt="Begin" ></img>
                    <b>cite:Buildings</b>
                  </div>
                            
                  <div id="Buildings_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="DividedRoutes" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="DividedRoutes_img" align="middle" alt="Begin" ></img>
                    <b>cite:DividedRoutes</b>
                  </div>
                            
                  <div id="DividedRoutes_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="Forests" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="Forests_img" align="middle" alt="Begin" ></img>
                    <b>cite:Forests</b>
                  </div>
                            
                  <div id="Forests_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="Lakes" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="Lakes_img" align="middle" alt="Begin" ></img>
                    <b>cite:Lakes</b>
                  </div>
                            
                  <div id="Lakes_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="MapNeatline" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="MapNeatline_img" align="middle" alt="Begin" ></img>
                    <b>cite:MapNeatline</b>
                  </div>
                            
                  <div id="MapNeatline_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="NamedPlaces" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="NamedPlaces_img" align="middle" alt="Begin" ></img>
                    <b>cite:NamedPlaces</b>
                  </div>
                            
                  <div id="NamedPlaces_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="Ponds" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="Ponds_img" align="middle" alt="Begin" ></img>
                    <b>cite:Ponds</b>
                  </div>
                            
                  <div id="Ponds_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="RoadSegments" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="RoadSegments_img" align="middle" alt="Begin" ></img>
                    <b>cite:RoadSegments</b>
                  </div>
                            
                  <div id="RoadSegments_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="Streams" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="Streams_img" align="middle" alt="Begin" ></img>
                    <b>cite:Streams</b>
                  </div>
                            
                  <div id="Streams_result" style="margin-left:80px;">
                  </div>
                            
                  <div id="Terrain" style="margin-left:60px;">
                    <img src="../../../../images/warning.png" id="Terrain_img" align="middle" alt="Begin" ></img>
                    <b>cite:Terrain</b>
                  </div>

                  <div id="Terrain_result" style="margin-left:80px;">
                  </div>
                                
                </div>
                </div>
                <div id="Queryable" style="margin-left:20px;">
                <img src="../../../../images/minus.png" name="image1" id="Queryable__result" align="middle" onclick="toggleDiv(this);"/>
                <b>A.2.1 Client for queryable WMS-GetFeatureInfo request</b>
                 </div>
                 <div id="Queryable_result">            
                <div id="feature" style="margin-left:40px;">
                  <img src="../../../../images/minus.png" name="image1" id="feature__result" align="middle" onclick="toggleDiv(this);"></img>
                  <img src="../../../../images/warning.png" id="feature_img" align="middle" alt="Begin" />
                  <b>Perform at least one GetFeatureInfo request</b>
                </div> 
                <div id="feature_result" style="margin-left:60px;">
                                
                </div>
              </div>
              </div>
              <div id="show"/>
            </fieldset>                        
            <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
            <script>
              var url = location.href;
              var count = 0;
              var method = 1;
              var result_url = url.split("/");
              var newURL="";
              for(var i=0;i &lt; 4;i++){
                if(newURL!=""){
                  newURL=newURL+"/";
                }
                newURL=newURL+result_url[i];
              }
              newURL=newURL+"/";
              var j = 0;
              var wmsClient = [];

              function test() {
                var text = $('#WMS-Client_result').html();
                var data = text;
                var urlloc = location.href;
                var result_url = urlloc.split("/");
                var newURL="";
                for(var i=0;i &lt; 4;i++){
                  if(newURL!=""){
                   newURL=newURL+"/";
                   }
                 newURL=newURL+result_url[i];
                 }
                newURL=newURL+"/";
                var c_name = "User";
                var c_sessionId = "Sesion_ID";
                var c_name_value = "";
                var c_sessionID_value = "";
                if (document.cookie.length > 0) {
                  c_start = document.cookie.indexOf(c_name + "=");
                  if (c_start != -1) {
                    c_start = c_start + c_name.length + 1;
                    c_end = document.cookie.indexOf(";", c_start);
                    if (c_end == -1) {
                      c_end = document.cookie.length;
                    }
                    c_name_value = unescape(document.cookie.substring(c_start, c_end));
                  }
                  c_start = document.cookie.indexOf(c_sessionId + "=");
                  if (c_start != -1) {
                    c_start = c_start + c_sessionId.length + 1;
                    c_end = document.cookie.indexOf(";", c_start);
                    if (c_end == -1) {
                      c_end = document.cookie.length;
                    }
                    c_sessionID_value = unescape(document.cookie.substring(c_start, c_end));
                  }
                  var url = newURL + "rest/suiteMap?userID=" + c_name_value + "&amp;sessionID=" + c_sessionID_value;
                }
                var Client = {
                  "Result": wmsClient
                };
                $.ajax({
                  url: url,
                  type: 'POST',
                  data: JSON.stringify(Client),
                  processData: false,
                  async: false,
                  contentType: 'text/plain',
                  success: function() {},
                  error: function() {}
                });
              }
              var data = {
                "id": 1,
                "Name": "Test WMS-Client 1.3",
                "ParentID": 0,
                "image": "../../../../images/warning.png",
                "node_id": "1__result",
                "node_name":"WMS-Client"
              };
              wmsClient.push(data);
              var data = {
                "id": 2,
                "Name": "Perform at least one GetCapabilities request",
                "ParentID": 1,
                "image": "../../../../images/warning.png",
                "node_id": "2__result",
                "node_name":"GetCapabilities"
              };
              wmsClient.push(data);
              var data = {
                "id": 3,
                "Name": "Perform GetMap request for all the layers",
                "ParentID": 1,
                "image": "../../../../images/warning.png",
                "node_id": "3__result",
                "node_name":"GetMap"
              };
              wmsClient.push(data);
              var data = {
                "id": 4,
                "Name": "cite:Autos",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "4__result",
                "node_name":"cite:Autos"
              };
              wmsClient.push(data);
              var data = {
                "id": 5,
                "Name": "cite:BasicPolygons",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "5__result",
                "node_name":"cite:BasicPolygons"
              };
              wmsClient.push(data);
              var data = {
                "id": 6,
                "Name": "cite:Bridges",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "6__result",
                "node_name":"cite:Bridges"
              };
              wmsClient.push(data);
              var data = {
                "id": 7,
                "Name": "cite:BuildingCenters",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "7__result",
                "node_name":"cite:BuildingCenters"
              };
              wmsClient.push(data);
              var data = {
                "id": 8,
                "Name": "cite:Buildings",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "8__result",
                "node_name":"cite:Buildings"
              };
              wmsClient.push(data);
              var data = {
                "id": 9,
                "Name": "cite:DividedRoutes",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "9__result",
                "node_name":"cite:DividedRoutes"
              };
              wmsClient.push(data);
              var data = {
                "id": 10,
                "Name": "cite:Forests",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "10__result",
                "node_name":"cite:Forests"
              };
              wmsClient.push(data);
              var data = {
                "id": 11,
                "Name": "cite:Lakes",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "11__result",
                "node_name":"cite:Lakes"
              };
              wmsClient.push(data);
              var data = {
                "id": 12,
                "Name": "cite:MapNeatline",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "12__result",
                "node_name":"cite:MapNeatline"
              };
              wmsClient.push(data);
              var data = {
                "id": 13,
                "Name": "cite:NamedPlaces",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "13__result",
                "node_name":"cite:NamedPlaces"
              };
              wmsClient.push(data);
              var data = {
                "id": 14,
                "Name": "cite:Ponds",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "14__result",
                "node_name":"cite:Ponds"
              };
              wmsClient.push(data);
              var data = {
                "id": 15,
                "Name": "cite:RoadSegments",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "15__result",
                "node_name":"cite:RoadSegments"
              };
              wmsClient.push(data);
              var data = {
                "id": 16,
                "Name": "cite:Streams",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "16__result",
                "node_name":"cite:Streams"
              };
              wmsClient.push(data);
              var data = {
                "id": 17,
                "Name": "cite:Terrain",
                "ParentID": 3,
                "image": "../../../../images/warning.png",
                "node_id": "17__result",
                "node_name":"cite:Terrain"
              };
              wmsClient.push(data);
              var data = {
                "id": 18,
                "Name": "Perform at least one GetFeatureInfo request",
                "ParentID": 1,
                "image": "../../../../images/warning.png",
                "node_id": "18__result",
                "node_name":"GetFeatureInfo"
              };
              wmsClient.push(data);
              var id = 19;
              document.addEventListener('DOMContentLoaded', function() {
                var c_name = "User";
                var c_sessionId = "Sesion_ID";
                var c_name_value = "";
                var urlpath = "";
                var urlmap = "";
                var success = "";
                var warning = "";
                var error = "";
                var c_sessionID_value = "";
                if (document.cookie.length > 0) {
                  c_start = document.cookie.indexOf(c_name + "=");
                  if (c_start != -1) {
                    c_start = c_start + c_name.length + 1;
                    c_end = document.cookie.indexOf(";", c_start);
                    if (c_end == -1) {
                      c_end = document.cookie.length;
                    }
                    c_name_value = unescape(document.cookie.substring(c_start, c_end));
                  }
                  c_start = document.cookie.indexOf(c_sessionId + "=");
                  if (c_start != -1) {
                    c_start = c_start + c_sessionId.length + 1;
                    c_end = document.cookie.indexOf(";", c_start);
                    if (c_end == -1) {
                      c_end = document.cookie.length;
                    }
                    c_sessionID_value = unescape(document.cookie.substring(c_start, c_end));
                  }
                  urlpath = newURL + "rest/suiteJson?userID=" + c_name_value + "&amp;sessionID=" + c_sessionID_value;
                  urlmap = newURL + "rest/suiteMap?userID=" + c_name_value + "&amp;sessionID=" + c_sessionID_value;
                  success = "../../../../images/pass.png";
                  error = "../../../../images/fail.png";
                  warning = "../../../../images/warning.png";
                }
                var testData={
                  "TestName": [
                  {
                    "Name": "gc:check-GetCapabilities-request",
                    "File": "WMS1-GetCapabilities.xml"
                  },
                  {
                    "Name": "gm:check-GetMap-request",
                    "File": "WMS1-GetMap.xml"
                  },
                  {
                    "Name": "gfi:check-GetFeatureInfo-request",
                    "File": "WMS1-GetFeatureInfo.xml"
                  }]
                };
                setInterval(function() {
                $.ajax({
                  type: "POST",
                  url: urlpath,
                  data: JSON.stringify(testData),
                  processData: false,
                  contentType: "text/plain",
                  success: function(data) {
                    var jsonData = JSON.parse(data);
                    var text = "";
                    if (jsonData.TEST !== undefined) {
                      for (var index = count; index &lt; jsonData.TEST.length; index++) {
                        var counter = jsonData.TEST[index];
                        var time = counter.Time;
                        if (jsonData.TEST[count].Name === "gc:check-GetCapabilities-request") {
                          if (counter.Indent == "1") {
                            if (counter.Result === "Passed") {
                              $('#capability_result').append($('<p style="margin-bottom:0px; margin-top:0px;">
                                <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") ....." + counter.Result + '</p> '));
                              if ($('#capability_img').attr("src").indexOf('fail') == -1) {
                                $('#capability_img').attr("src", success);
                              }
                              if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                if ($('#feature_result').text() == '') {
                                  $('#WMS-Client-result').attr("src", warning);
                                }
                                else {
                                  $('#WMS-Client-result').attr("src", success);
                                }
                              }
                              var data = {
                                "id": id,
                                "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                "ParentID": 2,
                                "image": success,
                                "indent":2
                              };
                              wmsClient.push(data);
                              wmsClient[0].image = success;
                              id++;
                              method++;
                            }
                            else {
                              $('#capability_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                <img src = "' + error + '" > </img>' + "  Request " + method + " (" + time + ") ....." + counter.Result + '</p > '));
                              $('#capability_img').attr("src", error);
                              if ($('#feature_result').text() == '') {
                                $('#WMS-Client-result').attr("src", warning);
                              }
                              else {
                                $('#WMS-Client-result').attr("src", error);
                              }
                              var data = {
                                "id": id,
                                "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                "ParentID": 2,
                                "image": error,
                                "indent":2
                              };
                              wmsClient.push(data);
                              wmsClient[0].image = error;
                              id++;
                              method++;
                            }
                          }
                        }
                        else if (jsonData.TEST[count].Name === "gm:check-GetMap-request") {
                          if (counter.Indent == "1") {
                            $.ajax({
                              type: "GET",
                              url: urlmap,
                              success: function(data1) {
                                var jsonData = JSON.parse(data1);
                                var text = "";
                                j = 0;
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:Autos") {
                                    $('#Autos_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#Autos_img').attr("src").indexOf('warning') > -1) {
                                      $('#Autos_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 4,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[3].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:BasicPolygons") {
                                    $('#BasicPolygons_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#BasicPolygons_img').attr("src").indexOf('warning') > -1) {
                                     $('#BasicPolygons_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                     $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 5,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[4].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:Bridges") {
                                    $('#Bridges_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#Bridges_img').attr("src").indexOf('warning') > -1) {
                                      $('#Bridges_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 6,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[5].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:BuildingCenters") {
                                    $('#BuildingCenters_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#BuildingCenters_img').attr("src").indexOf('warning') > -1) {
                                      $('#BuildingCenters_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 7,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[6].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:Buildings") {
                                    $('#Buildings_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#Buildings_img').attr("src").indexOf('warning') > -1) {
                                      $('#Buildings_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 8,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[7].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:DividedRoutes") {
                                    $('#DividedRoutes_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#DividedRoutes_img').attr("src").indexOf('warning') > -1) {
                                      $('#DividedRoutes_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 9,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[8].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:Forests") {
                                    $('#Forests_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#Forests_img').attr("src").indexOf('warning') > -1) {
                                      $('#Forests_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 10,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[9].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:Lakes") {
                                    $('#Lakes_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#Lakes_img').attr("src").indexOf('warning') > -1) {
                                     $('#Lakes_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 11,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[10].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:MapNeatline") {
                                    $('#MapNeatline_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#MapNeatline_img').attr("src").indexOf('warning') > -1) {
                                      $('#MapNeatline_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 12,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[11].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:NamedPlaces") {
                                    $('#NamedPlaces_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#NamedPlaces_img').attr("src").indexOf('warning') > -1) {
                                      $('#NamedPlaces_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 13,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[12].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:Ponds") {
                                    $('#Ponds_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#Ponds_img').attr("src").indexOf('warning') > -1) {
                                      $('#Ponds_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 14,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[13].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:RoadSegments") {
                                    $('#RoadSegments_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#RoadSegments_img').attr("src").indexOf('warning') > -1) {
                                      $('#RoadSegments_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 15,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[14].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:Streams") {
                                    $('#Streams_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#Streams_img').attr("src").indexOf('warning') > -1) {
                                      $('#Streams_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 16,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[15].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (jsonData.TEST[j] !== undefined) {
                                  if (jsonData.TEST[j].Name === "cite:Terrain") {
                                    $('#Terrain_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                      <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") .....Passed" + '</p > '));
                                    if ($('#Terrain_img').attr("src").indexOf('warning') > -1) {
                                      $('#Terrain_img').attr("src", success);
                                    }
                                    if ($('#WMS-Client-result').attr("src").indexOf('warning') > -1) {
                                      $('#WMS-Client-result').attr("src", success);
                                    }
                                    var data = {
                                      "id": id,
                                      "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                      "ParentID": 17,
                                      "image": success,
                                      "indent":4
                                    };
                                    wmsClient.push(data);
                                    wmsClient[16].image = success;
                                    wmsClient[0].image = success;
                                    id++;
                                    j++;
                                  }
                                }
                                if (($('#Autos_result').text() == '') || ($('#BasicPolygons_result').text() == '') || ($('#Bridges_result').text() == '') || ($('#BuildingCenters_result').text() == '') || ($('#Buildings_result').text() == '') || ($('#DividedRoutes_result').text() == '') || ($('#Forests_result').text() == '') || ($('#Lakes_result').text() == '') || ($('#MapNeatline_result').text() == '') || ($('#NamedPlaces_result').text() == '') || ($('#Ponds_result').text() == '') || ($('#RoadSegments_result').text() == '') || ($('#Streams_result').text() == '') || ($('#Terrain_result').text() == '')) {
                                  if ($('#WMS-Client-result').attr("src").indexOf('fail') == -1) {
                                   $('#WMS-Client-result').attr("src", "../../../../images/fail_map.png");
                                  }
                                  $('#map_img').attr("src", "../../../../images/fail_map.png");
                                }
                                else {
                                  $('#map_img').attr("src", "../../../../images/pass.png");
                                  if ($('#WMS-Client-result').attr("src").indexOf('fail_map') > -1) {
                                    if ($('#feature_result').text() == '') {
                                      $('#WMS-Client-result').attr("src", "../../../../images/warning.png");
                                    }
                                    else {
                                      $('#WMS-Client-result').attr("src", "../../../../images/pass.png");
                                    }
                                  }
                                }
                                method++;
                              },
                              error: function(jqXHR, textStatus, errorThrown) {
                                $('#show').text("");
                              },
                              dataType: "text"
                            });
                          }
                        }
                        else {
                          if (counter.Indent == "1") {
                            if (counter.Result === "Passed") {
                              $('#feature_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                                <img src = "' + success + '" > </img>' + "  Request " + method + " (" + time + ") ....." + counter.Result + '</p > '));

                              if ($('#feature_img').attr("src").indexOf('fail') == -1) {
                               $('#feature_img').attr("src", success);
                              }
                              var data = {
                                "id": id,
                                "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                                "ParentID": 18,
                                "image": success,
                                "indent":2
                              };
                              wmsClient.push(data);
                              wmsClient[0].image = success;
                              id++;
                            }
                            else {
                            $('#feature_result').append($('<p style="margin-bottom:0px; margin-top:0px;"> 
                              <img src = "' + error + '" > </img>' + "  Request " + method + " (" + time + ") ....." + counter.Result + '</p > '));
                            $('#feature_img').attr("src", error);
                            var data = {
                              "id": id,
                              "Name": "Request " + method + " (" + time + ") ....." + counter.Result,
                              "ParentID": 18,
                              "image": error,
                              "indent":2
                            };
                            wmsClient.push(data);
                            wmsClient[0].image = error;
                            id++;
                            }
                            method++;
                          }
                        }
                      }
                      if (counter !== undefined) {
                        count = counter.ObjectID;
                      }
                    }
                  },
                  error: function(jqXHR, textStatus, errorThrown) {
                    $('#show').text("");
                  },
                  dataType: "text"
                  });
                }, 0500);
              }, false);
            </script>
            <script type="text/javascript">
              function toggleDiv(divID) {
                var divid = $(divID).attr("id");
                var value = divid.split("__");
                var path = $(divID).attr("src");
                var result_url = url.split("teamengine");
                var expend = "../../../../images/plus.png";
                var merge = "../../../../images/minus.png";
                var other = newURL + "images/abc.png";
                if (path.indexOf('minus') > -1) {
                  $("#" + divid).attr("src", expend);
                } else if (path.indexOf('plus') > -1) {
                  $("#" + divid).attr("src", merge);
                } else {
                  $("#" + divid).attr("src", other);
                }
                $("#" + value[0] + "_" + value[1]).toggle();
              }
            </script>
            <br/>
            <br/>
            <input id="stopTest" type="submit" value="Stop testing" onclick="test()"/>
          </ctl:form>
        </xsl:when>
        <xsl:otherwise>
          <ctl:message>[FAIL]: Unable to create proxy endpoints.</ctl:message>
          <ctl:fail/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="dir" select="ctl:getSessionDir()" />

      <xsl:if test="(not(doc-available(concat($dir,'/test_data/WMS1-GetCapabilitiesPass.xml')))) or (not(doc-available(concat($dir,'/test_data/WMS1-GetMapPass.xml'))))"> 
        <ctl:fail/>
      </xsl:if>
    </ctl:code>
  </ctl:test>

  <ctl:profile name="main:client-coverage">
    <ctl:title>WMS Client Coverage</ctl:title>
    <ctl:description>Checks that a WMS client exercises all capabilities of the WMS service.</ctl:description>
    <ctl:defaultResult>Pass</ctl:defaultResult>
    <ctl:base>main:ets-wms-client</ctl:base>
    <ctl:starting-test>main:check-coverage</ctl:starting-test>
  </ctl:profile>

  <ctl:test name="main:check-coverage">
    <!-- See com.occamlab.te.web.CoverageMonitor -->
    <?ctl-msg name="coverage" ?>
    <ctl:assertion>Service capabilities were fully covered by the client.</ctl:assertion>
    <ctl:code>
      <xsl:variable name="session-dir" select="ctl:getSessionDir()" />
      <xsl:variable name="coverage-results">
        <service-requests>
          <xsl:for-each select="collection(concat($session-dir,'?select=WMS-*.xml'))">
            <xsl:copy-of select="doc(document-uri(.))"/>
          </xsl:for-each>
        </service-requests>
      </xsl:variable>
      <xsl:if test="count($coverage-results//param) > 0">
        <ctl:message>[FAIL]: Some service capabilities were not exercised by the client. All &lt;request&gt; 
          elements shown below should be empty--if not, some supported options were not requested by the client.</ctl:message>
        <ctl:message>
          <xsl:value-of select="saxon:serialize($coverage-results, 'coverage')" />
        </ctl:message>
        <ctl:fail/>
      </xsl:if>
    </ctl:code>
  </ctl:test>

  <ctl:function name="main:parse-list">
    <ctl:param name="list"/>
    <ctl:code>
      <xsl:choose>
        <xsl:when test="contains($list, ',')">
          <value>
            <xsl:value-of select="substring-before($list, ',')"/>
          </value>
          <ctl:call-function name="main:parse-list">
            <ctl:with-param name="list" select="substring-after($list, ',')"/>
          </ctl:call-function>
        </xsl:when>
        <xsl:otherwise>
          <value>
            <xsl:value-of select="$list"/>
          </value>
        </xsl:otherwise>
      </xsl:choose>
    </ctl:code>
  </ctl:function>
</ctl:package>