package com.occamlab.te.spi.jaxrs.resources.wmsclient;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.Stack;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.io.FilenameUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.occamlab.te.SetupOptions;

import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;

/**
 * Supports testing of WMS 1.3 client implementations.
 */
@Path("suiteMap")
@Produces("application/json")
public class TestMapResources {

	private static final String TE_BASE = "TE_BASE";

	/**
	 * Processes a request submitted using the GET method. The test run arguments are
	 * specified in the query component of the Request-URI as a sequence of key-value
	 * pairs.
	 * @param userId
	 * @param sessionID
	 * @return
	 * @throws java.io.IOException
	 * @throws org.json.JSONException
	 * @throws javax.xml.parsers.ParserConfigurationException
	 * @throws org.xml.sax.SAXException
	 */
	@GET
	public String handleGet(@QueryParam("userID") String userId, @QueryParam("sessionID") String sessionID,
			@QueryParam("modifiedTime") String modifiedTime)
			throws IOException, JSONException, ParserConfigurationException, SAXException {

		File basePath = SetupOptions.getBaseConfigDirectory();
		String xmlFile = basePath + File.separator + "users" + File.separator + userId + File.separator + sessionID
				+ File.separator + "test_data" + File.separator + File.separator + "Get-Map-Layer-New.xml";

		DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
		// This is the PRIMARY defense. If DTDs (doctypes) are disallowed, almost all XML
		// entity attacks are prevented
		// Xerces 2 only -
		// http://xerces.apache.org/xerces2-j/features.html#disallow-doctype-decl
		String FEATURE = "http://apache.org/xml/features/disallow-doctype-decl";
		docBuilderFactory.setFeature(FEATURE, true);
		DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
		// Get-Map-layer-New.xml file contain all layer names which are run by Get-Map
		// method.
		Document mapLayerDocument = docBuilder.parse(new File(xmlFile));

		JSONObject jsonObj = new JSONObject();

		// Get Node list from xml file.
		NodeList listOfLayerValues = null;
		try {
			XPath xPath = XPathFactory.newInstance().newXPath();
			String expression = "/Layers//value[not(@isProcessed)]";
			listOfLayerValues = (NodeList) xPath.compile(expression).evaluate(mapLayerDocument, XPathConstants.NODESET);
		}
		catch (XPathExpressionException e) {
			e.printStackTrace();
		}

		// Get the name of each layer from nodelist and inserting into stack.
		// Update the each processed layer with the 'isProcessed' attribute so,
		// we can understand the layer is processed or not.
		Stack mapLayerTestDetail = new Stack();
		if (null != listOfLayerValues && listOfLayerValues.getLength() > 0) {
			for (int index = 0; index < listOfLayerValues.getLength(); index++) {
				Node valueElement = listOfLayerValues.item(index);
				mapLayerTestDetail.push((valueElement.getFirstChild().toString().split(" ")[1]).split("]")[0]);
				((Element) valueElement).setAttribute("isProcessed", "true");
			}
		}
		WmsClientDomUtils.transformDocument(mapLayerDocument, new File(xmlFile));

		// Put all layer name into jsonArray.
		JSONArray jsonArr = new JSONArray();
		while (!mapLayerTestDetail.isEmpty()) {
			JSONObject mapLayerTestObject = new JSONObject();
			mapLayerTestObject.put("Name", mapLayerTestDetail.peek());
			mapLayerTestDetail.pop();
			jsonArr.put(mapLayerTestObject);
		}
		jsonObj.put("TEST", jsonArr);
		return FilenameUtils.normalize(jsonObj.toString());
	}

	/**
	 * Processes a request submitted using the POST method. The test run arguments are
	 * specified in the query component of the Request-URI as a sequence of key-value
	 * pairs.
	 * @param userId
	 * @param sessionID
	 * @param data
	 * @throws java.io.IOException
	 * @throws javax.xml.transform.TransformerException
	 * @throws javax.xml.transform.TransformerConfigurationException
	 * @throws java.io.FileNotFoundException
	 * @throws javax.xml.parsers.ParserConfigurationException
	 */
	@POST
	@Consumes({ MediaType.TEXT_PLAIN })
	public void handlepost(@QueryParam("userID") String userId, @QueryParam("sessionID") String sessionID, String data)
			throws ParserConfigurationException, TransformerException, TransformerConfigurationException,
			FileNotFoundException, IOException {
		File basePath = SetupOptions.getBaseConfigDirectory();
		// Save data into file which comes through Rest end point.
		String pathAddress = basePath + File.separator + "users" + File.separator + userId + File.separator + sessionID
				+ File.separator + "test_data";
		File fulePath = new File(FilenameUtils.normalize(pathAddress), File.separator + "finalResult.txt");
		OutputStreamWriter writerBefore = new OutputStreamWriter(new FileOutputStream(fulePath, true), "UTF-8");
		try (BufferedWriter fbwBefore = new BufferedWriter(writerBefore)) {
			fbwBefore.write(data);
			fbwBefore.newLine();
			fbwBefore.close();
		}

	}

}
