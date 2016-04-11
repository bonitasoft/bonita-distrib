import org.bonitasoft.web.extension.rest.*

import javax.servlet.http.HttpServletRequest

public class Xml implements RestApiController {

   @Override
    RestApiResponse doHandle(HttpServletRequest request, RestApiResponseBuilder apiResponseBuilder, RestAPIContext context) {

        def String xmlResponse
        context.resourceProvider.getResourceAsStream("xml/demo.xml").withStream { InputStream s ->
            xmlResponse = s.getText()
        }

        apiResponseBuilder.with {
            withResponse(xmlResponse)
            withMediaType("application/xml")
            withCharacterSet("ISO-8859-5")
            build()
        }
    }

}
