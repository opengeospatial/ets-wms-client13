package com.occamlab.te.spi.jaxrs.resources.wmsclient;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.dom.DOMSource;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.occamlab.te.util.DomUtils;

/**
 * @author <a href="mailto:goltz@lat-lon.de">Lyn Goltz </a>
 */
public class CtlUtils {

    /**
     * Writes the requested layers by the tools into the session directory.
     *
     * @param requestedLayersDoc
     *            Document object of requested layers.
     */
    public static void storeRequestedLayers( String sessionDir, Document requestedLayersDoc ) {
        File xmlFile = new File( sessionDir, "test_data/Get-Map-Layer-New.xml" );
        try {
            if ( !xmlFile.exists() ) {
                xmlFile.createNewFile();
                PrintStream out = new PrintStream( new FileOutputStream( xmlFile ) );
                out.println( DomUtils.serializeSource( new DOMSource( requestedLayersDoc ) ) );
                out.close();
            } else {
                DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
                dbf.setNamespaceAware( true );
                dbf.setExpandEntityReferences( false );
                DocumentBuilder db = dbf.newDocumentBuilder();
                Document doc = db.parse( xmlFile );

                Node layerNode = doc.getElementsByTagName( "Layers" ).item( 0 );
                Node requestedLayerNode = requestedLayersDoc.getElementsByTagName( "Layers" ).item( 0 );
                Element requestedLayerElement = (Element) requestedLayerNode;
                NodeList requestedLayerValueList = requestedLayerElement.getElementsByTagName( "value" );
                for ( int i = 0; i < requestedLayerValueList.getLength(); i++ ) {
                    Node requestedLayerValueNode = requestedLayerValueList.item( i );
                    Node firstDocImportedNode = doc.importNode( requestedLayerValueNode, true );
                    layerNode.appendChild( firstDocImportedNode );
                }

                WmsClientDomUtils.transformDocument( doc, xmlFile );
            }
        } catch ( Exception e ) {
            throw new RuntimeException( "Failed to parse xml file: " + xmlFile + " Error: " + e.getMessage() );
        }
    }

}
