import groovy.json.JsonBuilder
import org.bonitasoft.web.extension.rest.*
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest
import java.util.logging.Logger

public class Log implements RestApiController {

    private static final Logger LOGGER = LoggerFactory.getLogger(Log.class)
    
    @Override
    RestApiResponse doHandle(HttpServletRequest request, RestApiResponseBuilder apiResponseBuilder, RestAPIContext context) {

        LOGGER.info "info message from REST API extension example"
        LOGGER.finest "finest message from REST API extension example"
        LOGGER.severe "severe message from REST API extension example"

        Map<String, Serializable> response = [:]
        response.put "response", "hello with log"
        response.put "actual logger name", LOGGER.name
        apiResponseBuilder.with {
            withResponse new JsonBuilder(response).toPrettyString()
            build()
        }

    }

}
