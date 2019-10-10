package com.occamlab.te.spi.jaxrs.resources.wmsclient;

import com.occamlab.te.SetupOptions;
import org.apache.commons.io.FilenameUtils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;

/**
 * Supports testing of WMS 1.3 client implementations.
 */
@Path("suiteResult")
@Produces("application/json")
public class TestFinalResult {

  private static final String TE_BASE = "TE_BASE";

  /**
   * Processes a request submitted using the GET method. The test run arguments
   * are specified in the query component of the Request-URI as a sequence of
   * key-value pairs.
   *
   * @param userId
   * @param sessionID
   * @return
   * @throws java.io.FileNotFoundException
   * @throws java.io.IOException
   */
  @GET
  public String handleGet(
          @QueryParam("userID") String userId,
          @QueryParam("sessionID") String sessionID) throws FileNotFoundException, IOException {

    File basePath=SetupOptions.getBaseConfigDirectory();
    String pathAddress = basePath + File.separator + "users" + File.separator + userId + File.separator + sessionID + File.separator + "test_data";

    //Get the Final result from file which save after stop button click.
    //Used bufferedReader to get the data from file.
    InputStream inputStreamFilePath = new FileInputStream(new File(FilenameUtils.normalize(pathAddress) + File.separator + "finalResult.txt"));
    BufferedReader fileReader = new BufferedReader(new InputStreamReader(inputStreamFilePath));
    String lineReader;
    String finalResult = "";
    while ((lineReader = fileReader.readLine()) != null) {
      finalResult = finalResult + lineReader;
    }
    return finalResult;
  }
}
