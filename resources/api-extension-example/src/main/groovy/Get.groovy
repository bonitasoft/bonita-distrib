import groovy.json.JsonBuilder

import javax.servlet.http.HttpServletRequest

import org.bonitasoft.web.extension.rest.*

public class Get implements RestApiController {

    @Override
    RestApiResponse doHandle(HttpServletRequest request, RestApiResponseBuilder apiResponseBuilder, RestAPIContext context) {
        Map<String, String> response = [:]
        response.put "response", "hello from get resource"
        response.putAll request.parameterMap
        apiResponseBuilder.with {
            withResponse new JsonBuilder(response).toPrettyString()
            build()
        }
    }
}
