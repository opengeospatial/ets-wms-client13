package com.occamlab.te.spi.jaxrs.resources.wmsclient;

import java.io.File;
import java.io.FileOutputStream;

import org.w3c.dom.Document;
import org.w3c.dom.bootstrap.DOMImplementationRegistry;
import org.w3c.dom.ls.DOMImplementationLS;
import org.w3c.dom.ls.LSOutput;
import org.w3c.dom.ls.LSSerializer;

/**
 * @author <a href="mailto:goltz@lat-lon.de">Lyn Goltz </a>
 */
public class WmsClientDomUtils {

	/**
	 * Write document object to XML file
	 * @param doc Document object
	 * @param xmlFile XML file path which we have to write the result.
	 */
	public static void transformDocument(Document doc, File xmlFile) {
		try {
			DOMImplementationRegistry domRegistry = DOMImplementationRegistry.newInstance();
			DOMImplementationLS lsFactory = (DOMImplementationLS) domRegistry.getDOMImplementation("LS 3.0");

			LSSerializer serializer = lsFactory.createLSSerializer();
			serializer.getDomConfig().setParameter("xml-declaration", Boolean.FALSE);
			serializer.getDomConfig().setParameter("format-pretty-print", Boolean.TRUE);
			LSOutput output = lsFactory.createLSOutput();
			output.setEncoding("UTF-8");

			FileOutputStream os = new FileOutputStream(xmlFile, false);
			output.setByteStream(os);
			serializer.write(doc, output);
			os.close();
		}
		catch (Exception e) {
			throw new RuntimeException("Failed to update XML file. " + e.getMessage());
		}
	}

}
