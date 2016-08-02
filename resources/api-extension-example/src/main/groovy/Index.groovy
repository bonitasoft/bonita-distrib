import groovy.json.JsonBuilder

import org.bonitasoft.web.extension.rest.*

import javax.servlet.http.Cookie
import javax.servlet.http.HttpServletRequest

public class Index implements RestApiController {

    @Override
    RestApiResponse doHandle(HttpServletRequest request, RestApiResponseBuilder apiResponseBuilder, RestAPIContext context) {
        Map<String, String> response = [:]
        response.with {
            put "cookie added","myCookie"
            put "header added","awesome header"
            put "response status changed","201"
        }

        apiResponseBuilder.with {
            withResponse(new JsonBuilder(response).toPrettyString())
            withAdditionalHeader("awesome header", "some value")
            withAdditionalCookie(new Cookie("myCookie", "cookie value"))
            withResponseStatus(201)
            build()
        }
    }
}
