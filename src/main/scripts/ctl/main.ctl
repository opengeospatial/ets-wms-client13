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
            <xsl:variable name="wms-url" 
                          select="'http://cite.lat-lon.de/deegree-webservices-3.3.6-2/services/wms?service=WMS&amp;version=1.3.0&amp;request=GetCapabilities'" />
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
                            the client submits will be inspected and validated. The details of all the requests that are required to be executed by 
                            the client are documented in the <a href="../web/" target="_blank">test suite summary</a>.</p>

                        <p>An intercepting proxy is created to access the WMS 1.3 reference implementation. The client 
                            is expected to fully exercise the WMS implementation, including all implemented options as 
                            indicated in the 
                            <xsl:element name="a">
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$wms-url"/>
                                </xsl:attribute>
                                <xsl:text>service capabilities document</xsl:text> 
                            </xsl:element>
                        </p>

                        <p>To start testing, configure the client application to use the following proxy endpoint:</p>
                        <div style="background-color:#F0F8FF">
                            <p>
                                <xsl:value-of select="$monitor-urls/wms:GetCapabilities"/>
                            </p>
                        </div>
                        <legend style="font-family: sans-serif; color: #000099; 
			                 background-color:#F0F8FF; border-style: solid; 
                       border-width: medium; padding:4px">WMS-Client Conformence Level :</legend>
                        <fieldset style="background:#ccffff">
                            <div id="capability">
                                <img src="http://54.209.245.204/teamengine/images/warning.png" align="middle" alt="Begin" height="30" width="30"/>gc:check-GetCapabilities-request
                            </div>
                            <div id="capability_result">
                                
                            </div>
                            <div id="map">
                                <img src="http://54.209.245.204/teamengine/images/warning.png" align="middle" alt="Begin" height="30" width="30"/>gm:check-GetMap-request
                            </div>
                            <div id="map_result">
                                
                            </div>
                            <div id="feature">
                                <img src="http://54.209.245.204/teamengine/images/warning.png" align="middle" alt="Begin" height="30" width="30"/>gfi:check-GetFeatureInfo-request
                            </div> 
                            <div id="feature_result">
                                
                            </div>                           
                            <div id="show">
                            </div>
                        </fieldset>                        
                        <script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
                        <script>
                            var url = location.href;
                            var count=0;
                            var result_url=url.split("teamengine");
                            document.addEventListener('DOMContentLoaded', function() {
                                var c_name="User";
                                var c_sessionId="Sesion_ID";	
                                var c_name_value="";
                                var urlpath="";
                                var c_sessionID_value="";
                                if (document.cookie.length > 0) {
                                    c_start = document.cookie.indexOf(c_name + "=");
                                    if (c_start != -1) {
                                        c_start = c_start + c_name.length + 1;
                                        c_end = document.cookie.indexOf(";", c_start);
                                        if (c_end == -1) {
                                            c_end = document.cookie.length;
                                        }
                                        c_name_value=unescape(document.cookie.substring(c_start, c_end));
                                    }
                                    c_start = document.cookie.indexOf(c_sessionId + "=");
                                    if (c_start != -1) {
                                        c_start = c_start + c_sessionId.length + 1;
                                        c_end = document.cookie.indexOf(";", c_start);
                                        if (c_end == -1) {
                                            c_end = document.cookie.length;
                                        }
                                        c_sessionID_value=unescape(document.cookie.substring(c_start, c_end));
                                    }
                                    urlpath=result_url[0]+"teamengine/restTest/suiteJson?userID="+c_name_value  +"&amp;sessionID="+c_sessionID_value;
                                }
                                setInterval(function() {
                                    $.ajax({
                                        type:"GET", 
                                        url: urlpath, 
                                        success: function(data) {
                                            var jsonData = JSON.parse(data);
                                            var text="";	
                                            for (var i = count; i &lt; jsonData.TEST.length; i++) {
                                                var counter = jsonData.TEST[i];
                                                var data=counter.Name;
                                                if(jsonData.TEST[count].Name==="gc:check-GetCapabilities-request"){
                                                    $('#capability').remove();
                                                    var child_capabilty = $(document.createElement('div')).attr("id", 'capability_' + count);
                                                    var subchild_capabilty = $(document.createElement('div')).attr("id", 'capability_' + count+count);
                                                    var subid="capability__" + count+count;
                                                    if(counter.Indent=="1"){
                                                        child_capabilty.appendTo('#capability_result');
                                                        subchild_capabilty.appendTo('#capability_result');
                                                        if(counter.Result==="Passed"){
                                                            $('#capability_'+count).append($('<p>
                                                                <img src="http://54.209.245.204/teamengine/images/minus.png" name="image1" id="'+subid+'" onclick="toggleDiv(this);"/>
                                                                <img src="http://54.209.245.204/teamengine/images/success.png" height="20" width="20"/>
                                                                <b>'+"  "+data+'</b>
                                                            </p>'));
                                                        }else{
                                                            $('#capability_'+count).append($('<p>
                                                                <img src="http://54.209.245.204/teamengine/images/minus.png" name="image1" id="'+subid+'" onclick="toggleDiv(this);"/>
                                                                <img src="http://54.209.245.204/teamengine/images/error.png" height="20" width="20"/>
                                                                <b>'+"  "+data+'</b>
                                                            </p>'));
                                                        }
                                                    }else if(counter.Indent=="2"){
                                                        if(counter.Result==="Passed"){
                                                            $('#capability_'+count+count).append($('<p style="margin-left:50px;">
                                                                <img src="http://54.209.245.204/teamengine/images/success.png" height="20" width="20"/>'+"  "+data+'</p>'));
                                                        }
                                                        else{
                                                            $('#capability_'+count+count).append($('<p style="margin-left:50px;">
                                                                <img src="http://54.209.245.204/teamengine/images/error.png" height="20" width="20"/>'+"  "+data+'</p>'));
                                                        }
                                                    }else{
                                                        if(counter.Result==="Passed"){
                                                            $('#capability_'+count+count).append($('<p style="margin-left:100px;">
                                                                <img src="http://54.209.245.204/teamengine/images/success.png" height="20" width="20"/>'+"  "+data+'</p>'));}
                                                        else{
                                                            $('#capability_'+count+count).append($('<p style="margin-left:100px;">
                                                                <img src="http://54.209.245.204/teamengine/images/error.png" height="20" width="20"/>'+"  "+data+'</p>'));
                                                        }
                                                    }
                                                }else if(jsonData.TEST[count].Name==="gm:check-GetMap-request"){
                                                    $('#map').remove();
                                                    var child_map = $(document.createElement('div')).attr("id", 'map_' + count);
                                                    var subchild_map = $(document.createElement('div')).attr("id", 'map_' + count+count);
                                                    var subid="map__" + count+count;
                                                        if(counter.Indent=="1"){
                                                        child_map.appendTo('#map_result');
                                                        subchild_map.appendTo('#map_result');
                                                        if(counter.Result==="Passed"){
                                                            $('#map_'+count).append($('<p>
                                                                <img src="http://54.209.245.204/teamengine/images/minus.png" name="image1" id="'+subid+'" align="middle" onclick="toggleDiv(this);"/>
                                                                <img src="http://54.209.245.204/teamengine/images/success.png" align="middle" height="20" width="20"/>
                                                                <b>'+"  "+data+'</b>
                                                            </p>'));
                                                        }else{
                                                            $('#map_'+count).append($('<p>
                                                                <img src="http://54.209.245.204/teamengine/images/minus.png" name="image1" id="'+subid+'" align="middle" onclick="toggleDiv(this);"/>
                                                                <img src="http://54.209.245.204/teamengine/images/error.png" align="middle" height="20" width="20"/>
                                                                <b>'+"  "+data+'</b>
                                                            </p>'));
                                                        }
                                                    }else if(counter.Indent=="2"){
                                                        if(counter.Result==="Passed"){
                                                            $('#map_'+count+count).append($('<p style="margin-left:50px;">
                                                                <img src="http://54.209.245.204/teamengine/images/success.png" align="middle" height="20" width="20"/>'+"  "+data+'</p>'));
                                                        }else{
                                                            $('#map_'+count+count).append($('<p style="margin-left:50px;">
                                                                <img src="http://54.209.245.204/teamengine/images/error.png" align="middle" height="20" width="20"/>'+"  "+data+'</p>'));
                                                        }
                                                    }else{
                                                        if(counter.Result==="Passed"){
                                                            $('#map_'+count+count).append($('<p style="margin-left:100px;">
                                                                <img src="http://54.209.245.204/teamengine/images/success.png" align="middle" height="20" width="20"/>'+"  "+data+'</p>'));
                                                        }else{
                                                            $('#map_'+count+count).append($('<p style="margin-left:100px;">
                                                                <img src="http://54.209.245.204/teamengine/images/error.png" align="middle" height="20" width="20"/>'+"  "+data+'</p>'));
                                                        }
                                                    }
                                                }else{
                                                    $('#feature').remove();
                                                    var child_feature = $(document.createElement('div')).attr("id", 'feature_' + count);
                                                    var subchild_feature = $(document.createElement('div')).attr("id", 'feature_' + count+count);
                                                    var subid="feature__" + count+count;
                                                    if(counter.Indent=="1"){
                                                        child_feature.appendTo('#feature_result');
                                                        subchild_feature.appendTo('#feature_result');
                                                        if(counter.Result==="Passed"){
                                                            $('#feature_'+count).append($('<p>
                                                                <img src="http://54.209.245.204/teamengine/images/minus.png" align="middle"  name="image1" id="'+subid+'" onclick="toggleDiv(this);"/>
                                                                <img src="http://54.209.245.204/teamengine/images/success.png" height="20" align="middle" width="20"/>
                                                                <b>'+"  "+data+'</b>
                                                            </p>'));
                                                        }else{
                                                            $('#feature_'+count).append($('<p>
                                                                <img src="http://54.209.245.204/teamengine/images/minus.png" align="middle" name="image1" id="'+subid+'" onclick="toggleDiv(this);"/>
                                                                <img src="http://54.209.245.204/teamengine/images/error.png" align="middle" height="20" width="20"/>
                                                                <b>'+"  "+data+'</b>
                                                            </p>'));
                                                        }
                                                    }else if(counter.Indent=="2"){
                                                        if(counter.Result==="Passed"){
                                                            $('#feature_'+count+count).append($('<p style="margin-left:50px;">
                                                                <img src="http://54.209.245.204/teamengine/images/success.png" align="middle" height="20" width="20"/>'+"  "+data+'</p>'));
                                                        }else{
                                                            $('#feature_'+count+count).append($('<p style="margin-left:50px;">
                                                                <img src="http://54.209.245.204/teamengine/images/error.png" align="middle" height="20" width="20"/>'+"  "+data+'</p>'));
                                                        }
                                                    }else{
                                                        if(counter.Result==="Passed"){
                                                            $('#feature_'+count+count).append($('<p style="margin-left:100px;">
                                                                <img src="http://54.209.245.204/teamengine/images/success.png" align="middle" height="20" width="20"/>'+"  "+data+'</p>'));
                                                        }else{
                                                            $('#feature_'+count+count).append($('<p style="margin-left:100px;">
                                                                <img src="http://54.209.245.204/teamengine/images/error.png" align="middle" height="20" width="20"/>'+"  "+data+'</p>'));
                                                        }
                                                    }
                                                }
                                            }
                                            count=counter.ObjectID;
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
                            function toggleDiv(divID){
		                    var divid=$(divID).attr("id");
		                    var value=divid.split("__");
				    var path=$(divID).attr("src");
				    if(path==="http://54.209.245.204/teamengine/images/minus.png"){
				    	$("#"+divid).attr("src","http://54.209.245.204/teamengine/images/plus.png");
		                    }else if(path==="http://54.209.245.204/teamengine/images/plus.png"){
				    	$("#"+divid).attr("src","http://54.209.245.204/teamengine/images/minus.png");
				    }else{
					$("#"+divid).attr("src","http://54.209.245.204/teamengine/images/abc.png");
				    }
				    $("#"+value[0]+"_"+value[1]).toggle();
                            }
                        </script>
                        <p>Leave this form open while you use the client. Press the 'Stop testing' button when you are finished.</p>
                        <br/>
                        <input type="submit" value="Stop testing"/>
                    </ctl:form>
                </xsl:when>
                <xsl:otherwise>
                    <ctl:message>[FAIL]: Unable to create proxy endpoints.</ctl:message>
                    <ctl:fail/>
                </xsl:otherwise>
         </xsl:choose>
	<xsl:variable name="dir" select="ctl:getSessionDir()" />

	<xsl:if test="(not(doc-available(concat($dir,'/WMS1-GetCapabilities.xml')))) or (not(doc-available(concat($dir,'/WMS1-GetMap.xml')))) or (not(doc-available(concat($dir,'/WMS1-GetFeatureInfo.xml'))))"> 
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